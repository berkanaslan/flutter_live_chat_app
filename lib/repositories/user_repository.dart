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
import 'package:flutter_live_chat_app/services/notification_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  NotificationService _notificationService = locator<NotificationService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<UserModel> allUsersList = [];
  Map<String, dynamic> _userToken = Map<String, dynamic>();

  @override
  Future<UserModel> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel _userModel = await _firebaseAuthService.currentUser();
      if (_userModel != null)
        return await _firestoreDBService.readUser(_userModel.userID);
      else
        return null;
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

  Stream<List<MessageModel>> getMessages(
      String currentUserID, String chatUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserID, chatUserID);
    }
  }

  Future<bool> sendMessage(
      MessageModel sendingMessage, UserModel currentUser) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var _writePrcs = await _firestoreDBService.saveMessage(sendingMessage);
      if (_writePrcs) {
        var _token = "";
        if (_userToken.containsKey(sendingMessage.toWho)) {
          _token = _userToken[sendingMessage.toWho];
          print("Token lokalden geldi.");
        } else {
          _token = await _firestoreDBService.getUserToken(sendingMessage.toWho);
          _userToken[sendingMessage.toWho] = _token;

          print("Token  veritabanından geldi.");
        }

        await _notificationService.sendNotification(
            sendingMessage, currentUser, _token);
      }
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
          currentC.chatUserMail = userInUserList.mail;
        } else {
          print("Konuşulan kişinin verileri veritabanından çağırıldı.");
          var userDetailsInDatabase =
              await _firestoreDBService.readUser(currentC.chatUser);
          currentC.chatUserProfilePhotoUrl =
              userDetailsInDatabase.profilePhotoUrl;
          currentC.chatUserUserName = userDetailsInDatabase.userName;
          currentC.chatUserMail = userDetailsInDatabase.mail;
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

  Future<List<UserModel>> getAllUsersWithPagination(
      UserModel calledLastUser, int itemsPerPage) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<UserModel> _userList = await _firestoreDBService
          .getAllUsersWithPagination(calledLastUser, itemsPerPage);
      allUsersList.addAll(_userList);

      return _userList;
    }
  }

  Future<List<MessageModel>> getMessagesWithPagination(
      String currentUserID,
      String chatUserID,
      MessageModel lastCalledMessage,
      int itemsPerPage) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _firestoreDBService.getMessagesWithPagination(
          currentUserID, chatUserID, lastCalledMessage, itemsPerPage);
    }
  }

  Future<void> resetPassword(String mail) {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return _firebaseAuthService.resetPassword(mail);
    }
  }
}
