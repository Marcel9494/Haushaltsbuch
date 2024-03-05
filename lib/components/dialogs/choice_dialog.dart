import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

void showChoiceDialog(BuildContext context, String title, Function yesPressed, Function noPressed, String flushbarTitle, String flushbarMessage, IconData flushbarIcon,
    [String content = '']) {
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
