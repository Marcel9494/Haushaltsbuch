import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/blocs/primary_account_bloc/primary_account_bloc.dart';

import '/models/enums/preselect_account_types.dart';

import '../deco/loading_indicator.dart';
import '../deco/bottom_sheet_line.dart';

class PreselectAccountInputField extends StatefulWidget {
  final dynamic cubit;
  final FocusNode focusNode;

  const PreselectAccountInputField({
    Key? key,
    required this.cubit,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<PreselectAccountInputField> createState() => _PreselectAccountInputFieldState();
}

class _PreselectAccountInputFieldState extends State<PreselectAccountInputField> {
  List<bool> preselectedAccount = [false, false, false, false, false, false];

  void _openBottomSheetWithTransactionTypes(BuildContext context) {
    BlocProvider.of<PrimaryAccountBloc>(context).add(LoadPrimaryAccountEvent(context));
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<PrimaryAccountBloc, PrimaryAccountState>(builder: (BuildContext context, primaryAccountState) {
          if (primaryAccountState is PrimaryAccountLoading) {
            return const LoadingIndicator();
          } else if (primaryAccountState is PrimaryAccountLoaded) {
            return Material(
                child: SizedBox(
                    height: 520.0,
                    child: Center(
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
                                  title: Text(primaryAccountState.loadedPrimaryAccounts[0].transactionType),
                                  subtitle: primaryAccountState.loadedPrimaryAccounts[0].accountName == ''
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + primaryAccountState.loadedPrimaryAccounts[0].accountName.toString()),
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
                                  title: Text(primaryAccountState.loadedPrimaryAccounts[1].transactionType),
                                  subtitle: primaryAccountState.loadedPrimaryAccounts[1].accountName == ''
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + primaryAccountState.loadedPrimaryAccounts[1].accountName.toString()),
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
                                  title: Text(primaryAccountState.loadedPrimaryAccounts[2].transactionType),
                                  subtitle: primaryAccountState.loadedPrimaryAccounts[2].accountName == ''
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + primaryAccountState.loadedPrimaryAccounts[2].accountName.toString()),
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
                                  title: Text(primaryAccountState.loadedPrimaryAccounts[3].transactionType),
                                  subtitle: primaryAccountState.loadedPrimaryAccounts[3].accountName == ''
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + primaryAccountState.loadedPrimaryAccounts[3].accountName.toString()),
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
                                  title: Text(primaryAccountState.loadedPrimaryAccounts[4].transactionType),
                                  subtitle: primaryAccountState.loadedPrimaryAccounts[4].accountName == ''
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + primaryAccountState.loadedPrimaryAccounts[4].accountName.toString()),
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
                                  title: Text(primaryAccountState.loadedPrimaryAccounts[5].transactionType),
                                  subtitle: primaryAccountState.loadedPrimaryAccounts[5].accountName == ''
                                      ? null
                                      : Text('Aktuelles Primärkonto: ' + primaryAccountState.loadedPrimaryAccounts[5].accountName.toString()),
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
                    )));
          } else {
            return const Text("Fehler bei vorselektierten Konten");
          }
        });
      },
    );
  }

  void _setPreselectedAccountText(bool isNewAccountSelected, String newText) {
    String separator = ', ';
    if (isNewAccountSelected) {
      String text = widget.cubit.state.preselectedAccount.isEmpty ? newText : separator + newText;
      widget.cubit.updateValue(widget.cubit.state.preselectedAccount + text);
    } else {
      widget.cubit.updateValue(widget.cubit.state.preselectedAccount.replaceFirst(newText, ''));
      if (widget.cubit.state.preselectedAccount.startsWith(separator)) {
        widget.cubit.updateValue(widget.cubit.state.preselectedAccount.replaceFirst(separator, ''));
      }
      if (widget.cubit.state.preselectedAccount.endsWith(separator)) {
        widget.cubit.updateValue(widget.cubit.state.preselectedAccount.substring(0, widget.cubit.state.preselectedAccount.length - 2));
      }
      if (widget.cubit.state.preselectedAccount.contains(separator + ',')) {
        widget.cubit.updateValue(widget.cubit.state.preselectedAccount.replaceFirst(separator + ',', ','));
      }
    }
  }

  // TODO hier weitermachen und beim Laden von einem Konto prüfen, ob es ein oder mehrfaches Primärkonto ist.
  void _setPrimaryAccounts() {
    widget.cubit.state.preselectedAccount.contains(PreselectAccountType.income.name) ? preselectedAccount[0] = true : preselectedAccount[0] = false;
    widget.cubit.state.preselectedAccount.contains(PreselectAccountType.outcome.name) ? preselectedAccount[1] = true : preselectedAccount[1] = false;
    widget.cubit.state.preselectedAccount.contains(PreselectAccountType.transferFrom.name) ? preselectedAccount[2] = true : preselectedAccount[2] = false;
    widget.cubit.state.preselectedAccount.contains(PreselectAccountType.transferTo.name) ? preselectedAccount[3] = true : preselectedAccount[3] = false;
    widget.cubit.state.preselectedAccount.contains(PreselectAccountType.investmentFrom.name) ? preselectedAccount[4] = true : preselectedAccount[4] = false;
    widget.cubit.state.preselectedAccount.contains(PreselectAccountType.investmentTo.name) ? preselectedAccount[5] = true : preselectedAccount[5] = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: widget.focusNode,
      initialValue: widget.cubit.state.preselectedAccount,
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
      ),
    );
  }
}
