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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Hero(
            tag: 'profilePhoto',
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.user.profilePhotoUrl),
                          fit: BoxFit.contain)),
                ),
              ),
            ),
          ),
          Center(
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "@" + widget.user.userName,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.user.mail,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      FloatingActionButton(
                        child: Center(child: Icon(Icons.message)),
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
