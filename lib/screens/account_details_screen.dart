import 'package:flutter/material.dart';
import 'package:haushaltsbuch/components/dialogs/choice_dialog.dart';
import 'package:haushaltsbuch/utils/consts/route_consts.dart';

import '/models/account.dart';

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
  void _deleteAccount() {
    showChoiceDialog(context, 'Konto löschen?', _yesPressed, _noPressed, 'Konto wurde gelöscht', '', Icons.info_outline);
  }

  void _yesPressed() {
    setState(() {
      widget.account.deleteAccount(widget.account);
    });
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, bottomNavBarRoute);
    FocusScope.of(context).unfocus();
    //_showFlushbar('Konto wurde gelöscht.'),
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
            onPressed: () => _deleteAccount(),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: const Text('Account Details'),
    );
  }
}
