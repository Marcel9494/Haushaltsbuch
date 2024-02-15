import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../deco/bottom_sheet_header.dart';
import '/components/deco/bottom_sheet_line.dart';

import '/models/account/account_repository.dart';

import '../deco/bottom_sheet_empty_list.dart';

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
  List<String> _accountNames = [];

  void _openBottomSheetWithAccountList(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: ListView(
              children: [
                const BottomSheetLine(),
                const BottomSheetHeader(title: 'Konto auswählen:'),
                FutureBuilder(
                  future: _loadAccountNameList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        if (_accountNames.isEmpty) {
                          return const BottomSheetEmptyList(text: 'Erstelle zuerst ein Konto.');
                        } else {
                          return Center(
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                              crossAxisCount: 4,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              shrinkWrap: true,
                              children: <Widget>[
                                for (int i = 0; i < _accountNames.length; i++)
                                  OutlinedButton(
                                    onPressed: () => {
                                      widget.cubit.updateValue(_accountNames[i]),
                                      Navigator.pop(context),
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: widget.cubit.state.toAccount == _accountNames[i] ? 1.5 : 1.0,
                                          color: widget.cubit.state.toAccount == _accountNames[i] ? Colors.cyanAccent : Colors.grey.shade800),
                                    ),
                                    child: Text(
                                      _accountNames[i],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                OutlinedButton(
                                  onPressed: () => {
                                    widget.cubit.updateValue(''),
                                    Navigator.pop(context),
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: widget.cubit.state.toAccount == '' ? 1.5 : 1.0,
                                        color: widget.cubit.state.toAccount == '' ? Colors.cyanAccent : Colors.grey.shade800),
                                  ),
                                  child: const Text(
                                    'X',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
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
    _accountNames = await accountRepository.loadAccountNameList();
    return _accountNames;
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
