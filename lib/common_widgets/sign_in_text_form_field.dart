import 'package:flutter/material.dart';

class SignInTextFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final String errorText;
  final Widget prefixIcon;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final TextInputType keyboardType;
  final String initialValue;
  final bool readOnly;
  final TextEditingController controller;

  const SignInTextFormField({
    Key key,
    @required this.labelText,
    this.obscureText: false,
    @required this.prefixIcon,
    this.onSaved,
    this.validator,
    this.keyboardType,
    this.errorText,
    this.initialValue,
    this.readOnly: false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: obscureText,
      initialValue: initialValue,
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
