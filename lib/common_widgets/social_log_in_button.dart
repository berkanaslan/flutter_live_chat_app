import 'package:flutter/material.dart';

class SocialLogInButton extends StatelessWidget {
  final String buttonText;
  final Color buttonTextColor;
  final Color buttonBgColor;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLogInButton(
      {Key key,
      @required this.buttonText,
      this.buttonTextColor: Colors.white,
      this.buttonBgColor: Colors.indigoAccent,
      this.buttonIcon,
      this.onPressed})
      : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: buttonBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Spreads, Collection if, Collection for: Dart 2.0+
          if (buttonIcon != null) ...[
            buttonIcon,
            Text(
              buttonText,
              style: TextStyle(color: buttonTextColor),
            ),
            Opacity(opacity: 0, child: buttonIcon),
          ],
          if (buttonIcon == null) ...[
            Container(),
            Text(
              buttonText,
              style: TextStyle(color: buttonTextColor),
            ),
            Container(),
          ]
        ],
      ),
    );
  }
}
