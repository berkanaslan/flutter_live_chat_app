import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "fake_user_id_123";

  @override
  UserModel currentUser() {
    return UserModel(userID: userID);
  }

  @override
  Future<UserModel> signInAnonymously() async {
    return await Future.delayed(
      Duration(seconds: 2),
      () => UserModel(userID: userID),
    );
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }
}
