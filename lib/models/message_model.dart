import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String fromWho;
  final String toWho;
  final bool isFromMe;
  final String message;
  final Timestamp date;

  MessageModel(
      {this.fromWho, this.toWho, this.isFromMe, this.message, this.date});

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho,
      'toWho': toWho,
      'isFromMe': isFromMe,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map)
      : fromWho = map['fromWho'],
        toWho = map['toWho'],
        isFromMe = map['isFromMe'],
        message = map['message'],
        date = map['date'];

  @override
  String toString() {
    return 'MessageModel{fromWho: $fromWho, toWho: $toWho, isFromMe: $isFromMe, message: $message, date: $date}';
  }
}
