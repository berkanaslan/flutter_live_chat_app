import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatOwner;
  final String chatUser;
  final Timestamp createdAt;
  final bool isRead;
  final String lastMessage;
  final Timestamp readedTime;
  String chatUserUserName;
  String chatUserProfilePhotoUrl;
  DateTime lastSeenTime;
  String timeDifference;

  ChatModel(this.chatOwner, this.chatUser, this.createdAt, this.isRead,
      this.lastMessage, this.readedTime);

  Map<String, dynamic> toMap() {
    return {
      'chatOwner': chatOwner,
      'chatUser': chatUser,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'isRead': isRead,
      'lastMessage': lastMessage,
      'readedTime': readedTime ?? FieldValue.serverTimestamp(),
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map)
      : chatOwner = map['chatOwner'],
        chatUser = map['chatUser'],
        createdAt = map['createdAt'],
        isRead = map['isRead'],
        lastMessage = map['lastMessage'],
        readedTime = map['readedTime'];

  @override
  String toString() {
    return 'ChatModel{chatOwner: $chatOwner, chatUser: $chatUser, createdAt: $createdAt, isRead: $isRead, lastMessage: $lastMessage, readedTime: $readedTime, chatUserUserName: $chatUserUserName, chatUserProfilePhotoUrl: $chatUserProfilePhotoUrl}';
  }
}
