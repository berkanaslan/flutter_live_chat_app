import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/home_page.dart';
import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';
import 'package:flutter_live_chat_app/services/firebase_auth_service.dart';
import 'package:flutter_live_chat_app/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  UserModel _user;
  AuthBase authBase = locator<FirebaseAuthService>();

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        onSignIn: (user) {
          _updateUser(user);
        },
      );
    } else {
      return HomePage(
        onSignOut: () {
          _updateUser(null);
        },
      );
    }
  }

  void _checkUser() {
    _user = authBase.currentUser();
  }

  void _updateUser(UserModel user) {
    setState(() {
      _user = user;
    });
  }
}
