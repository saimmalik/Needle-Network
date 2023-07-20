// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:needle_network_main/MainApp/EditAccountInfo.dart';
import 'package:needle_network_main/MainApp/HomePage.dart';
import 'package:needle_network_main/MainApp/TailorsMap.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'MessagesPage.dart';

class PersistentBottomBar extends StatefulWidget {
  const PersistentBottomBar({super.key});

  @override
  State<PersistentBottomBar> createState() => _PersistentBottomBarState();
}

class _PersistentBottomBarState extends State<PersistentBottomBar> {
  PersistentTabController? controller;
  late List<Widget> screens;
  @override
  void initState() {
    controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  void onIndexChanged(int index) {
    setState(() {
      controller!.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: screens = [
        HomePage(
          controller: controller,
        ),
        const TailorsMap(),
        const MessagesPage(),
        const EditAccountInfo(),
      ],
      controller: controller,
      onItemSelected: onIndexChanged,
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style6,
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.house_outlined),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.location_on_outlined),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat_bubble_outline_rounded),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_outline),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
      ],
    );
  }
}
