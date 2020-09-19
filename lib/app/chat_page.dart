import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';

class ChatPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel chatUser;

  const ChatPage({Key key, this.currentUser, this.chatUser}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Sohbet",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text("Konuşmanın kendisi"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Bir mesaj yazın",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.send,
                        size: 24,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
