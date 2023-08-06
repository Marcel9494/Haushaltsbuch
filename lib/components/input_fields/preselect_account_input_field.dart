import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/models/primary_account.dart';
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
  List<bool> preselectedAccount = [false, false, false, false, false, false];
  Map<String, String> _currentPrimaryAccounts = {};

  void _openBottomSheetWithTransactionTypes(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 520.0,
            child: FutureBuilder(
              future: _loadPreselectedAccountList(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const SizedBox();
                  case ConnectionState.done:
                    return Center(
                      child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BottomSheetLine(),
                            const Padding(
                              padding: EdgeInsets.only(top: 12.0, left: 28.0, bottom: 8.0),
                              child: Text('Vorselektiertes Konto für:', style: TextStyle(fontSize: 18.0)),
                            ),
                            const Divider(),
                            Column(
                              children: [
                                CheckboxListTile(
                                  title: Text(PreselectAccountType.income.name),
                                  subtitle: _currentPrimaryAccounts[PreselectAccountType.income.name] == null
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + _currentPrimaryAccounts[PreselectAccountType.income.name].toString()),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  value: preselectedAccount[0],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      preselectedAccount[0] = value!;
                                      _setPreselectedAccountText(preselectedAccount[0], PreselectAccountType.income.name);
                                    });
                                  },
                                  activeColor: Colors.grey,
                                  checkColor: Colors.cyanAccent,
                                ),
                                CheckboxListTile(
                                  title: Text(PreselectAccountType.outcome.name),
                                  subtitle: _currentPrimaryAccounts[PreselectAccountType.outcome.name] == null
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + _currentPrimaryAccounts[PreselectAccountType.outcome.name].toString()),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  value: preselectedAccount[1],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      preselectedAccount[1] = value!;
                                      _setPreselectedAccountText(preselectedAccount[1], PreselectAccountType.outcome.name);
                                    });
                                  },
                                  activeColor: Colors.grey,
                                  checkColor: Colors.cyanAccent,
                                ),
                                CheckboxListTile(
                                  title: Text(PreselectAccountType.transferFrom.name),
                                  subtitle: _currentPrimaryAccounts[PreselectAccountType.transferFrom.name] == null
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + _currentPrimaryAccounts[PreselectAccountType.transferFrom.name].toString()),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  value: preselectedAccount[2],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      preselectedAccount[2] = value!;
                                      _setPreselectedAccountText(preselectedAccount[2], PreselectAccountType.transferFrom.name);
                                    });
                                  },
                                  activeColor: Colors.grey,
                                  checkColor: Colors.cyanAccent,
                                ),
                                CheckboxListTile(
                                  title: Text(PreselectAccountType.transferTo.name),
                                  subtitle: _currentPrimaryAccounts[PreselectAccountType.transferTo.name] == null
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + _currentPrimaryAccounts[PreselectAccountType.transferTo.name].toString()),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  value: preselectedAccount[3],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      preselectedAccount[3] = value!;
                                      _setPreselectedAccountText(preselectedAccount[3], PreselectAccountType.transferTo.name);
                                    });
                                  },
                                  activeColor: Colors.grey,
                                  checkColor: Colors.cyanAccent,
                                ),
                                CheckboxListTile(
                                  title: Text(PreselectAccountType.investmentFrom.name),
                                  subtitle: _currentPrimaryAccounts[PreselectAccountType.investmentFrom.name] == null
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + _currentPrimaryAccounts[PreselectAccountType.investmentFrom.name].toString()),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  value: preselectedAccount[4],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      preselectedAccount[4] = value!;
                                      _setPreselectedAccountText(preselectedAccount[4], PreselectAccountType.investmentFrom.name);
                                    });
                                  },
                                  activeColor: Colors.grey,
                                  checkColor: Colors.cyanAccent,
                                ),
                                CheckboxListTile(
                                  title: Text(PreselectAccountType.investmentTo.name),
                                  subtitle: _currentPrimaryAccounts[PreselectAccountType.investmentTo.name] == null
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + _currentPrimaryAccounts[PreselectAccountType.investmentTo.name].toString()),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  value: preselectedAccount[5],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      preselectedAccount[5] = value!;
                                      _setPreselectedAccountText(preselectedAccount[5], PreselectAccountType.investmentTo.name);
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
          ),
        );
      },
    );
  }

  void _setPreselectedAccountText(bool isNewAccountSelected, String newText) {
    String separator = ', ';
    if (isNewAccountSelected) {
      widget.textController.text += widget.textController.text.isEmpty ? newText : separator + newText;
    } else {
      widget.textController.text = widget.textController.text.replaceFirst(newText, '');
      if (widget.textController.text.startsWith(separator)) {
        widget.textController.text = widget.textController.text.replaceFirst(separator, '');
      }
      if (widget.textController.text.endsWith(separator)) {
        widget.textController.text = widget.textController.text.substring(0, widget.textController.text.length - 2);
      }
      if (widget.textController.text.contains(separator + ',')) {
        widget.textController.text = widget.textController.text.replaceFirst(separator + ',', ',');
      }
    }
  }

  Future<List<bool>> _loadPreselectedAccountList() async {
    _setPrimaryAccounts();
    _currentPrimaryAccounts = await PrimaryAccount.getCurrentPrimaryAccounts();
    return preselectedAccount;
  }

  void _setPrimaryAccounts() {
    widget.textController.text.contains(PreselectAccountType.income.name) ? preselectedAccount[0] = true : preselectedAccount[0] = false;
    widget.textController.text.contains(PreselectAccountType.outcome.name) ? preselectedAccount[1] = true : preselectedAccount[1] = false;
    widget.textController.text.contains(PreselectAccountType.transferFrom.name) ? preselectedAccount[2] = true : preselectedAccount[2] = false;
    widget.textController.text.contains(PreselectAccountType.transferTo.name) ? preselectedAccount[3] = true : preselectedAccount[3] = false;
    widget.textController.text.contains(PreselectAccountType.investmentFrom.name) ? preselectedAccount[4] = true : preselectedAccount[4] = false;
    widget.textController.text.contains(PreselectAccountType.investmentTo.name) ? preselectedAccount[5] = true : preselectedAccount[5] = false;
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
