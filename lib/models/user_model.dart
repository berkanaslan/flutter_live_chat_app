import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  final String userID;
  String mail;
  String userName;
  String profilePhotoUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int level;

  UserModel({@required this.userID, @required this.mail});

  UserModel.forChatPage(
      {this.userID, this.profilePhotoUrl, this.userName, this.mail});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'mail': mail,
      'userName': userName ??
          mail.substring(0, mail.indexOf('@')) + buildRandomUserNameID(),
      'profilePhotoUrl': profilePhotoUrl ??
          'https://firebasestorage.googleapis.com/v0/b/flutter-live-chat-2020.appspot.com/o/images%2FdefaultUserPhoto.jpg?alt=media&token=fc1dcf75-1776-404a-a29c-4f7d71f17147',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        mail = map['mail'],
        userName = map['userName'],
        profilePhotoUrl = map['profilePhotoUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'];

  @override
  String toString() {
    return 'UserModel{userID: $userID, mail: $mail, userName: $userName, profilePhotoUrl: $profilePhotoUrl, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String buildRandomUserNameID() {
    int random = Random().nextInt(99999999);
    return random.toString();
  }
}
