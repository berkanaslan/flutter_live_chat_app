import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/home_page.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';
import 'package:flutter_live_chat_app/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  final AuthBase authBase;

  const LandingPage({Key key, @required this.authBase}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  UserModel _user;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        authBase: widget.authBase,
        onSignIn: (user) {
          _updateUser(user);
        },
      );
    } else {
      return HomePage(
        authBase: widget.authBase,
        onSignOut: () {
          _updateUser(null);
        },
      );
    }
  }

  void _checkUser() {
    _user = widget.authBase.currentUser();
  }

  void _updateUser(UserModel user) {
    setState(() {
      _user = user;
    });
  }
}
