// ignore_for_file: file_names, use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/MainApp/ChatPage.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 40),
                  child: Text(
                    'Messages',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  Provider.of<DataProvider>(context).getLastMessageOfEachUser(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    DateTime dateTime =
                        DateTime.parse(snapshot.data![index].timeStamp!);
                    String formattedTime = DateFormat.jm().format(dateTime);
                    return ListTile(
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                snapshot.data![index].tailorPic.toString(),
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                    CircularProgressIndicator(
                              value: progress.progress,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      trailing: Text(
                        formattedTime,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      title: Text(
                        snapshot.data![index].tailorName.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data![index].message.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      onTap: () async {
                        await Provider.of<DataProvider>(context, listen: false)
                            .loadTailorByUid(snapshot.data![index].tailorId);
                        TailorsData? tailorsData =
                            Provider.of<DataProvider>(context, listen: false)
                                .tailor;
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: ChatPage(tailorsData: tailorsData!),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
