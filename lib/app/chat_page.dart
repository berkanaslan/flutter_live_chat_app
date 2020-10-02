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
              color: Color(0xFFF2F6FA),
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
              style: TextStyle(
                  color: Color(0xFFF2F6FA),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            subtitle: Text(
              _chatViewModel.chatUser.mail,
              style: TextStyle(color: Color(0xFFF2F6FA), fontSize: 12),
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
              } else {
                if ((model.allMessages.length - 1) == index) {
                  var _dateyMd =
                      model.formatDateyMd(model.allMessages.last.date);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Bubble(
                          alignment: Alignment.center,
                          color: Color.fromRGBO(212, 234, 244, 1.0),
                          child: Text(_dateyMd.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10.0)),
                        ),
                      ),
                      _buildMessageBalloon(model.allMessages.last),
                    ],
                  );
                } else {
                  var _dateyMd =
                      model.formatDateyMd(model.allMessages[index].date);
                  var _prevDateyMd =
                      model.formatDateyMd(model.allMessages[index + 1].date);

                  if (_dateyMd == _prevDateyMd) {
                    return _buildMessageBalloon(model.allMessages[index]);
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Bubble(
                            alignment: Alignment.center,
                            color: Color.fromRGBO(212, 234, 244, 1.0),
                            child: Text(_dateyMd.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.0)),
                          ),
                        ),
                        _buildMessageBalloon(model.allMessages[index]),
                      ],
                    );
                  }
                }
              }
            }),
      );
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
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                Icons.send,
                size: 24,
                color: Color(0xFF414651),
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

                  var _result = await _chatViewModel.sendMessage(
                      _sendingMessage, _chatViewModel.currentUser);

                  if (_result) {
                    _scrollController.animateTo(0,
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
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Bubble(
                stick: true,
                margin: BubbleEdges.all(5),
                alignment: Alignment.topRight,
                nip: BubbleNip.no,
                color: Colors.teal,
                child: Text(
                  currentMessage.message,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  _dateHm.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bubble(
                stick: true,
                margin: BubbleEdges.all(5),
                alignment: Alignment.topLeft,
                nip: BubbleNip.no,
                color: Colors.white,
                child: Text(
                  currentMessage.message,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  _dateHm.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
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
