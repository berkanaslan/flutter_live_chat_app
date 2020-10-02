import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_live_chat_app/app/landing_page.dart';
import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.teal,
    statusBarIconBrightness: Brightness.light,
  ));

  await Firebase.initializeApp();
  setupLocator();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(RunApp());
  });
}

class RunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Live Chat',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            //  color: Color(0xFFF2F6FA),
            elevation: 0,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          primarySwatch: Colors.teal,
          canvasColor: Color(0xFFF2F6FA),
          cardColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: LandingPage(),
      ),
    );
  }
}
