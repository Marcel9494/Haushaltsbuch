import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function saveFunction;

  const SaveButton({
    Key? key,
    required this.saveFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => saveFunction(),
          child: const Text('Speichern'),
          style: ElevatedButton.styleFrom(
            primary: Colors.cyanAccent.shade700,
            onPrimary: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
      ),
    );
  }
}
