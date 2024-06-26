import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showChoiceDialog(BuildContext context, String title, Function yesPressed, Function noPressed, [String content = '']) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: content == '' ? null : Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Nein',
              style: TextStyle(
                color: Colors.cyanAccent,
              ),
            ),
            onPressed: () => noPressed(),
          ),
          TextButton(
            onPressed: () => {
              yesPressed(),
            },
            child: const Text(
              'Ja',
              style: TextStyle(
                color: Colors.cyanAccent,
              ),
            ),
          ),
        ],
      );
    },
  );
}
