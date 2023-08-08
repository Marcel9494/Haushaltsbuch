import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/deco/bottom_sheet_line.dart';

import '/utils/number_formatters/number_formatter.dart';

class MoneyInputField extends StatelessWidget {
  final TextEditingController textController;
  final String errorText;
  final String hintText;
  final String bottomSheetTitle;
  bool _clearedInputField = false;

  MoneyInputField({
    Key? key,
    required this.textController,
    required this.errorText,
    required this.hintText,
    required this.bottomSheetTitle,
  }) : super(key: key);

  void _openBottomSheetForNumberInput(BuildContext context) {
    _clearedInputField = textController.text.isEmpty ? true : false;
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 430,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BottomSheetLine(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 20.0),
                  child: Text(bottomSheetTitle, style: const TextStyle(fontSize: 18.0)),
                ),
                Center(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
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
                          textController.text = '';
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
                          if (textController.text.isNotEmpty) {
                            textController.text = textController.text.substring(0, textController.text.length - 1);
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
                        onPressed: () => _setAmount(','),
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
      if (textController.text.isNotEmpty) {
        textController.text = formatToMoneyAmount(textController.text);
      }
    });
  }

  void _setAmount(String amount) {
    // Eingabefeld wird automatisch geleert => Benutzer muss das Eingabefeld nicht mehr mit X löschen, wenn
    // ein neuer Betrag eingegeben wird.
    if (_clearedInputField == false) {
      textController.text = '';
      _clearedInputField = true;
    }
    if (amount == ',' && textController.text.contains(',')) {
      textController.text;
    } else {
      final regex = RegExp(r'^\d+(,\d{0,2})?$');
      if (regex.hasMatch(textController.text + amount)) {
        textController.text += amount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 9,
      controller: textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
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
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}
