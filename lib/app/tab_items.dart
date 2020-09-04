import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { AllUsers, Profile }

class TabItemData {
  final String titleText;
  final IconData icon;

  TabItemData(this.titleText, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.AllUsers: TabItemData("Kulanıcılar", Icons.supervised_user_circle),
    TabItem.Profile: TabItemData("Profil", Icons.perm_identity),
  };
  
}
