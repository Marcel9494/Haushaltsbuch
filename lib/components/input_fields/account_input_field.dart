import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/deco/bottom_sheet_line.dart';

import '/models/account.dart';

class AccountInputField extends StatefulWidget {
  final TextEditingController textController;
  final String errorText;
  final String hintText;

  const AccountInputField({
    Key? key,
    required this.textController,
    required this.errorText,
    this.hintText = 'Konto',
  }) : super(key: key);

  @override
  State<AccountInputField> createState() => _AccountInputFieldState();
}

class _AccountInputFieldState extends State<AccountInputField> {
  List<String> accountNames = [];

  void _openBottomSheetWithAccountList(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 400.0,
            child: ListView(
              children: [
                const BottomSheetLine(),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20.0),
                  child: Text('Konto auswählen:', style: TextStyle(fontSize: 18.0)),
                ),
                FutureBuilder(
                  future: _loadAccountNameList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        if (accountNames.isEmpty) {
                          return const Text('Erstelle zuerst ein Konto.');
                        } else {
                          return Center(
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisCount: 4,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              shrinkWrap: true,
                              children: <Widget>[
                                for (int i = 0; i < accountNames.length; i++)
                                  OutlinedButton(
                                    onPressed: () => {
                                      widget.textController.text = accountNames[i],
                                      Navigator.pop(context),
                                    },
                                    child: Text(
                                      accountNames[i],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _loadAccountNameList() async {
    accountNames = await Account.loadAccountNames();
    return accountNames;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
      onTap: () => _openBottomSheetWithAccountList(context),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(
          Icons.account_balance_rounded,
          color: Colors.grey,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        errorText: widget.errorText.isEmpty ? null : widget.errorText,
      ),
    );
  }
}
