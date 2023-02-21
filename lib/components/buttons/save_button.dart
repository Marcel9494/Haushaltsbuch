import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SaveButton extends StatelessWidget {
  final Function saveFunction;
  final RoundedLoadingButtonController buttonController;

  const SaveButton({
    Key? key,
    required this.saveFunction,
    required this.buttonController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: RoundedLoadingButton(
          controller: buttonController,
          onPressed: () => saveFunction(),
          color: Colors.cyanAccent,
          successColor: Colors.green,
          height: 40.0,
          child: const Text(
            'Speichern',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ), /*ElevatedButton(
          onPressed: () => saveFunction(),
          child: const Text('Speichern'),
          style: ElevatedButton.styleFrom(
            primary: Colors.cyanAccent.shade700,
            onPrimary: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),*/
      ),
    );
  }
}
