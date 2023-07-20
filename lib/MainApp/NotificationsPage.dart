// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:provider/provider.dart';

import '../ModalClasses/Notifications.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Notifications> notifications = [];
  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifications = Provider.of<DataProvider>(context).notifications;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 40),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 40),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          notifications.isNotEmpty
              ? Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<DataProvider>(context, listen: false)
                          .getNotification();
                      setState(() {});
                    },
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        notifications.sort(
                          (a, b) {
                            return a.timeStamp!.compareTo(b.timeStamp!);
                          },
                        );
                        DateTime dateTime =
                            DateTime.parse(notifications[index].timeStamp!);
                        String formattedTime =
                            DateFormat('E, h:mm a').format(dateTime);
                        return ListTile(
                          title: Text(notifications[index].title!),
                          subtitle: Text(notifications[index].subtitle!),
                          trailing: Text(formattedTime),
                        );
                      },
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text('No new notifications'),
                      ),
                      InkWell(
                        onTap: () async {
                          await Provider.of<DataProvider>(context,
                                  listen: false)
                              .getNotification();
                          setState(() {});
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
