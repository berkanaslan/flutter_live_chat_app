import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/profile_image_page.dart';
import 'package:flutter_live_chat_app/models/message_model.dart';
import 'package:flutter_live_chat_app/view_models/chat_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final _chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            alignment: Alignment.centerLeft,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          titleSpacing: -20,
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: GestureDetector(
              child: Container(
                child: Hero(
                  tag: 'profilePhoto',
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      _chatViewModel.chatUser.profilePhotoUrl,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProfilePhotoDetail(user: _chatViewModel.chatUser)));
              },
            ),
            title: Text(
              "@" + _chatViewModel.chatUser.userName,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _chatViewModel.chatUser.mail,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: _chatViewModel.state == ChatViewState.Busy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                  children: [
                    buildMessageList(),
                    buildMessageInputArea(),
                  ],
                ),
              ));
  }

  Widget buildMessageList() {
    return Consumer<ChatViewModel>(builder: (context, model, child) {
      if (model.allMessages.length > 0) {
        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemCount: model.hasMore
                ? model.allMessages.length + 1
                : model.allMessages.length,
            itemBuilder: (context, index) {
              if (model.hasMore && model.allMessages.length == index) {
                return _buildOldMessagesCircularProgressIndicator();
              }

              if (index == 0) {
                return _buildMessageBalloon(model.allMessages[index]);
              } else {
                return _buildMessageBalloon(model.allMessages[index]);
              }
            },
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget buildMessageInputArea() {
    final _chatViewModel = Provider.of<ChatViewModel>(context);

    return Container(
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
                    fromWho: _chatViewModel.currentUser.userID,
                    toWho: _chatViewModel.chatUser.userID,
                    isFromMe: true,
                    message: _messageController.text,
                  );

                  _messageController.clear();

                  var _result =
                      await _chatViewModel.sendMessage(_sendingMessage);

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

  void _listScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getMoreOldMessages();
    }
  }

  void getMoreOldMessages() async {
    final _chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatViewModel.getMoreOldMessages();
      _isLoading = false;
    }
  }

  Widget _buildOldMessagesCircularProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
