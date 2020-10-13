import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/errors_exception.dart';
import 'package:flutter_live_chat_app/app/sign_in/reset_password.dart';
import 'package:flutter_live_chat_app/common_widgets/platform_alert_dialog.dart';
import 'package:flutter_live_chat_app/common_widgets/sign_in_text_form_field.dart';
import 'package:flutter_live_chat_app/common_widgets/social_log_in_button.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class MailAndPassForm extends StatefulWidget {
  @override
  _MailAndPassFormState createState() => _MailAndPassFormState();
}

class _MailAndPassFormState extends State<MailAndPassForm> {
  String _mail, _pass;
  String _buttonText, _linkDescribeText, _linkText;
  FormType _formType = FormType.LogIn;
  final _formKey = GlobalKey<FormState>();

  _changeFormType() {
    setState(() {
      _formType == FormType.LogIn
          ? _formType = FormType.Register
          : _formType = FormType.LogIn;
    });
  }

  _formSubmit() async {
    setState(() {});
    _formKey.currentState.save();
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (_formType == FormType.LogIn) {
      try {
        UserModel _loggedInUser =
            await _userViewModel.signInWithMailAndPass(_mail, _pass);
        if (_loggedInUser != null) {
          print("Oturum açan kullanıcı ID: " + _loggedInUser.userID.toString());
        }
      } on FirebaseException catch (e) {
        return PlatformAlertDialog(
          title: "Oturum açarken hata!",
          message: Errors.showError(e.code.toString()),
          mainActionText: "Tamam",
        ).show(context);
      }
    } else {
      try {
        UserModel _createdUser =
            await _userViewModel.createWithMailAndPass(_mail, _pass);
        if (_createdUser != null) {
          print("Kayıt olan kullanıcı ID: " + _createdUser.userID.toString());
        }
      } on FirebaseException catch (e) {
        return PlatformAlertDialog(
          title: "Kullanıcı oluşturulurken hata!",
          message: Errors.showError(e.code.toString()),
          mainActionText: "Tamam",
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.LogIn ? "Giriş yap" : "Kayıt ol";
    _linkDescribeText =
        _formType == FormType.LogIn ? "Hesabınız yok mu?" : "Hesabınız var mı?";
    _linkText = _formType == FormType.LogIn ? " Kayıt olun." : " Giriş yapın.";

    final _userViewModel = Provider.of<UserViewModel>(context, listen: true);

    if (_userViewModel.userModel != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _buttonText,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFF2F6FA),
          ),
        ),
      ),
      body: _userViewModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          "E-Posta",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SignInTextFormField(
                        obscureText: false,
                        hintText: "E-Posta adresinizi giriniz",
                        keyboardType: TextInputType.emailAddress,
                        errorText: _userViewModel.mailErrorMessage != null
                            ? _userViewModel.mailErrorMessage
                            : null,
                        onSaved: (String inputMail) {
                          _mail = inputMail;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          "Parola",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SignInTextFormField(
                        obscureText: true,
                        hintText: "Parolanızı giriniz",
                        errorText: _userViewModel.passErrorMessage != null
                            ? _userViewModel.passErrorMessage
                            : null,
                        onSaved: (String inputPass) {
                          _pass = inputPass;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SocialLogInButton(
                        buttonText: _buttonText,
                        buttonBgColor: Theme.of(context).primaryColor,
                        onPressed: () => _formSubmit(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Text(
                                "Parolamı unuttum",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ResetPassword()));
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _linkDescribeText,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            child: Text(
                              _linkText,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onTap: () => _changeFormType(),
                          ),
                        ],
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
