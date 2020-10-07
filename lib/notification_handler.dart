import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/chat_page.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/chat_view_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    print("Arka planda gelen data:" + message["data"].toString());
    NotificationHandler.showNotification(message);
  }

  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging();

  static final NotificationHandler _singleton = NotificationHandler._internal();

  factory NotificationHandler() {
    return _singleton;
  }

  NotificationHandler._internal();

  BuildContext myContext;

  initializeFCMNotification(BuildContext context) async {
    myContext = context;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_message');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.onTokenRefresh.listen((newToken) async {
      User _currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .doc("tokens/" + _currentUser.uid)
          .set({"token": newToken});
    });

    String token = await _fcm.getToken();
    print("token :" + token);

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage tetiklendi: $message");
        showNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch tetiklendi: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume tetiklendi: $message");
      },
    );
  }

  static void showNotification(Map<String, dynamic> message) async {
    var mesaj = Person(
      key: '1',
      name: message["data"]["title"],
    );
    var mesajStyle = MessagingStyleInformation(mesaj,
        messages: [Message(message["data"]["message"], DateTime.now(), mesaj)]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1234', 'Yeni Mesaj', 'your channel description',
        styleInformation: mesajStyle,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message["data"]["title"],
      message["data"]["message"],
      platformChannelSpecifics,
      payload: jsonEncode(message),
    );
  }

  Future onSelectNotification(String payload) async {
    final _userViewModel = Provider.of<UserViewModel>(myContext, listen: false);
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      Map<String, dynamic> incomingMessageMap = await jsonDecode(payload);
      Navigator.of(myContext, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ChatViewModel>(
            create: (context) => ChatViewModel(
              currentUser: _userViewModel.userModel,
              chatUser: UserModel.forChatPage(
                userID: incomingMessageMap["data"]["senderUserID"],
                profilePhotoUrl: incomingMessageMap["data"]
                    ["senderProfilePhotoUrl"],
                userName: incomingMessageMap["data"]["senderUserName"],
                mail: incomingMessageMap["data"]["senderMail"],
              ),
            ),
            child: ChatPage(),
          ),
        ),
      );
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    return Future.value();
  }
}
