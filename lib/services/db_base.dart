import 'package:flutter_live_chat_app/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String userName);
  Future<bool> updateProfilePhoto(String userID, String profilePhotoUrl);
}
