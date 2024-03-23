import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/account_bloc/account_bloc.dart';
import '/blocs/input_field_blocs/account_input_field_bloc/from_account_input_field_cubit.dart';

import '/components/buttons/month_picker_buttons.dart';
import '/components/tab_views/monthly_booking_tab_view.dart';
import '/components/bottom_sheets/account_list_bottom_sheet.dart';
import '/components/dialogs/choice_dialog.dart';
import '/components/dialogs/info_dialog.dart';

import '/models/account/account_model.dart';
import '/models/account/account_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class AccountDetailsScreen extends StatefulWidget {
  final Account account;

  const AccountDetailsScreen({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late final FromAccountInputFieldCubit fromAccountInputFieldCubit;

  FocusNode fromAccountFocusNode = FocusNode();

  DateTime _selectedDate = DateTime.now();

  void _deleteAccount() {
    // TODO hier weitermachen und https://github.com/Marcel9494/Haushaltsbuch/issues/14 implementieren
    showChoiceDialog(context, '${widget.account.name} löschen?', _yesPressed, _noPressed);
  }

  void _yesPressed() {
    AccountRepository accountRepository = AccountRepository();
    if (formatMoneyAmountToDouble(widget.account.bankBalance) == 0) {
      setState(() {
        accountRepository.delete(widget.account);
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
      FocusScope.of(context).unfocus();
    } else {
      Navigator.pop(context);
      // TODO hier weitermachen mit Ablauf von: https://github.com/Marcel9494/Haushaltsbuch/issues/14
      showInfoDialog(context, 'Konto auswählen', () => {
        Navigator.pop(context),
        openBottomSheetWithAccountList(context, fromAccountInputFieldCubit),
      }, 'Bitte wähle im nächsten Schritt das Konto aus auf das du den restlichen Betrag von: ${widget.account.bankBalance} übertragen möchtest.');
    }
  }

  void _noPressed() {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    fromAccountInputFieldCubit = BlocProvider.of<FromAccountInputFieldCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account.name),
        actions: [
          IconButton(
            onPressed: () => BlocProvider.of<AccountBloc>(context).add(CreateOrLoadAccountEvent(context, widget.account.boxIndex)),
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () => _deleteAccount(),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          MonthPickerButtons(selectedDate: _selectedDate, selectedDateCallback: (selectedDate) => setState(() => _selectedDate = selectedDate)),
          Expanded(
            child: MonthlyBookingTabView(
              selectedDate: _selectedDate,
              categorie: '',
              transactionType: '',
              account: widget.account.name,
              showOverviewTile: false,
            ),
          ),
        ],
      ),
    );
  }
}
