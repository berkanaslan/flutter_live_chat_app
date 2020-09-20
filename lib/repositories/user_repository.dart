import 'dart:io';

import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';
import 'package:flutter_live_chat_app/services/fake_auth_service.dart';
import 'package:flutter_live_chat_app/services/firebase_auth_service.dart';
import 'package:flutter_live_chat_app/services/firebase_storage_service.dart';
import 'package:flutter_live_chat_app/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel _userModel = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_userModel.userID);
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

      bool _userDocExistResult =
          await _firestoreDBService.checkUserDocExist(_userModel.userID);

      if (_userDocExistResult) {
        return await _firestoreDBService.readUser(_userModel.userID);
      } else {
        bool _result = await _firestoreDBService.saveUser(_userModel);
        if (_result) {
          return await _firestoreDBService.readUser(_userModel.userID);
        } else {
          return null;
        }
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
        return await _firestoreDBService.readUser(_userModel.userID);
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
      UserModel _userModel =
          await _firebaseAuthService.signInWithMailAndPass(mail, pass);
      return await _firestoreDBService.readUser(_userModel.userID);
    }
  }

  Future<bool> updateUserName(String userID, String userName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      bool result = await _firestoreDBService.updateUserName(userID, userName);
      return result;
    }
  }

  Future<String> uploadFile(String userID, String fileType, String fileName,
      File profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "file_download_url";
    } else {
      var _profilePhotoUrl = await _firebaseStorageService.uploadFile(
          userID, fileType, fileName, profilePhoto);
      await _firestoreDBService.updateProfilePhoto(userID, _profilePhotoUrl);
      return _profilePhotoUrl;
    }
  }

  Future<List<UserModel>> getAllUsers(String currentUserID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<UserModel> result =
          await _firestoreDBService.getAllUsers(currentUserID);
      return result;
    }
  }
}
