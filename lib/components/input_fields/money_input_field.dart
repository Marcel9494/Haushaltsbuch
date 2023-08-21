import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/deco/bottom_sheet_line.dart';

import '/utils/number_formatters/number_formatter.dart';

class MoneyInputField extends StatefulWidget {
  final TextEditingController textController;
  final String errorText;
  final String hintText;
  final String bottomSheetTitle;
  final FocusNode focus;

  MoneyInputField({
    Key? key,
    required this.textController,
    required this.errorText,
    required this.hintText,
    required this.bottomSheetTitle,
    required this.focus,
  }) : super(key: key);

  @override
  State<MoneyInputField> createState() => _MoneyInputFieldState();
}

class _MoneyInputFieldState extends State<MoneyInputField> {
  bool _clearedInputField = false;

  void _openBottomSheetForNumberInput(BuildContext context) {
    _clearedInputField = widget.textController.text.isEmpty ? true : false;
    print('Test');
    if (widget.focus.hasFocus == false) {
      return;
    }
    print('Test 2');
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 430.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BottomSheetLine(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 30.0),
                  child: Text(widget.bottomSheetTitle, style: const TextStyle(fontSize: 18.0)),
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
                          widget.textController.text = '';
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
                          if (widget.textController.text.isNotEmpty) {
                            widget.textController.text = widget.textController.text.substring(0, widget.textController.text.length - 1);
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
      if (widget.textController.text.isNotEmpty) {
        widget.textController.text = formatToMoneyAmount(widget.textController.text);
        FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
      }
    });
  }

  void _setAmount(String amount) {
    // Eingabefeld wird automatisch geleert => Benutzer muss das Eingabefeld nicht mehr mit X löschen, wenn
    // ein neuer Betrag eingegeben wird.
    if (_clearedInputField == false) {
      widget.textController.text = '';
      _clearedInputField = true;
    }
    if (amount == ',' && widget.textController.text.contains(',')) {
      widget.textController.text;
    } else {
      final regex = RegExp(r'^\d+(,\d{0,2})?$');
      if (regex.hasMatch(widget.textController.text + amount)) {
        widget.textController.text += amount;
      }
    }
  }

  void _onFocusChange() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // Wenn Textfeld nicht leer auch nicht fokusieren
    //if (widget.textController.text.isEmpty) {
    widget.focus.addListener(() => widget.focus.hasFocus ? _openBottomSheetForNumberInput(context) : null);
    //}
  }

  @override
  void dispose() {
    super.dispose();
    widget.focus.removeListener(_onFocusChange);
    widget.focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 9,
      controller: widget.textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
      focusNode: widget.focus,
      onTap: () => _openBottomSheetForNumberInput(context),
      decoration: InputDecoration(
        hintText: widget.hintText,
        counterText: '',
        prefixIcon: const Icon(
          Icons.money_rounded,
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
