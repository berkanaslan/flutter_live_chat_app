import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/home_page.dart';
import 'package:flutter_live_chat_app/app/sign_in/sign_in_page.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: true);

    if (_userViewModel.state == ViewState.Idle) {
      if (_userViewModel.userModel == null) {
        return SignInPage();
      } else {
        return HomePage(
          userModel: _userViewModel.userModel,
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: Container(
            child: Image.asset(
              "assets/images/logo.png",
              width: (MediaQuery.of(context).size.width) * 2 / 3,
            ),
          ),
        ),
      );
    }
  }
}
