import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Text("Kullanıcılar sayfası"),
      ),
    );
  }
}
