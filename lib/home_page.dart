import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';

class HomePage extends StatelessWidget {
  final AuthBase authBase;
  final VoidCallback onSignOut;


  const HomePage({Key key, @required this.onSignOut, this.authBase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anasayfa"),
        actions: [
          FlatButton(
            onPressed: _signOut,
            child: Text(
              "Çıkış yap",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text("Hoşgeldiniz: " + authBase.currentUser().userID),
      ),
    );
  }

  Future<bool> _signOut() async {
    bool result = await authBase.signOut();
    onSignOut();
    return result;
  }
}
