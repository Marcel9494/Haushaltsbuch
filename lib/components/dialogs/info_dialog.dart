import 'package:flutter/material.dart';

void showInfoDialog(BuildContext context, String title, Function yesPressed, [String content = '']) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: content == '' ? null : Text(content),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: Colors.cyanAccent,
            ),
            onPressed: () => {
              yesPressed(),
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
