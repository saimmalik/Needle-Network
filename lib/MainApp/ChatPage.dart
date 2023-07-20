// ignore_for_file: file_names, must_be_immutable, unused_local_variable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/ModalClasses/MessageData.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:provider/provider.dart';

import '../ModalClasses/UserData.dart';

class ChatPage extends StatefulWidget {
  TailorsData tailorsData;
  ChatPage({super.key, required this.tailorsData});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  UserData? userData;

  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).loadUserData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<DataProvider>(context).userData;
    final messageCont = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20),
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 40),
                  child: Text(
                    widget.tailorsData.shopName.toString(),
                    style: const TextStyle(
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
              stream: Provider.of<DataProvider>(context)
                  .getMessages(widget.tailorsData.docId!),
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
                } else {
                  List<MessageData> messages = [];
                  for (var element in snapshot.data!) {
                    if (element.tailorId == widget.tailorsData.docId) {
                      messages.add(element);
                    }
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      messages.sort(
                        (a, b) {
                          return a.timeStamp!.compareTo(b.timeStamp!);
                        },
                      );
                      DateTime dateTime =
                          DateTime.parse(snapshot.data![index].timeStamp!);
                      String formattedTime = DateFormat.jm().format(dateTime);
                      return Align(
                        alignment: messages[index].receiverId ==
                                widget.tailorsData.docId!
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 250,
                                ),
                                decoration: BoxDecoration(
                                  color: messages[index].receiverId ==
                                          widget.tailorsData.docId
                                      ? Colors.blue
                                      : Colors.grey,
                                  borderRadius: messages[index].receiverId ==
                                          widget.tailorsData.docId
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    messages[index].message.toString(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: messageCont,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Message',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FloatingActionButton(
                  onPressed: () {
                    if (messageCont.text.isNotEmpty) {
                      MessageData messageData = MessageData(
                        customerPic: userData!.profilePic,
                        tailorPic: widget.tailorsData.shopImage,
                        message: messageCont.text,
                        customerName: userData!.name,
                        senderId: FirebaseAuth.instance.currentUser!.uid,
                        tailorName: widget.tailorsData.shopName,
                        receiverId: widget.tailorsData.docId,
                        tailorId: widget.tailorsData.docId,
                        customerId: FirebaseAuth.instance.currentUser!.uid,
                        timeStamp: DateTime.now().toString(),
                      );
                      Provider.of<DataProvider>(context, listen: false)
                          .sendMessage(messageData);
                      messageCont.text = '';
                      setState(() {});
                    }
                  },
                  child: const Icon(Icons.send),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
