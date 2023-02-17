import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController textController;

  const AmountInputField({
    Key? key,
    required this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
      ],
      decoration: const InputDecoration(
        hintText: 'Betrag',
        prefixIcon: Icon(
          Icons.money_rounded,
          color: Colors.grey,
        ),
        suffixIcon: Icon(
          Icons.euro_rounded,
          color: Colors.grey,
          size: 20.0,
        ),
      ),
    );
  }
}
