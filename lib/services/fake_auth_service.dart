import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "fake_user_id_123";
  String mail = "fake@mail.com";

  @override
  Future<UserModel> currentUser() async {
    return await Future.value(UserModel(userID: userID, mail: mail));
  }

  @override
  Future<UserModel> signInAnonymously() async {
    return await Future.delayed(
      Duration(seconds: 1),
      () => UserModel(userID: userID, mail: mail),
    );
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    return await Future.delayed(
      Duration(seconds: 1),
      () => UserModel(userID: userID, mail: mail),
    );
  }

  @override
  Future<UserModel> createWithMailAndPass(String mail, String pass) async {
    return await Future.delayed(
      Duration(seconds: 1),
      () => UserModel(userID: userID, mail: mail),
    );
  }

  @override
  Future<UserModel> signInWithMailAndPass(String mail, String pass) async {
    return await Future.delayed(
      Duration(seconds: 1),
      () => UserModel(userID: userID, mail: mail),
    );
  }
}
