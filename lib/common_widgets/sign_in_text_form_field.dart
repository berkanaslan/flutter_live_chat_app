import 'package:flutter/material.dart';

class SignInTextFormField extends StatelessWidget {
  final String hintText;
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
    this.hintText,
    this.obscureText: false,
    this.prefixIcon,
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
      cursorColor: Colors.grey.shade700,
      decoration: InputDecoration(
        errorText: errorText,
        prefixIcon: prefixIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Colors.grey.shade700,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 16,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
