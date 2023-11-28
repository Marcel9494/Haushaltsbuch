import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/components/dialogs/choice_dialog.dart';
import '/components/deco/loading_indicator.dart';
import '/components/input_fields/account_type_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/text_input_field.dart';
import '/components/input_fields/preselect_account_input_field.dart';
import '/components/buttons/save_button.dart';

import '/models/enums/repeat_types.dart';
import '/models/booking/booking_model.dart';
import '/models/account/account_model.dart';
import '/models/enums/transaction_types.dart';
import '/models/account/account_repository.dart';
import '/models/primary_account/primary_account_model.dart';
import '/models/primary_account/primary_account_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class CreateOrEditAccountScreen extends StatefulWidget {
  final int accountBoxIndex;

  const CreateOrEditAccountScreen({
    Key? key,
    required this.accountBoxIndex,
  }) : super(key: key);

  @override
  State<CreateOrEditAccountScreen> createState() => _CreateOrEditAccountScreenState();
}

class _CreateOrEditAccountScreenState extends State<CreateOrEditAccountScreen> {
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

  String _accountNameErrorText = '';
  String _accountGroupErrorText = '';
  String _bankBalanceErrorText = '';
  late Account _loadedAccount;
  late List<PrimaryAccount> _loadedPrimaryAccounts;
  double _oldBankBalance = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.accountBoxIndex != -1) {
      _loadAccount();
    }
  }

  Future<void> _loadAccount() async {
    _loadedAccount = await accountRepository.load(widget.accountBoxIndex);
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
      if (widget.accountBoxIndex == -1) {
        accountRepository.create(_account);
        _navigateToAccountScreen();
      } else {
        if (_oldBankBalance != formatMoneyAmountToDouble(_bankBalanceTextController.text)) {
          showChoiceDialog(context, 'Buchung erfassen?', _recordBooking, _noPressed, 'Buchung wurde erstellt', 'Buchung wurde erfolgreich erstellt.', Icons.info_outline,
              'Der Betragsunterschied wurde in deinem Account gespeichert. Möchtest du die Differenz als ${_oldBankBalance >= formatMoneyAmountToDouble(_bankBalanceTextController.text) ? TransactionType.outcome.name : TransactionType.income.name} erfassen?');
        } else {
          _updateAccount();
        }
      }
    }
  }

  Future<bool> _validAccountName(String accountNameInput) async {
    if (_accountNameController.text.isEmpty) {
      setState(() {
        _accountNameErrorText = 'Bitte geben Sie einen Kontonamen ein.';
      });
      return false;
    }
    if (widget.accountBoxIndex == -1) {
      bool accountNameExisting = await accountRepository.existsAccountName(_accountNameController.text);
      if (accountNameExisting) {
        setState(() {
          _accountNameErrorText = 'Konto ist bereits angelegt.';
        });
        return false;
      }
    }
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

  void _recordBooking() {
    String transactionType = '';
    double difference = 0.0;
    if (_oldBankBalance >= formatMoneyAmountToDouble(_bankBalanceTextController.text)) {
      transactionType = TransactionType.outcome.name;
    } else {
      transactionType = TransactionType.income.name;
    }
    difference = (_oldBankBalance - formatMoneyAmountToDouble(_bankBalanceTextController.text)).abs();
    Booking newBooking = Booking()
      ..transactionType = transactionType
      ..bookingRepeats = RepeatType.noRepetition.name
      ..title = 'Betrag Änderung'
      ..date = DateTime.now().toString()
      ..amount = formatToMoneyAmount(difference.toString())
      ..categorie = 'Differenz'
      ..fromAccount = _accountNameController.text
      ..toAccount = _accountNameController.text;
    // TODO newBooking.createBooking();
    // TODO entfernen? newBooking.createBooking(newBooking);
    accountRepository.update(_account, widget.accountBoxIndex, _loadedAccount.name);
    for (int i = 0; i < 4; i++) {
      Navigator.pop(context);
    }
    Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
  }

  void _noPressed() {
    accountRepository.update(_account, widget.accountBoxIndex, _loadedAccount.name);
    for (int i = 0; i < 4; i++) {
      Navigator.pop(context);
    }
    Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
  }

  void _updateAccount() {
    accountRepository.update(_account, widget.accountBoxIndex, _loadedAccount.name);
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: widget.accountBoxIndex == -1 ? const Text('Konto erstellen') : const Text('Konto bearbeiten'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Card(
            color: const Color(0xff1c2b30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: FutureBuilder(
              future: widget.accountBoxIndex == -1
                  ? null
                  : _isAccountEdited
                      ? null
                      : _loadAccount(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const LoadingIndicator();
                  default:
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AccountTypeInputField(textController: _accountGroupTextController, errorText: _accountGroupErrorText),
                        // TODO TextInputField(textEditingController: _accountNameController, errorText: _accountNameErrorText, hintText: 'Name'),
                        // TODO MoneyInputField(
                        //    textController: _bankBalanceTextController, errorText: _bankBalanceErrorText, hintText: 'Kontostand', bottomSheetTitle: 'Kontostand eingeben:'),
                        PreselectAccountInputField(textController: _preselectedAccountTextController),
                        SaveButton(saveFunction: _createOrUpdateAccount, buttonController: _saveButtonController),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
