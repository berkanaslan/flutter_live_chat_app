import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/landing_page.dart';
import 'package:flutter_live_chat_app/services/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: LandingPage(
        authBase: FirebaseAuthService(),
      ),
    );
  }
}
