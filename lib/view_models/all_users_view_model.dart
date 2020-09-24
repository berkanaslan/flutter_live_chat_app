import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/locator.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/repositories/user_repository.dart';

enum AllUsersViewState { Idle, Busy, Loaded }

class AllUsersViewModel with ChangeNotifier {
  AllUsersViewState _state = AllUsersViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  List<UserModel> _allUsers;
  UserModel _lastCalledUser;
  static final itemsPerPage = 15;
  bool _hasMore = true;

  List<UserModel> get allUsers => _allUsers;
  AllUsersViewState get state => _state;
  bool get hasMore => _hasMore;

  set state(AllUsersViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUsersViewModel() {
    _allUsers = [];
    _lastCalledUser = null;
    getUsersWithPagination(_lastCalledUser, false);
  }

  // RefreshIndicator ve Pagination için
  // isNewItems = true yapılır.
  // İlk açılış için isNewITems = false yapılır.

  getUsersWithPagination(UserModel lastCalledUser, bool isNewItems) async {
    if (_allUsers.length > 0) {
      _lastCalledUser = _allUsers.last;
      print("En son getirilen kullanıcı adı: " + _lastCalledUser.userName);
    }

    if (isNewItems) {
    } else {
      state = AllUsersViewState.Busy;
    }

    List<UserModel> _newList = await _userRepository.getAllUsersWithPagination(
        _lastCalledUser, itemsPerPage);

    if (_newList.length < itemsPerPage) {
      _hasMore = false;
    }

    _newList.forEach((element) =>
        print("Çağırılan kullanıcının kullanıcı adı: " + element.userName));

    _allUsers.addAll(_newList);

    state = AllUsersViewState.Loaded;
  }

  Future<void> getMoreUsers() async {
    await Future.delayed(Duration(seconds: 1));
    print("getMoreUsers() tetiklendi. AllUsersViewModel");
    if (_hasMore) {
      getUsersWithPagination(_lastCalledUser, true);
    } else {
      print("Daha fazla kullanıcı olmadığı için getMoreUser() çağırılmayacak.");
    }
  }

  Future<void> listRefresh() async {
    _hasMore = true;
    _lastCalledUser = null;
    _allUsers = [];
    getUsersWithPagination(_lastCalledUser, true);
  }
}
