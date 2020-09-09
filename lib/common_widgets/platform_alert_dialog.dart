import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_live_chat_app/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String message;
  final String mainActionText;
  final String secondActionText;

  PlatformAlertDialog(
      {@required this.title,
      @required this.message,
      @required this.mainActionText,
      this.secondActionText});

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: _buildDialogActions(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: _buildDialogActions(context),
    );
  }

  _buildDialogActions(BuildContext context) {
    final allActions = <Widget>[];

    if (Platform.isIOS) {
      allActions.add(
        CupertinoDialogAction(
          child: Text(mainActionText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );

      if (secondActionText != null) {
        allActions.add(
          CupertinoDialogAction(
            child: Text(secondActionText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }
    } else {
      allActions.add(
        FlatButton(
          child: Text(mainActionText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );

      if (secondActionText != null) {
        allActions.add(
          FlatButton(
            child: Text(secondActionText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }
    }

    return allActions;
  }
}
