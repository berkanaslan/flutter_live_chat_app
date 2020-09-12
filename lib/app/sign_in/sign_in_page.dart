import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/sign_in/mail_and_pass_form.dart';
import 'package:flutter_live_chat_app/common_widgets/social_log_in_button.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Oturum açın",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SocialLogInButton(
              buttonBgColor: Colors.white,
              buttonText: "Google ile oturum aç",
              buttonTextColor: Colors.black,
              buttonIcon: Image.asset("assets/images/google-logo.png"),
              onPressed: () => _signInWithGoogle(context),
            ),
            SocialLogInButton(
              buttonText: "E-Posta ile oturum aç",
              buttonIcon: Icon(
                Icons.mail,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () => signInWithMailAndPass(context),
            ),
            SocialLogInButton(
              buttonBgColor: Color(0xFF334D92),
              buttonText: "Misafir olarak devam et",
              buttonIcon: Icon(
                Icons.supervised_user_circle,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () {
                /// SignIn Anon kaldırıldı.
                ///´_signInAnonymously(context),
              },
            ),
          ],
        ),
      ),
    );
  }

/*   
Anon kaldırıldı:
  void _signInAnonymously(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _userModel = await _userViewModel.signInAnonymously();
    if (_userModel != null)
      print("Giriş yapan misafir: " + _userModel.userID.toString());
  }
*/

  void _signInWithGoogle(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _userModel = await _userViewModel.signInWithGoogle();
    if (_userModel != null)
      print("Google ile giriş yapan üye: " + _userModel.userID.toString());
  }

  void signInWithMailAndPass(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MailAndPassForm(),
      ),
    );
  }
}
