import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';
import 'package:flutter_live_chat_app/services/fake_auth_service.dart';
import 'package:flutter_live_chat_app/services/firebase_auth_service.dart';
import 'package:flutter_live_chat_app/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

  AppMode appMode = AppMode.RELEASE;

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
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      UserModel _userModel = await _firebaseAuthService.signInWithGoogle();
      bool _result = await _firestoreDBService.saveUser(_userModel);
      if (_result) {
        return _userModel;
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel> createWithMailAndPass(String mail, String pass) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createWithMailAndPass(mail, pass);
    } else {
      UserModel _userModel =
          await _firebaseAuthService.createWithMailAndPass(mail, pass);
      bool _result = await _firestoreDBService.saveUser(_userModel);
      if (_result) {
        return _userModel;
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel> signInWithMailAndPass(String mail, String pass) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithMailAndPass(mail, pass);
    } else {
      return await _firebaseAuthService.signInWithMailAndPass(mail, pass);
    }
  }
}
