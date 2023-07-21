import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

void showChoiceDialog(BuildContext context, String title, Function yesPressed, Function noPressed, String flushbarTitle, String flushbarMessage, IconData flushbarIcon,
    [String content = '']) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: Colors.cyanAccent,
            ),
            onPressed: () => {
              yesPressed(),
              Flushbar(
                title: flushbarTitle,
                message: flushbarMessage,
                icon: Icon(
                  flushbarIcon,
                  size: 28.0,
                  color: Colors.cyanAccent,
                ),
                duration: const Duration(seconds: 3),
                flushbarPosition: FlushbarPosition.TOP,
                leftBarIndicatorColor: Colors.cyanAccent,
              )..show(context),
            },
            child: const Text('Ja'),
          ),
        ],
      );
    },
  );
}
