import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/chat_page.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _listTileType = true;

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Sohbet"),
          actions: [
            IconButton(
              color: Colors.white,
              icon: _listTileType == true ? Icon(Icons.dns) : Icon(Icons.list),
              onPressed: () {
                if (_listTileType == true) {
                  setState(() {
                    _listTileType = false;
                  });
                } else {
                  setState(() {
                    _listTileType = true;
                  });
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<List<UserModel>>(
          future: _userViewModel.getAllUsers(_userViewModel.userModel.userID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                if (_listTileType) {
                  return buildListView(context, _userViewModel, snapshot);
                } else {
                  return buildGridView(context, _userViewModel, snapshot);
                }
              } else {
                return Center(
                  child: Text("Sistemde kayıtlı kullanıcı bulunamadı."),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  ListView buildListView(BuildContext context, UserViewModel userViewModel,
      AsyncSnapshot<List<UserModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshot.data[index].profilePhotoUrl),
              ),
              title: Text("@" + snapshot.data[index].userName.toString()),
              subtitle: Text(snapshot.data[index].mail.toString()),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    currentUser: userViewModel.userModel,
                    chatUser: snapshot.data[index],
                  ),
                ),
              );
            },
          );
        });
  }

  buildGridView(BuildContext context, UserViewModel userViewModel,
      AsyncSnapshot<List<UserModel>> snapshot) {
    double circleRadius = 96;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          itemCount: snapshot.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              childAspectRatio: (12 / 6)),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      //  image: DecorationImage(
                      //  image: NetworkImage("kapakfotografiUrl"),
                      //  fit: BoxFit.cover,
                      //  ),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: circleRadius / 2.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 48.0),
                            child: Column(children: [
                              Text(
                                "@" + snapshot.data[index].userName.toString(),
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(snapshot.data[index].mail.toString()),
                              Text(
                                snapshot.data[index].createdAt.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: circleRadius,
                    height: circleRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              snapshot.data[index].profilePhotoUrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      currentUser: userViewModel.userModel,
                      chatUser: snapshot.data[index],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
