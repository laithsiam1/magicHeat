import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// shows a dialog based on the phone's platform
void showCustomDialog(
  BuildContext context, {
  @required String title,
  @required Widget content,
  @required List<Widget> actions,
}) {
  showDialog(
    context: context,
    builder: (context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Material(
            color: Colors.transparent,
            child: Container(
              width: double.maxFinite,
              child: content,
            ),
          ),
          actions: actions,
        );
      } else {
        return AlertDialog(
          title: Text(title),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: content,
          ),
          actions: actions,
        );
      }
    },
  );
}
