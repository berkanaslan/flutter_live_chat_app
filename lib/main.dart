import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/landing_page.dart';
import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Live Chat',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: LandingPage(),
      ),
    );
  }
}
