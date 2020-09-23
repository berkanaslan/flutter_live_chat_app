import 'package:flutter_live_chat_app/models/chats_model.dart';
import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String userName);
  Future<bool> updateProfilePhoto(String userID, String profilePhotoUrl);
  //Future<List<UserModel>> getAllUsers(String currentUserID);
  Future<List<UserModel>> getAllUsersWithPagination(
      UserModel calledLastUser, int itemsPerPage);
  Future<List<ChatModel>> getAllConversations(String currentUserID);
  Stream<List<MessageModel>> getMessages(
      String currentUserID, String chatUserID);
  Future<bool> saveMessage(MessageModel sendingMessage);
  Future<DateTime> showTime(String userID);
}
