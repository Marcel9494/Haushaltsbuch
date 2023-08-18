import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String errorText;
  final int maxLength;
  final bool autofocus;

  const TextInputField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    this.errorText = '',
    this.maxLength = 40,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: widget.textEditingController,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (_) => setState(() {
        widget.textEditingController;
      }),
      decoration: InputDecoration(
        hintText: widget.hintText,
        counterText: '',
        prefixIcon: const Icon(
          Icons.title_rounded,
          color: Colors.grey,
        ),
        suffixIcon: widget.textEditingController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.textEditingController.clear();
                  });
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
              )
            : const SizedBox(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        errorText: widget.errorText.isEmpty ? null : widget.errorText,
      ),
    );
  }
}
