import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';

// ignore: must_be_immutable
class ProfilePhotoDetail extends StatefulWidget {
  UserModel user;

  ProfilePhotoDetail({this.user});

  @override
  _ProfilePhotoDetailState createState() => _ProfilePhotoDetailState();
}

class _ProfilePhotoDetailState extends State<ProfilePhotoDetail> {
  @override
  Widget build(BuildContext context) {
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
          title: Text(
            "@" + widget.user.userName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(child: Icon(Icons.message)),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Hero(
            tag: 'profilePhoto',
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: (MediaQuery.of(context).size.width) * 2 / 3,
                  height: (MediaQuery.of(context).size.height) * 2 / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.user.profilePhotoUrl),
                          fit: BoxFit.contain)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
