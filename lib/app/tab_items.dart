import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { AllUsers, ChatHistory, Profile }

class TabItemData {
  final String titleText;
  final IconData icon;

  TabItemData(this.titleText, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.AllUsers: TabItemData("Kulanıcılar", Icons.people),
    TabItem.ChatHistory: TabItemData("Sohbetlerim", Icons.message),
    TabItem.Profile: TabItemData("Profil", Icons.person),
  };
}
