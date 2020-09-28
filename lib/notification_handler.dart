import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_live_chat_app/common_widgets/platform_alert_dialog.dart';

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Arkaplanda iken gelen Data: " + message["data"].toString());
  }

  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final NotificationHandler _singleton = NotificationHandler._internal();

  factory NotificationHandler() {
    return _singleton;
  }

  NotificationHandler._internal();

  initializeFCMNotification(BuildContext context) async {
    _firebaseMessaging.subscribeToTopic("genel");

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage tetiklendi: $message");
        PlatformAlertDialog(
          title: "test-baslik",
          message: "test-mesaj",
          mainActionText: "kapat",
        ).show(context);
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
}
