import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/deco/bottom_sheet_line.dart';

import '/models/account/account_repository.dart';

class ToAccountInputField extends StatefulWidget {
  final dynamic cubit;
  final FocusNode focusNode;
  final String hintText;

  const ToAccountInputField({
    Key? key,
    required this.cubit,
    required this.focusNode,
    this.hintText = 'Konto',
  }) : super(key: key);

  @override
  State<ToAccountInputField> createState() => _ToAccountInputFieldState();
}

class _ToAccountInputFieldState extends State<ToAccountInputField> {
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
                                      widget.cubit.updateValue(accountNames[i]),
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
    AccountRepository accountRepository = AccountRepository();
    accountNames = await accountRepository.loadAccountNameList();
    return accountNames;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: widget.focusNode,
      initialValue: widget.cubit.state.toAccount,
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
        errorText: widget.cubit.state.errorText.isEmpty ? null : widget.cubit.state.errorText,
      ),
    );
  }
}
