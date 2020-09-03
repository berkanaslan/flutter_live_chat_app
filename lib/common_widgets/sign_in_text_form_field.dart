import 'package:flutter/material.dart';

class SignInTextFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final String errorText;
  final Widget prefixIcon;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final TextInputType keyboardType;
  const SignInTextFormField(
      {Key key,
      @required this.labelText,
      this.obscureText,
      @required this.prefixIcon,
      @required this.onSaved,
      this.validator,
      this.keyboardType, this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorText: errorText,
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade300,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
