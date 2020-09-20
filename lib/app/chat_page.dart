import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

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
    UserModel currentUser = widget.currentUser;
    UserModel chatUser = widget.chatUser;
    final _userViewModel = Provider.of<UserViewModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("@" + chatUser.userName.toString()),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: _userViewModel.getMessages(
                    currentUser.userID, chatUser.userID),
                builder: (context, streamMesssageList) {
                  if (!streamMesssageList.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<MessageModel> allMessages = streamMesssageList.data;

                  return ListView.builder(
                    itemCount: allMessages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBalloon(allMessages[index]);
                    },
                  );
                },
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
                      onPressed: () async {
                        if (_messageController.text.trim().length > 0) {
                          MessageModel _sendingMessage = MessageModel(
                            fromWho: currentUser.userID,
                            toWho: chatUser.userID,
                            isFromMe: true,
                            message: _messageController.text,
                          );

                          var _result =
                              await _userViewModel.sendMessage(_sendingMessage);

                          if (_result) {
                            _messageController.clear();
                          }
                        }
                      },
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

  Widget _buildMessageBalloon(MessageModel currentMessage) {
    Color senderColor = Theme.of(context).primaryColor;
    Color receiverColor = Colors.blueGrey;

    var _myMessage = currentMessage.isFromMe;

    if (_myMessage == true) {
      return ChatBubble(
        clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5),
        backGroundColor: senderColor,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            currentMessage.message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return ChatBubble(
        clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 5),
        backGroundColor: receiverColor,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            currentMessage.message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
