import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String input;
  final Function inputCallback;
  final String hintText;
  final String errorText;
  final int maxLength;
  final bool autofocus;

  const TextInputField({
    Key? key,
    required this.textEditingController,
    required this.input,
    required this.inputCallback,
    required this.hintText,
    this.errorText = '',
    this.maxLength = 40,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      // initialValue: input,
      controller: textEditingController,
      maxLength: maxLength,
      autofocus: autofocus,
      onChanged: (input) => inputCallback(input),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(
          Icons.title_rounded,
          color: Colors.grey,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            textEditingController.clear();
          },
          icon: const Icon(
              Icons.clear,
              color: Colors.grey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}
