import 'package:flutter/material.dart';

class AccountTypeInputField extends StatelessWidget {
  final TextEditingController textController;
  final String errorText;
  List<String> accountTypes = ['Konto', 'Kapitalanlage', 'Bargeld', 'Karte', 'Versicherung', 'Kredit', 'Sonstiges'];

  AccountTypeInputField({
    Key? key,
    required this.textController,
    required this.errorText,
  }) : super(key: key);

  void _openBottomSheetWithAccountTypeList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konto Typen:'),
          content: SizedBox(
            height: 300.0,
            width: 300.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: accountTypes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(accountTypes[index]),
                  onTap: () => {
                    textController.text = accountTypes[index],
                    Navigator.pop(context),
                  },
                );
              },
            ),
          ),
        );
      },
    );
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
