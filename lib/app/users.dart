import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/chat_page.dart';
import 'package:flutter_live_chat_app/view_models/all_users_view_model.dart';
import 'package:flutter_live_chat_app/view_models/chat_view_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listControlListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Kullanıcılar"),
      ),
      body: Consumer<AllUsersViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUsersViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUsersViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.listRefresh,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (model.allUsers.length == 1) {
                    return buildUsersListIsEmpty();
                  } else if (model.hasMore == true &&
                      index == model.allUsers.length) {
                    return _buildNewUsersCircularProgressIndicator();
                  } else {
                    return buildListTile(index);
                  }
                },
                itemCount: model.hasMore == true
                    ? model.allUsers.length + 1
                    : model.allUsers.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildUsersListIsEmpty() {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    return RefreshIndicator(
      onRefresh: _allUsersViewModel.listRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 92,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: ((MediaQuery.of(context).size.height) * 2 / 6),
                  child: Image.asset(
                    "assets/images/userNotFound.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  "Sistemde kayıtlı kullanıcı bulunamadı.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile(int index) {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    final _userViewModel = Provider.of<UserViewModel>(context);
    var _currentUser = _allUsersViewModel.allUsers[index];

    // Tüm kullanıcı listesi içerisinde mevcut kullanıcıyı dışladım:
    if (_currentUser.userID == _userViewModel.userModel.userID) {
      return Container();
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_currentUser.profilePhotoUrl),
      ),
      title: Text("@" + _currentUser.userName),
      subtitle: Text(_currentUser.mail),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<ChatViewModel>(
              create: (context) => ChatViewModel(
                  currentUser: _userViewModel.userModel,
                  chatUser: _currentUser),
              child: ChatPage(),
            ),
          ),
        );
      },
    );
  }

  getMoreUsers() async {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    if (_isLoading == false) {
      _isLoading = true;
      await _allUsersViewModel.getMoreUsers();
      _isLoading = false;
    }
  }

  Widget _buildNewUsersCircularProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _listControlListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getMoreUsers();
    }
  }
}
