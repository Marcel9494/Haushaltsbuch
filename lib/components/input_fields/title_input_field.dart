import 'package:flutter/material.dart';

class TitleInputField extends StatelessWidget {
  final TextEditingController textController;

  const TitleInputField({
    Key? key,
    required this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: const InputDecoration(
        hintText: 'Titel',
        prefixIcon: Icon(
          Icons.title_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }
}
