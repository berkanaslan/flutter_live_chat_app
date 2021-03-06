import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/models/chats_model.dart';
import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/repositories/user_repository.dart';
import 'package:flutter_live_chat_app/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  UserModel _userModel;
  String mailErrorMessage;
  String passErrorMessage;
  String mailErrorMessageForReset;

  UserModel get userModel => _userModel;
  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.currentUser();
      if (_userModel != null) {
        return _userModel;
      } else {
        return null;
      }
    } catch (e) {
      print("ViewModel currentUser() hatası: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInAnonymously();
      return _userModel;
    } catch (e) {
      print("ViewModel currentUser() hatası: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool result = await _userRepository.signOut();
      _userModel = null;
      return result;
    } catch (e) {
      print("ViewModel currentUser() hatası: " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInWithGoogle();
      return _userModel;
    } catch (e) {
      print("ViewModel signInWithGoogle() hatası: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> createWithMailAndPass(String mail, String pass) async {
    if (_mailAndPassControl(mail, pass)) {
      try {
        state = ViewState.Busy;
        _userModel = await _userRepository.createWithMailAndPass(mail, pass);
        return _userModel;
      } finally {
        state = ViewState.Idle;
      }
    } else {
      return null;
    }
  }

  Future<void> resetPassword(String mail) async {
    if (_mailCheck(mail)) {
      state = ViewState.Busy;
      try {
        await _userRepository.resetPassword(mail);
      } finally {
        state = ViewState.Idle;
      }
    }
  }

  @override
  Future<UserModel> signInWithMailAndPass(String mail, String pass) async {
    if (_mailAndPassControl(mail, pass)) {
      try {
        state = ViewState.Busy;
        _userModel = await _userRepository.signInWithMailAndPass(mail, pass);
        return _userModel;
      } finally {
        state = ViewState.Idle;
      }
    } else {
      return null;
    }
  }

  bool _mailCheck(String mail) {
    var result = true;
    if (!mail.contains('@')) {
      mailErrorMessageForReset = "Lütfen geçerli bir e-posta adresi giriniz.";
      result = false;
    } else {
      mailErrorMessageForReset = null;
    }
    return result;
  }

  bool _mailAndPassControl(String mail, String pass) {
    var result = true;

    if (pass.length < 6) {
      passErrorMessage = "Şifreniz en az 6 karakterden oluşmalıdır.";
      result = false;
    } else {
      passErrorMessage = null;
    }
    if (!mail.contains('@')) {
      mailErrorMessage = "Lütfen geçerli bir e-posta adresi giriniz.";
      result = false;
    } else {
      mailErrorMessage = null;
    }

    return result;
  }

  Future<bool> updateUserName(String userID, String userName) async {
    bool result = await _userRepository.updateUserName(userID, userName);
    return result;
  }

  Future<String> uploadFile(String userID, String fileType, String fileName,
      File profilePhoto) async {
    var downloadUrl = await _userRepository.uploadFile(
        userID, fileType, fileName, profilePhoto);
    return downloadUrl;
  }

  Stream<List<MessageModel>> getMessages(
      String currentUserID, String chatUserID) {
    return _userRepository.getMessages(currentUserID, chatUserID);
  }

  Future<List<ChatModel>> getAllConversations(String userID) {
    return _userRepository.getAllConversations(userID);
  }

  Future<UserModel> getUser(String userID) {
    return _userRepository.getUser(userID);
  }

  Future<List<UserModel>> getAllUsersWithPagination(
      UserModel calledLastUser, int itemsPerPage) async {
    return await _userRepository.getAllUsersWithPagination(
        calledLastUser, itemsPerPage);
  }
}
