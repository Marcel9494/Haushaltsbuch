import 'package:flutter/material.dart';

class TitleInputField extends StatelessWidget {
  final String title;
  final Function titleCallback;

  const TitleInputField({
    Key? key,
    required this.title,
    required this.titleCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 35,
      onChanged: (title) => titleCallback(title),
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        hintText: 'Titel',
        counterText: '',
        prefixIcon: Icon(
          Icons.title_rounded,
          color: Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }
}
