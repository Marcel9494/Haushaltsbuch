import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final FocusNode focusNode;
  final dynamic textCubit;
  final String hintText;
  final int maxLength;
  final bool autofocus;

  const TextInputField({
    Key? key,
    required this.focusNode,
    required this.textCubit,
    required this.hintText,
    this.maxLength = 60,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(key),
      focusNode: focusNode,
      initialValue: textCubit.state.text,
      textCapitalization: TextCapitalization.sentences,
      maxLength: maxLength,
      autofocus: autofocus,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (newText) => textCubit.updateValue(newText),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(
          Icons.title_rounded,
          color: Colors.grey,
        ),
        // TODO
        /*suffixIcon: IconButton(
          onPressed: () => textCubit.resetValue(),
          icon: const Icon(Icons.clear, color: Colors.grey),
        ),*/
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        errorText: textCubit.state.errorText.isEmpty ? null : textCubit.state.errorText,
      ),
    );
  }
}
