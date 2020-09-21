import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/models/chats_model.dart';
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
        centerTitle: true,
        title: Text("Geçmiş"),
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream:
            _userViewModel.getAllConversations(_userViewModel.userModel.userID),
        builder: (context, streamList) {
          return ListView.builder(
              itemCount: streamList.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(streamList.data[index].lastMessage),
                );
              });
        },
      ),
    );
  }
}
