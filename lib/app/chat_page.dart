import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/common_widgets/custom_appbar.dart';
import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:intl/intl.dart';
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
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = widget.currentUser;
    UserModel chatUser = widget.chatUser;
    final _userViewModel = Provider.of<UserViewModel>(context, listen: true);

    return Scaffold(
      appBar: CustomAppBar(
        onImagetab: () {},
        profilePic: Image.network(
          chatUser.profilePhotoUrl,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
        username: "@" + chatUser.userName,
        status: Text(
          chatUser.mail,
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).primaryColor,
        backButtonColor: Colors.white,
        backbutton: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
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

                  if (allMessages.length > 0) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          var _dateyMd =
                              _formatDateyMd(allMessages[index].date);
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Bubble(
                                  alignment: Alignment.center,
                                  color: Color.fromRGBO(212, 234, 244, 1.0),
                                  child: Text(_dateyMd.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 11.0)),
                                ),
                              ),
                              _buildMessageBalloon(allMessages[index]),
                            ],
                          );
                        } else {
                          var _dateyMd =
                              _formatDateyMd(allMessages[index].date);
                          var _prevDateyMd =
                              _formatDateyMd(allMessages[index - 1].date);

                          if (_dateyMd == _prevDateyMd) {
                            return _buildMessageBalloon(allMessages[index]);
                          } else {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Bubble(
                                    alignment: Alignment.center,
                                    color: Color.fromRGBO(212, 234, 244, 1.0),
                                    child: Text(_dateyMd.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11.0)),
                                  ),
                                ),
                                _buildMessageBalloon(allMessages[index]),
                              ],
                            );
                          }
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
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

                          _messageController.clear();

                          var _result =
                              await _userViewModel.sendMessage(_sendingMessage);

                          if (_result) {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 50),
                                curve: Curves.easeInCubic);
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
    var _myMessage = currentMessage.isFromMe;
    var _dateHm = _formatDateHm(currentMessage.date);

    return _myMessage == true
        ? Bubble(
            margin: BubbleEdges.all(5),
            alignment: Alignment.topRight,
            nipWidth: 8,
            nipHeight: 24,
            nip: BubbleNip.rightTop,
            color: Color.fromRGBO(225, 255, 199, 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(currentMessage.message, textAlign: TextAlign.right),
                SizedBox(
                  height: 5,
                ),
                Text(
                  _dateHm.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          )
        : Bubble(
            margin: BubbleEdges.all(5),
            alignment: Alignment.topLeft,
            nipWidth: 8,
            nipHeight: 24,
            nip: BubbleNip.leftTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentMessage.message, textAlign: TextAlign.right),
                SizedBox(
                  height: 5,
                ),
                Text(
                  _dateHm.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          );
  }

  String _formatDateHm(Timestamp date) {
    var dateFormat = DateFormat.Hm();
    var _formatter = dateFormat;
    var _formattedDate = _formatter.format(date.toDate());
    return _formattedDate;
  }

  String _formatDateyMd(Timestamp date) {
    var dateFormat = DateFormat.yMd();
    var _formatter = dateFormat;
    var _formattedDate = _formatter.format(date.toDate());
    return _formattedDate;
  }
}
