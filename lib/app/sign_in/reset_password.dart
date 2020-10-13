import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/errors_exception.dart';
import 'package:flutter_live_chat_app/common_widgets/platform_alert_dialog.dart';
import 'package:flutter_live_chat_app/common_widgets/sign_in_text_form_field.dart';
import 'package:flutter_live_chat_app/common_widgets/social_log_in_button.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  String _mail;

  _formSubmit() async {
    setState(() {});
    _formKey.currentState.save();
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    try {
      await _userViewModel.resetPassword(_mail);
      return PlatformAlertDialog(
        title: "Başarılı!",
        message:
            "Şifrenizi sıfırlamanız için E-Posta adresinize bir mail gönderdik. Spam klasörünüzü kontrol etmeyi unutmayın.",
        mainActionText: "Tamam",
      ).show(context);
    } on FirebaseException catch (e) {
      return PlatformAlertDialog(
        title: "Oturum açarken hata!",
        message: Errors.showError(e.code.toString()),
        mainActionText: "Tamam",
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Parola sıfırla",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFF2F6FA),
          ),
        ),
      ),
      body: _userViewModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "E-Posta",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SignInTextFormField(
                        obscureText: false,
                        hintText: "E-Posta adresinizi giriniz",
                        keyboardType: TextInputType.emailAddress,
                        errorText:
                            _userViewModel.mailErrorMessageForReset != null
                                ? _userViewModel.mailErrorMessageForReset
                                : null,
                        onSaved: (String inputMail) {
                          _mail = inputMail;
                        },
                      ),
                      SocialLogInButton(
                        buttonText: "Gönder",
                        buttonBgColor: Theme.of(context).primaryColor,
                        onPressed: () => _formSubmit(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
