import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_chat_app/app/tab_items.dart';

class MyCustomBottomNavigationBar extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const MyCustomBottomNavigationBar(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.pageCreator,
      @required this.navigatorKeys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _createNavItem(TabItem.ChatHistory),
          _createNavItem(TabItem.AllUsers),
          _createNavItem(TabItem.Profile),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final pageIndex = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[pageIndex],
          builder: (context) {
            return pageCreator[pageIndex];
          },
        );
      },
    );
  }

  BottomNavigationBarItem _createNavItem(TabItem tabItem) {
    final buildTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(buildTab.icon),
      title: Text(buildTab.titleText),
    );
  }
}
