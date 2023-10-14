import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  //final TextEditingController textEditingController;
  final UniqueKey fieldKey;
  final dynamic textCubit;
  final String hintText;
  final String errorText;
  final int maxLength;
  final bool autofocus;

  const TextInputField({
    Key? key,
    // required this.textEditingController,
    required this.fieldKey,
    required this.textCubit,
    required this.hintText,
    this.errorText = '',
    this.maxLength = 60,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      initialValue: textCubit.state,
      textCapitalization: TextCapitalization.words,
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
        /* TODO suffixIcon: textCubit.state != ''
            ? IconButton(
                onPressed: () {
                  textCubit.resetValue();
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
              )
            : const SizedBox(),*/
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}

/*class TextInputField extends StatefulWidget {
  //final TextEditingController textEditingController;
  final dynamic textCubit;
  final String hintText;
  final String errorText;
  final int maxLength;
  final bool autofocus;

  const TextInputField({
    Key? key,
    //required this.textEditingController,
    required this.textCubit,
    required this.hintText,
    this.errorText = '',
    this.maxLength = 60,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      initialValue: widget.textCubit.state,
      textCapitalization: TextCapitalization.words,
      //controller: widget.textEditingController,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (newText) => widget.textCubit.updateValue(newText),
      /*onChanged: (_) => setState(() {
        widget.textEditingController;
      }),*/
      decoration: InputDecoration(
        hintText: widget.hintText,
        counterText: '',
        prefixIcon: const Icon(
          Icons.title_rounded,
          color: Colors.grey,
        ),
        suffixIcon: widget.textCubit.state != ''
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.textCubit.resetValue();
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
}*/
