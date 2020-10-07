import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/sign_in/mail_and_pass_form.dart';
import 'package:flutter_live_chat_app/common_widgets/social_log_in_button.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "flutterlivechat.",
          style: GoogleFonts.itim(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: ((MediaQuery.of(context).size.height) * 3 / 5),
              child: Image.asset(
                "assets/images/signInPageImage.png",
                fit: BoxFit.contain,
              ),
            ),
            SocialLogInButton(
              buttonBgColor: Theme.of(context).primaryColor,
              buttonText: "E-Posta ile devam et",
              buttonIcon: Icon(
                Icons.mail,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () => signInWithMailAndPass(context),
            ),
            SocialLogInButton(
              buttonBgColor: Colors.white,
              buttonText: "Google ile devam et",
              buttonTextColor: Colors.black,
              buttonIcon: Image.asset("assets/images/google-logo.png"),
              onPressed: () => _signInWithGoogle(context),
            ),

            /*
            SocialLogInButton(
              buttonBgColor: Color(0xFF334D92),
              buttonText: "Misafir olarak devam et",
              buttonIcon: Icon(
                Icons.supervised_user_circle,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () {
                SignIn Anon kaldırıldı.
                _signInAnonymously(context),
              },
            ),
          */
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
