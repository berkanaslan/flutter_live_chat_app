import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_live_chat_app/app/chat_page.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserModel> _allUsers;
  bool _isLoading = false;
  bool _hasMore = true;
  int _itemsPerPage = 10;
  UserModel _calledLastUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getUsers();
    });
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        getUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Kullanıcılar"),
        ),
        body: _allUsers == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _buildUsersListView(_userViewModel));
  }

  getUsers() async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (!_hasMore) {
      print("Tüm kullanıcılar çağırıldığı için bu metot es geçilecek.");
      return;
    }
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<UserModel> _users = await _userViewModel.getAllUsersWithPagination(
        _calledLastUser, _itemsPerPage);

    if (_calledLastUser == null) {
      _allUsers = [];
      _allUsers.addAll(_users);
    } else {
      _allUsers.addAll(_users);
    }

    if (_users.length < _itemsPerPage) {
      _hasMore = false;
    }

    _calledLastUser = _allUsers.last;

    setState(() {
      _isLoading = false;
    });
  }

  _buildUsersListView(UserViewModel userViewModel) {
    if (_allUsers.length > 1) {
      return RefreshIndicator(
        onRefresh: _refreshUsersList,
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == _allUsers.length) {
              return _buildNewUsersCircularProgressIndicator();
            }
            return buildListTile(index, context, userViewModel);
          },
          itemCount: _allUsers.length + 1,
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _refreshUsersList,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.supervised_user_circle,
                    color: Theme.of(context).primaryColor,
                    size: 120,
                  ),
                  Text(
                    "Henüz Kullanıcı Yok",
                    style: TextStyle(fontSize: 36),
                  )
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height - 150,
          ),
        ),
      );
    }
  }

  Widget buildListTile(
      int index, BuildContext context, UserViewModel userViewModel) {
    if (_allUsers[index].userID == userViewModel.userModel.userID) {
      return Container();
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_allUsers[index].profilePhotoUrl),
      ),
      title: Text("@" + _allUsers[index].userName),
      subtitle: Text(_allUsers[index].mail),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              currentUser: userViewModel.userModel,
              chatUser: _allUsers[index],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewUsersCircularProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Opacity(
          opacity: _isLoading ? 1 : 0,
          child: _isLoading ? CircularProgressIndicator() : null,
        ),
      ),
    );
  }

  Future<Null> _refreshUsersList() async {
    _hasMore = true;
    _calledLastUser = null;
    getUsers();
  }
}
