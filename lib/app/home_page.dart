import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/my_custom_bottom_navi_bar.dart';
import 'package:flutter_live_chat_app/app/profile.dart';
import 'package:flutter_live_chat_app/app/tab_items.dart';
import 'package:flutter_live_chat_app/app/users.dart';
import 'package:flutter_live_chat_app/models/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  const HomePage({Key key, @required this.userModel}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.AllUsers;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.AllUsers: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.AllUsers: UsersPage(),
      TabItem.Profile: ProfilePage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WillPopScope(
        onWillPop: () async =>
            !await navigatorKeys[_currentTab].currentState.maybePop(),
        child: MyCustomBottomNavigationBar(
          navigatorKeys: navigatorKeys,
          currentTab: _currentTab,
          pageCreator: allPages(),
          onSelectedTab: (selectedTab) {
            if (selectedTab == _currentTab) {
              navigatorKeys[selectedTab]
                  .currentState
                  .popUntil((route) => route.isFirst);
            }

            setState(() {
              _currentTab = selectedTab;
            });
          },
        ),
      ),
    );
  }
}
