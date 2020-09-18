import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';
import 'package:flutter_live_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Sohbet"),
        ),
        body: FutureBuilder<List<UserModel>>(
          future: _userViewModel.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length - 1 > 0) {
                print(snapshot.data[0]);

                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data[index].userID !=
                          _userViewModel.userModel.userID) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data[index].profilePhotoUrl),  
                          ),
                          title: Text(
                              "@" + snapshot.data[index].userName.toString()),
                          subtitle: Text(snapshot.data[index].mail.toString()),
                        );
                      } else {
                        return Container();
                      }
                    });
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
}
