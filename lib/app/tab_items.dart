import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { ChatHistory, AllUsers, Profile }

class TabItemData {
  final String titleText;
  final IconData icon;

  TabItemData(this.titleText, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.ChatHistory: TabItemData("Sohbetlerim", Icons.message),
    TabItem.AllUsers: TabItemData("Kulanıcılar", Icons.people),
    TabItem.Profile: TabItemData("Profil", Icons.person),
  };
}
