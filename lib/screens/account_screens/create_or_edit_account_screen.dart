import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../blocs/primary_account_bloc/primary_account_bloc.dart';
import '/blocs/account_bloc/account_bloc.dart';
import '/blocs/input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import '/blocs/input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '/blocs/input_field_blocs/account_type_input_field_bloc/account_type_input_field_cubit.dart';
import '/blocs/input_field_blocs/preselect_account_input_field_bloc/preselect_account_input_field_cubit.dart';

import '/components/deco/loading_indicator.dart';
import '/components/input_fields/account_type_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/text_input_field.dart';
import '/components/input_fields/preselect_account_input_field.dart';
import '/components/buttons/save_button.dart';

import '/models/account/account_model.dart';
import '/models/account/account_repository.dart';
import '/models/primary_account/primary_account_model.dart';
import '/models/primary_account/primary_account_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class CreateOrEditAccountScreen extends StatefulWidget {
  const CreateOrEditAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditAccountScreen> createState() => _CreateOrEditAccountScreenState();
}

class _CreateOrEditAccountScreenState extends State<CreateOrEditAccountScreen> {
  late final AccountBloc accountBloc;
  final TextEditingController _accountGroupTextController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _bankBalanceTextController = TextEditingController();
  final TextEditingController _preselectedAccountTextController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  final AccountRepository accountRepository = AccountRepository();
  final PrimaryAccountRepository primaryAccountRepository = PrimaryAccountRepository();
  bool _isAccountEdited = false;
  bool _primaryAccountsLoaded = false;
  final Account _account = Account();

  late final AccountTypeInputFieldCubit accountTypeInputFieldCubit;
  late final TextInputFieldCubit accountNameInputFieldCubit;
  late final MoneyInputFieldCubit accountBalanceInputFieldCubit;
  late final PreselectAccountInputFieldCubit preselectedAccountInputFieldCubit;

  UniqueKey accountNameFieldUniqueKey = UniqueKey();

  FocusNode accountTypeFocusNode = FocusNode();
  FocusNode accountNameFocusNode = FocusNode();
  FocusNode accountBalanceFocusNode = FocusNode();
  FocusNode preselectedAccountFocusNode = FocusNode();

  String _accountNameErrorText = '';
  String _accountGroupErrorText = '';
  String _bankBalanceErrorText = '';
  late Account _loadedAccount;
  late List<PrimaryAccount> _loadedPrimaryAccounts;
  double _oldBankBalance = 0.0;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    BlocProvider.of<PrimaryAccountBloc>(context).add(LoadPrimaryAccountEvent(context));
    accountTypeInputFieldCubit = BlocProvider.of<AccountTypeInputFieldCubit>(context);
    accountNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
    accountBalanceInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(context);
    preselectedAccountInputFieldCubit = BlocProvider.of<PreselectAccountInputFieldCubit>(context);
    //if (widget.accountBoxIndex != -1) {
    //  _loadAccount();
    //}
  }

  Future<void> _loadAccount() async {
    //_loadedAccount = await accountRepository.load(widget.accountBoxIndex);
    _accountNameController.text = _loadedAccount.name;
    _accountGroupTextController.text = _loadedAccount.accountType;
    _bankBalanceTextController.text = _loadedAccount.bankBalance;
    _oldBankBalance = formatMoneyAmountToDouble(_loadedAccount.bankBalance);
    _isAccountEdited = true;
    if (_primaryAccountsLoaded == false) {
      _getPrimaryAccounts();
      _primaryAccountsLoaded = true;
    }
  }

  void _createOrUpdateAccount() async {
    _account.name = _accountNameController.text;
    bool validAccountName = await _validAccountName(_accountNameController.text);
    bool validAccountGroup = _validAccountGroup(_accountGroupTextController.text);
    bool validBankBalance = _validBankBalance(_bankBalanceTextController.text);
    if (validAccountGroup == false || validAccountName == false || validBankBalance == false) {
      _setSaveButtonAnimation(false);
    } else {
      _account.accountType = _accountGroupTextController.text;
      _account.bankBalance = _bankBalanceTextController.text;
      primaryAccountRepository.setPrimaryAccountNames(_preselectedAccountTextController.text, _account.name);
      /*if (widget.accountBoxIndex == -1) {
        accountRepository.create(_account);
        _navigateToAccountScreen();
      } else {
        if (_oldBankBalance != formatMoneyAmountToDouble(_bankBalanceTextController.text)) {
          showChoiceDialog(context, 'Buchung erfassen?', _recordBooking, _noPressed, 'Buchung wurde erstellt', 'Buchung wurde erfolgreich erstellt.', Icons.info_outline,
              'Der Betragsunterschied wurde in deinem Account gespeichert. Möchtest du die Differenz als ${_oldBankBalance >= formatMoneyAmountToDouble(_bankBalanceTextController.text) ? TransactionType.outcome.name : TransactionType.income.name} erfassen?');
        } else {
          _updateAccount();
        }
      }*/
    }
  }

  Future<bool> _validAccountName(String accountNameInput) async {
    if (_accountNameController.text.isEmpty) {
      setState(() {
        _accountNameErrorText = 'Bitte geben Sie einen Kontonamen ein.';
      });
      return false;
    }
    /*if (widget.accountBoxIndex == -1) {
      bool accountNameExisting = await accountRepository.existsAccountName(_accountNameController.text);
      if (accountNameExisting) {
        setState(() {
          _accountNameErrorText = 'Konto ist bereits angelegt.';
        });
        return false;
      }
    }*/
    _accountNameErrorText = '';
    return true;
  }

  bool _validAccountGroup(String accountGroupInput) {
    if (_accountGroupTextController.text.isEmpty) {
      setState(() {
        _accountGroupErrorText = 'Bitte wählen Sie einen Kontotyp aus.';
      });
      return false;
    }
    _accountGroupErrorText = '';
    return true;
  }

  bool _validBankBalance(String bankBalanceInput) {
    if (_bankBalanceTextController.text.isEmpty) {
      setState(() {
        _bankBalanceErrorText = 'Bitte geben Sie einen Kontostand ein.';
      });
      return false;
    }
    _bankBalanceErrorText = '';
    return true;
  }

  void _setSaveButtonAnimation(bool successful) {
    successful ? _saveButtonController.success() : _saveButtonController.error();
    if (successful == false) {
      Timer(const Duration(seconds: 1), () {
        _saveButtonController.reset();
      });
    }
  }

  void _updateAccount() {
    //accountRepository.update(_account, widget.accountBoxIndex, _loadedAccount.name);
    _navigateToAccountScreen();
  }

  void _navigateToAccountScreen() {
    _setSaveButtonAnimation(true);
    Timer(const Duration(milliseconds: transitionInMs), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
      }
    });
  }

  void _getPrimaryAccounts() async {
    _loadedPrimaryAccounts = await primaryAccountRepository.loadFilteredPrimaryAccountList(_accountNameController.text);
    for (int i = 0; i < _loadedPrimaryAccounts.length; i++) {
      if (_loadedPrimaryAccounts[i].accountName != '') {
        if (_preselectedAccountTextController.text.isNotEmpty) {
          _preselectedAccountTextController.text += ', ';
        }
        _preselectedAccountTextController.text += _loadedPrimaryAccounts[i].transactionType;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          if (accountState is AccountLoadingState) {
            return const LoadingIndicator();
          } else if (accountState is AccountLoadedState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: accountState.accountBoxIndex == -1 ? const Text('Konto erstellen') : const Text('Konto bearbeiten'),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                child: Card(
                  color: const Color(0xff1c2b30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<AccountTypeInputFieldCubit, AccountTypeInputFieldModel>(
                        builder: (context, state) {
                          return AccountTypeInputField(cubit: accountTypeInputFieldCubit, focusNode: accountTypeFocusNode);
                        },
                      ),
                      BlocBuilder<TextInputFieldCubit, TextInputFieldModel>(
                        builder: (context, state) {
                          return TextInputField(fieldKey: accountNameFieldUniqueKey, focusNode: accountNameFocusNode, textCubit: accountNameInputFieldCubit, hintText: 'Name');
                        },
                      ),
                      BlocBuilder<MoneyInputFieldCubit, MoneyInputFieldModel>(
                        builder: (context, state) {
                          return MoneyInputField(
                              focusNode: accountBalanceFocusNode, cubit: accountBalanceInputFieldCubit, hintText: 'Kontostand', bottomSheetTitle: 'Kontostand eingeben:');
                        },
                      ),
                      BlocBuilder<PreselectAccountInputFieldCubit, PreselectAccountInputFieldModel>(
                        builder: (context, state) {
                          return PreselectAccountInputField(cubit: preselectedAccountInputFieldCubit, focusNode: preselectedAccountFocusNode);
                        },
                      ),
                      SaveButton(
                          saveFunction: () => accountBloc.add(CreateOrUpdateAccountEvent(context, accountState.accountBoxIndex, _saveButtonController)),
                          buttonController: _saveButtonController),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("Fehler bei Kontoseite");
          }
        },
      ),
    );
  }
}
