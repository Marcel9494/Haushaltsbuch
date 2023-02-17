import 'package:flutter/material.dart';

class AccountInputField extends StatelessWidget {
  final TextEditingController textController;

  const AccountInputField({
    Key? key,
    required this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: const InputDecoration(
        hintText: 'Konto',
        prefixIcon: Icon(
          Icons.account_balance_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }
}
