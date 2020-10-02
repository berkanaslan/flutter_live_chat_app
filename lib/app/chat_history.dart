import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/chat_page.dart';
import 'package:flutter_live_chat_app/models/chats_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/chat_view_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatHistory extends StatefulWidget {
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Konuşmalarım",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFF2F6FA),
          ),
        ),
      ),
      body: FutureBuilder<List<ChatModel>>(
        future:
            _userViewModel.getAllConversations(_userViewModel.userModel.userID),
        builder: (context, future) {
          if (future.hasData) {
            if (future.data.length > 0) {
              return RefreshIndicator(
                onRefresh: _refreshChatHistory,
                child: ListView.builder(
                    itemCount: future.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/defaultUserPhoto.jpg",
                            image: future.data[index].chatUserProfilePhotoUrl,
                            fit: BoxFit.cover,
                            height: 48,
                            width: 48,
                            repeat: ImageRepeat.noRepeat,
                          ),
                        ),
                        title: Text(
                          "@" + future.data[index].chatUserUserName,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        subtitle: future.data[index].lastMessage.length > 25
                            ? Text(
                                future.data[index].lastMessage
                                        .substring(0, 25) +
                                    "...",
                                style: TextStyle(fontSize: 13),
                              )
                            : Text(
                                future.data[index].lastMessage,
                                style: TextStyle(fontSize: 13),
                              ),
                        trailing: Text(future.data[index].timeDifference),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<ChatViewModel>(
                                create: (context) => ChatViewModel(
                                  currentUser: _userViewModel.userModel,
                                  chatUser: UserModel.forChatPage(
                                      userID: future.data[index].chatUser,
                                      profilePhotoUrl: future
                                          .data[index].chatUserProfilePhotoUrl,
                                      userName:
                                          future.data[index].chatUserUserName,
                                      mail: future.data[index].chatUserMail),
                                ),
                                child: ChatPage(),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshChatHistory,
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
                            height:
                                ((MediaQuery.of(context).size.height) * 2 / 6),
                            child: Image.asset(
                              "assets/images/userNotFound.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "Henüz kimseyle sohbet etmediniz..",
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
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<Null> _refreshChatHistory() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {});
    return null;
  }
}
