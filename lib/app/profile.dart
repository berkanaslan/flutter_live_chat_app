import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          FlatButton(
            child: Text(
              "Çıkış yap",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Text("Profil sayfası"),
      ),
    );
  }

  Future<bool> _signOut(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userViewModel.signOut();
    return result;
  }
}
