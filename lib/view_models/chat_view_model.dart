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
  MessageModel _lastCalledMessage;
  bool _hasMore = true;

  List<MessageModel> get allMessages => _allMessages;
  ChatViewState get state => _state;
  bool get hasMore => _hasMore;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  ChatViewModel({this.currentUser, this.chatUser}) {
    _allMessages = [];
    getMessagesWithPagination(false);
  }

  Future<bool> sendMessage(MessageModel sendingMessage) async {
    return await _userRepository.sendMessage(sendingMessage);
  }

  void getMessagesWithPagination(bool newMessagesIsComing) async {
    if (_allMessages.length > 1) {
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

    _calledMessages.forEach(
        (element) => print("Getirilen mesaj: " + element.message.toString()));

    _allMessages.addAll(_calledMessages);
    state = ChatViewState.Loaded;
  }

  getMoreOldMessages() async {
    await Future.delayed(Duration(seconds: 1));
    print("getMoreOldMessages() tetiklendi. ChatViewModel");
    if (_hasMore) {
      getMessagesWithPagination(true);
    } else {
      print("Daha fazla kullanıcı olmadığı için getMoreUser() çağırılmayacak.");
    }
  }
}
