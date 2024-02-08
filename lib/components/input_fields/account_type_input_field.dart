import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../deco/bottom_sheet_line.dart';

import '/models/enums/account_types.dart';

// TODO hier weitermachen und Account Type Eingabefeld auf Bloc umziehen siehe andere Eingabefelder als Beispiel
class AccountTypeInputField extends StatelessWidget {
  final dynamic cubit;
  final FocusNode focusNode;

  const AccountTypeInputField({
    Key? key,
    required this.cubit,
    required this.focusNode,
  }) : super(key: key);

  void _openBottomSheetWithAccountTypeList(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 460.0, // TODO dynamisch machen
            child: ListView(
              children: [
                const BottomSheetLine(),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 30.0),
                  child: Text('Konto Typ auswählen:', style: TextStyle(fontSize: 18.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: 460.0, // TODO dynamisch machen
                    child: ListView.builder(
                      itemCount: AccountType.values.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                          child: ListTile(
                            title: Text(AccountType.values[index].name, textAlign: TextAlign.center),
                            onTap: () => {
                              cubit.updateValue(AccountType.values[index].name),
                              Navigator.pop(context),
                            },
                            visualDensity: const VisualDensity(vertical: -4.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: cubit.state.accountType == AccountType.values[index].name ? Colors.cyanAccent.shade400 : Colors.grey,
                                  width: cubit.state.accountType == AccountType.values[index].name ? 1.2 : 0.4),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            tileColor: Colors.grey.shade800,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: focusNode,
      initialValue: cubit.state.accountType,
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
        errorText: cubit.state.errorText.isEmpty ? null : cubit.state.errorText,
      ),
    );
  }
}
