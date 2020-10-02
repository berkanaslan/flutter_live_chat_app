import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  sendNotification(
      MessageModel messageModel, UserModel sender, String receiverToken) async {
    String endUrl = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey =
        "AAAAyOIUm10:APA91bEmHti39s1FseqM_Cv3wSgRhZhgk_XkhdgXGXxQDHZBU14qkBd3YbU7J9ULYZlWQS6avFzecl3zN9WpypubAGhDejq6nUS9O77KgVc0l7ICWNdhaGzFt0qjZ1QIsdIs9S5_uHNk";

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey"
    };

    String json =
        '{ "to": "$receiverToken", "data": { "title" : "@${sender.userName} yeni mesaj: ", "message" : "${messageModel.message}", "senderProfilePhotoUrl" : "${sender.profilePhotoUrl}", "senderUserID" : "${sender.userID}", "senderMail" : "${sender.mail}", "senderUserName" : "${sender.userName}"  } }';

    http.Response response =
        await http.post(endUrl, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("İşlem başarılı");
    } else {
      print("İşlem başarısız:" + response.statusCode.toString());
    }
  }
}
