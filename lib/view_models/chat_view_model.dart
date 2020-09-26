import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/repositories/user_repository.dart';

enum ChatViewState { Idle, Busy, Loaded }

class ChatViewModel with ChangeNotifier {
  UserRepository _userRepository = locator<UserRepository>();
  List<MessageModel> _allMessages;
  ChatViewState _state = ChatViewState.Idle;
  final UserModel currentUser;
  final UserModel chatUser;
  static final itemsPerPage = 15;
  MessageModel _firstIndexInMessageList;
  MessageModel _lastCalledMessage;
  bool _hasMore = true;
  bool _newMessageListener = false;
  StreamSubscription _streamSubscription;

  List<MessageModel> get allMessages => _allMessages;
  ChatViewState get state => _state;
  bool get hasMore => _hasMore;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  ChatViewModel({this.currentUser, this.chatUser}) {
    _allMessages = [];
    getMessagesWithPagination(false);
  }

  Future<bool> sendMessage(MessageModel sendingMessage) async {
    return await _userRepository.sendMessage(sendingMessage);
  }

  void getMessagesWithPagination(bool newMessagesIsComing) async {
    if (_allMessages.length > 0) {
      _lastCalledMessage = allMessages.last;
    }

    if (!newMessagesIsComing) {
      state = ChatViewState.Busy;
    }
    var _calledMessages = await _userRepository.getMessagesWithPagination(
        currentUser.userID, chatUser.userID, _lastCalledMessage, itemsPerPage);

    if (_calledMessages.length < itemsPerPage) {
      _hasMore = false;
    }

    _allMessages.addAll(_calledMessages);
    if (_allMessages.length > 0) {
      _firstIndexInMessageList = _allMessages.first;
    }
    state = ChatViewState.Loaded;

    if (_newMessageListener == false) {
      _newMessageListener = true;
      addNewMessageListener();
    }
  }

  getMoreOldMessages() async {
    await Future.delayed(Duration(seconds: 1));
    if (_hasMore) {
      getMessagesWithPagination(true);
    } else {
      print("Daha fazla kullanıcı olmadığı için getMoreUser() çağırılmayacak.");
    }
  }

  addNewMessageListener() {
    _streamSubscription = _userRepository
        .getMessages(currentUser.userID, chatUser.userID)
        .listen((newMessage) {
      if (newMessage.isNotEmpty) {
        if (newMessage[0].date != null) {
          if (_firstIndexInMessageList == null) {
            _allMessages.insert(0, newMessage[0]);
          } else if (_firstIndexInMessageList.date.millisecondsSinceEpoch !=
              newMessage[0].date.millisecondsSinceEpoch) {
            _allMessages.insert(0, newMessage[0]);
          }
        }
        state = ChatViewState.Loaded;
      }
    });
  }
}
