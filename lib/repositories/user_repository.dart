import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';
import 'package:flutter_live_chat_app/services/fake_auth_service.dart';
import 'package:flutter_live_chat_app/services/firebase_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  AppMode appMode = AppMode.DEBUG;

  @override
  UserModel currentUser() {
    if (appMode == AppMode.DEBUG) {
      return _fakeAuthService.currentUser();
    } else {
      return _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return _fakeAuthService.signInAnonymously();
    } else {
      return _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() {
    if (appMode == AppMode.DEBUG) {
      return _fakeAuthService.signOut();
    } else {
      return _firebaseAuthService.signOut();
    }
  }
}
