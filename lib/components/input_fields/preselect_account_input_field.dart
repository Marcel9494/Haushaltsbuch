import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../models/account.dart';
import '/models/enums/preselect_account_types.dart';

import '../deco/bottom_sheet_line.dart';

class PreselectAccountInputField extends StatefulWidget {
  final TextEditingController textController;

  const PreselectAccountInputField({
    Key? key,
    required this.textController,
  }) : super(key: key);

  @override
  State<PreselectAccountInputField> createState() => _PreselectAccountInputFieldState();
}

class _PreselectAccountInputFieldState extends State<PreselectAccountInputField> {
  List<bool> preselectedAccount = [];

  void _openBottomSheetWithTransactionTypes(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 400,
            child: ListView(
              children: [
                FutureBuilder(
                  future: _loadPreselectedAccountList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        return Center(
                          child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                const BottomSheetLine(),
                                const Padding(
                                  padding: EdgeInsets.only(top: 12.0, left: 20.0, bottom: 8.0),
                                  child: Text('Vorselektiertes Konto für:', style: TextStyle(fontSize: 18.0)),
                                ),
                                Column(
                                  children: [
                                    // TODO hier weitermachen
                                    CheckboxListTile(
                                      title: Text(PreselectAccountType.income.name),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      value: preselectedAccount[0],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          preselectedAccount[0] = value!;
                                        });
                                      },
                                      activeColor: Colors.grey,
                                      checkColor: Colors.cyanAccent,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        );
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

  Future<List<bool>> _loadPreselectedAccountList() async {
    if (widget.textController.text.isEmpty) {
      preselectedAccount = [false, false, false, false, false, false];
    } else {
      preselectedAccount = await Account.loadPreselectedAccountList();
    }
    return preselectedAccount;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
      onTap: () => _openBottomSheetWithTransactionTypes(context),
      decoration: const InputDecoration(
        hintText: 'Vorselektiertes Konto für',
        prefixIcon: Icon(
          Icons.star_border_rounded,
          color: Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        // TODO errorText: widget.errorText.isEmpty ? null : widget.errorText,
      ),
    );
  }
}
