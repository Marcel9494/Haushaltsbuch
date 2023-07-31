import 'package:flutter/material.dart';

import '../dialogs/list_dialog.dart';

import '/models/enums/account_types.dart';

class AccountTypeInputField extends StatelessWidget {
  final TextEditingController textController;
  final String errorText;
  List<String> accountTypes = [
    AccountType.account.name,
    AccountType.capitalInvestments.name,
    AccountType.cash.name,
    AccountType.card.name,
    AccountType.insurance.name,
    AccountType.credit.name,
    AccountType.other.name,
  ];

  AccountTypeInputField({
    Key? key,
    required this.textController,
    required this.errorText,
  }) : super(key: key);

  void _openBottomSheetWithAccountTypeList(BuildContext context) {
    showListDialog(context, 'Konto Typen:', accountTypes, textController);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
      onTap: () => _openBottomSheetWithAccountTypeList(context),
      decoration: InputDecoration(
        hintText: 'Konto Typ',
        prefixIcon: const Icon(
          Icons.account_balance_rounded,
          color: Colors.grey,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}
