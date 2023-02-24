import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String input;
  final Function inputCallback;
  final String hintText;
  final int maxLength;

  const TextInputField({
    Key? key,
    required this.input,
    required this.inputCallback,
    required this.hintText,
    this.maxLength = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      onChanged: (input) => inputCallback(input),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(
          Icons.title_rounded,
          color: Colors.grey,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }
}
