import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAlertDialog(BuildContext context,
    {@required String title,
    @required String content,
    @required String dialogActionText,
    String cancelActionText}) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if (null != cancelActionText)
                TextButton(
                  onPressed: () => {Navigator.of(context).pop(false)},
                  child: Text(cancelActionText),
                ),
              TextButton(
                onPressed: () => {Navigator.of(context).pop(true)},
                child: Text(dialogActionText),
              ),
            ],
          );
        });
  } else {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if (null != cancelActionText)
                TextButton(
                  onPressed: () => {Navigator.of(context).pop(false)},
                  child: Text(cancelActionText),
                ),
              TextButton(
                onPressed: () => {Navigator.of(context).pop(true)},
                child: Text(dialogActionText),
              ),
            ],
          );
        });
  }
}
