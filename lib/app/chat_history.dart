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
      body: FutureBuilder<List<ChatModel>>(
        future:
            _userViewModel.getAllConversations(_userViewModel.userModel.userID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var allConversations = snapshot.data;

            return ListView.builder(
              itemCount: allConversations.length,
              itemBuilder: (context, index) {
                var currentChat = allConversations[index];
                
                print(allConversations.toString());
                return ListTile(
                  title: Text(currentChat.lastMessage),
                );
              },
            );
          }
        },
      ),
    );
  }
}
