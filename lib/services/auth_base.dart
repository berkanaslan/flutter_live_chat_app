import 'package:flutter_live_chat_app/models/user_model.dart';

abstract class AuthBase {
  UserModel currentUser();
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithMailAndPass(String mail, String pass);
  Future<UserModel> createWithMailAndPass(String mail, String pass);
}
