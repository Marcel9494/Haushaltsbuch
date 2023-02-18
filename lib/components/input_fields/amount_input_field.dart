import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController textController;

  const AmountInputField({
    Key? key,
    required this.textController,
  }) : super(key: key);

  void _openBottomSheetForNumberInput(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 380,
            child: Column(
              children: [
                const Text('Betrag eingeben:'),
                Center(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '1';
                        },
                        child: const Text('1', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '2';
                        },
                        child: const Text('2', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '3';
                        },
                        child: const Text('3', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text = '';
                        },
                        child: const Icon(Icons.clear_rounded, color: Colors.cyanAccent),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '4';
                        },
                        child: const Text('4', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '5';
                        },
                        child: const Text('5', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '6';
                        },
                        child: const Text('6', style: TextStyle(color: Colors.cyanAccent)),
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
                        onPressed: () {
                          textController.text += '7';
                        },
                        child: const Text('7', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '8';
                        },
                        child: const Text('8', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '9';
                        },
                        child: const Text('9', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.check_circle, color: Colors.cyanAccent),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text(''),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += '0';
                        },
                        child: const Text('0', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          textController.text += ',';
                        },
                        child: const Text(',', style: TextStyle(color: Colors.cyanAccent)),
                      ),
                    ],
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
      maxLength: 9,
      controller: textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: true,
      readOnly: true,
      onTap: () => _openBottomSheetForNumberInput(context),
      decoration: const InputDecoration(
        hintText: 'Betrag',
        counterText: '',
        prefixIcon: Icon(
          Icons.money_rounded,
          color: Colors.grey,
        ),
        suffixIcon: Icon(
          Icons.euro_rounded,
          color: Colors.grey,
          size: 20.0,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }
}
