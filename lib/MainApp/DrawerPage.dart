// ignore_for_file: file_names, prefer_const_constructors_in_immutables, must_be_immutable, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/Login&Signup/LoginPage.dart';
import 'package:needle_network_main/MainApp/NotificationsPage.dart';
import 'package:needle_network_main/MainApp/OrdersPage.dart';
import 'package:needle_network_main/ModalClasses/UserData.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class DrawerPage extends StatefulWidget {
  PersistentTabController? controller;
  DrawerPage({super.key, this.controller});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  UserData? userData;
  pushReplacementWithoutNavBar(BuildContext context, Widget screen) async {
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<DataProvider>(context).userData;
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userData!.name!),
            accountEmail: Text(userData!.email!),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userData!.profilePic!),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text(
                    'Find Tailors',
                  ),
                  onTap: () {
                    widget.controller!.jumpToTab(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline),
                  title: const Text(
                    'Messages',
                  ),
                  onTap: () {
                    widget.controller!.jumpToTab(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: const Text(
                    'Orders',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text(
                    'Notifications',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text(
                    'Account Setting',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.controller!.jumpToTab(3);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text(
                    'Sign Out',
                  ),
                  onTap: () async {
                    await GoogleSignIn().signOut();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    await pushReplacementWithoutNavBar(
                        context, const LoginPage());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
