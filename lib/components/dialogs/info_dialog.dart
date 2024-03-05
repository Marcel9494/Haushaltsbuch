import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showInfoDialog(BuildContext context, String title, Function yesPressed, [String content = '']) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: content == '' ? null : Text(content, textAlign: TextAlign.left),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              yesPressed(),
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.cyanAccent),
            ),
          ),
        ],
      );
    },
  );
}
