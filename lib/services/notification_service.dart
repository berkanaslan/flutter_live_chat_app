import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/firestore_db_service.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  sendNotification  (
      MessageModel messageModel, UserModel sender, String receiverToken) async {
    String endUrl = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey = await  FirestoreDBService().getFirebaseNotificationKey();

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
