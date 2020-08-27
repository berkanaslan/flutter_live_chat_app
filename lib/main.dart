import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Live Chat',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SignInPage(),
    );
  }
}
