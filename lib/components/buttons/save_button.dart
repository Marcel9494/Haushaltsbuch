import 'dart:async';

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
      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
      child: SizedBox(
        width: double.infinity,
        child: RoundedLoadingButton(
          controller: buttonController,
          onPressed: () => saveFunction(),
          color: Colors.cyanAccent,
          successColor: Colors.green,
          height: 38.0,
          child: const Text(
            'Speichern',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
