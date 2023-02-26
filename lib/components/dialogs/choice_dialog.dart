import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

void showChoiceDialog(BuildContext context, String title, Function yesPressed, Function noPressed, String flushbarTitle, String flushbarMessage, IconData flushbarIcon) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
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
              primary: Colors.cyanAccent,
              onPrimary: Colors.black87,
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
