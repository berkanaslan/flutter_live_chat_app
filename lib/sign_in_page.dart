import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/common_widgets/social_log_in_button.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Live Chat"),
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
              onPressed: (){},
            ),
            SocialLogInButton(
              buttonText: "E-Posta ile oturum aç",
              buttonIcon: Icon(Icons.mail, size: 32, color: Colors.white,),
              onPressed: (){},
            ),
            SocialLogInButton(
              buttonBgColor: Color(0xFF334D92),
              buttonText: "Misafir olarak devam et",
              buttonIcon: Icon(Icons.supervised_user_circle, size: 32, color: Colors.white,),
              onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }
}
