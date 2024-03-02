import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../models/enums/transaction_types.dart';
import '/models/enums/amount_types.dart';

import '/components/deco/bottom_sheet_line.dart';

import '/utils/number_formatters/number_formatter.dart';

class MoneyInputField extends StatelessWidget {
  final FocusNode focusNode;
  final dynamic cubit;
  final String hintText;
  final String bottomSheetTitle;
  final TransactionType transactionType;
  bool _clearedInputField = false;

  MoneyInputField({
    Key? key,
    required this.focusNode,
    required this.cubit,
    required this.hintText,
    required this.bottomSheetTitle,
    this.transactionType = TransactionType.none,
  }) : super(key: key);

  void _openBottomSheetForNumberInput(BuildContext context) {
    _clearedInputField = cubit.state.amount.isEmpty ? true : false;
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 430.0, // TODO dynamisch machen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BottomSheetLine(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 28.0),
                  child: Text(bottomSheetTitle, style: const TextStyle(fontSize: 18.0)),
                ),
                Center(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(30),
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () => _setAmount('1'),
                        child: const Text('1', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('2'),
                        child: const Text('2', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('3'),
                        child: const Text('3', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          cubit.resetValue();
                        },
                        child: const Icon(Icons.clear_rounded, color: Colors.cyanAccent),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('4'),
                        child: const Text('4', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('5'),
                        child: const Text('5', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('6'),
                        child: const Text('6', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          if (cubit.state.amount.isNotEmpty) {
                            cubit.updateValue(cubit.state.amount.substring(0, cubit.state.amount.length - 1));
                          }
                        },
                        child: const Icon(Icons.backspace_rounded, color: Colors.cyanAccent),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('7'),
                        child: const Text('7', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('8'),
                        child: const Text('8', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('9'),
                        child: const Text('9', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.check_circle, color: Colors.greenAccent),
                      ),
                      const Visibility(
                        visible: false,
                        child: Text(''),
                      ),
                      OutlinedButton(
                        onPressed: () => _setAmount('0'),
                        child: const Text('0', style: TextStyle(color: Colors.cyanAccent, fontSize: 26.0)),
                      ),
                      OutlinedButton(
                        onPressed: () => cubit.state.amount.contains(',') ? null : _setAmount(','),
                        child: const Text(',', style: TextStyle(color: Colors.cyanAccent, fontSize: 36.0)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (cubit.state.amount.isNotEmpty && !cubit.state.amount.contains('€')) {
        cubit.updateAmount(formatToMoneyAmount(cubit.state.amount));
      }
    });
  }

  void _setAmount(String amount) {
    // Eingabefeld wird automatisch geleert => Benutzer muss das Eingabefeld nicht mehr mit X löschen, wenn
    // ein neuer Betrag eingegeben wird.
    if (_clearedInputField == false) {
      cubit.resetValue();
      _clearedInputField = true;
    }
    if (amount == ',' && cubit.state.amount.contains(',')) {
      cubit.updateAmount(amount);
    } else {
      final regex = RegExp(r'^\d+(,\d{0,2})?$');
      if (regex.hasMatch(cubit.state.amount + amount)) {
        cubit.updateAmount(cubit.state.amount + amount);
      }
    }
  }

  void _openBottomSheetWithAmountTypeList(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 250.0,
            child: ListView(
              children: [
                const BottomSheetLine(),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 30.0),
                  child: Text('Betragstyp auswählen:', style: TextStyle(fontSize: 18.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: 250.0, // TODO dynamisch machen
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                          child: ListTile(
                            title: Text(_getAmountTypeName(index), textAlign: TextAlign.center),
                            onTap: () => {
                              _setAmountType(index),
                              Navigator.pop(context),
                            },
                            visualDensity: const VisualDensity(vertical: -4.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: cubit.state.amountType == AmountType.values[index].name ? Colors.cyanAccent.shade400 : Colors.grey,
                                  width: cubit.state.amountType == AmountType.values[index].name ? 1.2 : 0.4),
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

  String _getAmountTypeName(int index) {
    String amountTypeName = '';
    if (index == 0) {
      amountTypeName = AmountType.values[0].name;
    } else {
      if (transactionType.name == TransactionType.outcome.name) {
        amountTypeName = AmountType.values[index].name;
      } else if (transactionType.name == TransactionType.income.name) {
        amountTypeName = AmountType.values[index + 2].name;
      }
    }
    return amountTypeName;
  }

  void _setAmountType(int index) {
    if (index == 0) {
      cubit.updateAmountType(AmountType.values[0].name);
    } else {
      if (transactionType.name == TransactionType.outcome.name) {
        cubit.updateAmountType(AmountType.values[index].name);
      } else if (transactionType.name == TransactionType.income.name) {
        cubit.updateAmountType(AmountType.values[index + 2].name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: focusNode,
      initialValue: cubit.state.amount,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
      maxLength: 9,
      onTap: () => _openBottomSheetForNumberInput(context),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(
          Icons.money_rounded,
          color: Colors.grey,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        errorText: cubit.state.errorText.isEmpty ? null : cubit.state.errorText,
        suffixIcon: transactionType.name == TransactionType.outcome.name || transactionType.name == TransactionType.income.name
            ? Column(
                children: [
                  IconTheme(
                    data: IconThemeData(color: cubit.state.amountType == AmountType.notDefined.name ? Colors.grey : Colors.cyanAccent),
                    child: IconButton(
                      onPressed: () => _openBottomSheetWithAmountTypeList(context),
                      icon: const Icon(Icons.account_balance_wallet_rounded),
                      padding: cubit.state.amountType == AmountType.notDefined.name ? null : const EdgeInsets.only(top: 6.0),
                      constraints: cubit.state.amountType == AmountType.notDefined.name ? null : const BoxConstraints(),
                    ),
                  ),
                  cubit.state.amountType == AmountType.notDefined.name
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(cubit.state.amountType, style: const TextStyle(fontSize: 10.0)),
                        ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
