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

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'mail': mail,
      'userName': userName ?? '',
      'profilePhotoUrl':
          profilePhotoUrl ?? 'assets\\images\\defaultUserPhoto.jpg',
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
    return 'User{userID: $userID, mail: $mail, userName: $userName, profilePhotoUrl: $profilePhotoUrl, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }
}
