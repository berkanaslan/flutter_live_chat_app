import 'package:flutter/material.dart';

class SocialLogInButton extends StatelessWidget {
  final String buttonText;
  final Color buttonTextColor;
  final Color buttonBgColor;
  final Widget buttonIcon;
  final VoidCallback onPressed;
  final Color borderColor;

  const SocialLogInButton(
      {Key key,
      @required this.buttonText,
      this.buttonTextColor: Colors.white,
      this.buttonBgColor: Colors.indigoAccent,
      this.buttonIcon,
      this.borderColor,
      this.onPressed})
      : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        height: 50,
        child: RaisedButton(
          onPressed: onPressed,
          color: buttonBgColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Spreads, Collection if, Collection for: Dart 2.0+
              if (buttonIcon != null) ...[
                Opacity(opacity: 0, child: buttonIcon),
                Text(
                  buttonText,
                  style: TextStyle(color: buttonTextColor),
                ),
                buttonIcon,
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
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: borderColor == null ?  Theme.of(context).primaryColor : borderColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
