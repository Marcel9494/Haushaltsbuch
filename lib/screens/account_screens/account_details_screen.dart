import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/account_bloc/account_bloc.dart';

import '/components/buttons/month_picker_buttons.dart';
import '/components/dialogs/choice_dialog.dart';
import '/components/tab_views/monthly_booking_tab_view.dart';

import '/utils/consts/route_consts.dart';

import '/models/account/account_model.dart';
import '/models/account/account_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

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
  DateTime _selectedDate = DateTime.now();

  void _deleteAccount() {
    showChoiceDialog(context, 'Konto löschen?', _yesPressed, _noPressed, 'Konto wurde gelöscht', 'Konto ${widget.account.name} wurde erfolgreich gelöscht.', Icons.info_outline);
  }

  void _yesPressed() {
    AccountRepository accountRepository = AccountRepository();
    setState(() {
      accountRepository.delete(widget.account);
    });
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
    FocusScope.of(context).unfocus();
  }

  void _noPressed() {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
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
          MonthlyBookingTabView(
            selectedDate: _selectedDate,
            categorie: '',
            transactionType: '',
            account: widget.account.name,
            showOverviewTile: false,
          ),
        ],
      ),
    );
  }
}
