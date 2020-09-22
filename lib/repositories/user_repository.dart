import 'dart:async';
import 'dart:io';

import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/models/chats_model.dart';
import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';
import 'package:flutter_live_chat_app/services/fake_auth_service.dart';
import 'package:flutter_live_chat_app/services/firebase_auth_service.dart';
import 'package:flutter_live_chat_app/services/firebase_storage_service.dart';
import 'package:flutter_live_chat_app/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<UserModel> allUsersList = [];

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
      allUsersList = await _firestoreDBService.getAllUsers(currentUserID);
      return allUsersList;
    }
  }

  Stream<List<MessageModel>> getMessages(
      String currentUserID, String chatUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserID, chatUserID);
    }
  }

  Future<bool> sendMessage(MessageModel sendingMessage) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      await _firestoreDBService.saveMessage(sendingMessage);
      return true;
    }
  }

  Future<List<ChatModel>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime time = await _firestoreDBService.showTime(userID);

      var chatHistoryList =
          await _firestoreDBService.getAllConversations(userID);

      for (ChatModel currentC in chatHistoryList) {
        var userInUserList = findUserInUserList(currentC.chatUser);

        if (userInUserList != null) {
          print("Konuşulan kişinin verileri local cache'den çağırıldı.");
          currentC.chatUserProfilePhotoUrl = userInUserList.profilePhotoUrl;
          currentC.chatUserUserName = userInUserList.userName;
        } else {
          print("Konuşulan kişinin verileri veritabanından çağırıldı.");
          var userDetailsInDatabase =
              await _firestoreDBService.readUser(currentC.chatUser);
          currentC.chatUserProfilePhotoUrl =
              userDetailsInDatabase.profilePhotoUrl;
          currentC.chatUserUserName = userDetailsInDatabase.userName;
        }

        calculateTimeAgo(currentC, time);
      }
      return chatHistoryList;
    }
  }

  UserModel findUserInUserList(String userID) {
    for (int i = 0; i < allUsersList.length; i++) {
      if (allUsersList[i].userID == userID) {
        return allUsersList[i];
      }
    }

    return null;
  }

  Future<UserModel> getUser(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.getUser(userID);
    }
  }

  void calculateTimeAgo(ChatModel currentC, DateTime time) {
    currentC.lastSeenTime = time;
    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var _duration = time.difference(currentC.createdAt.toDate());
    currentC.timeDifference =
        timeago.format(time.subtract(_duration), locale: "tr");
  }
}
