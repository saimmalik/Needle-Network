// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/MainApp/ChatPage.dart';
import 'package:needle_network_main/ModalClasses/Orders.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../ModalClasses/Notifications.dart';
import '../ModalClasses/TailorsData.dart';

class OrderInfo extends StatefulWidget {
  Orders orders;
  List<TailorsData> tailorsData;
  OrderInfo({super.key, required this.orders, required this.tailorsData});

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  TailorsData? tailorsData;
  String? status;
  int _currentRating = 0;
  @override
  void initState() {
    tailorsData = widget.tailorsData
        .firstWhere((element) => element.docId == widget.orders.sellerId);
    Provider.of<DataProvider>(context, listen: false)
        .loadStatus(widget.orders.docId!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.orders.status == 'Shipped') {
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Is the Order delivered?',
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'Not yet',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Yes',
                    ),
                    onPressed: () async {
                      if (widget.orders.orderType == 'Normal') {
                        await Provider.of<DataProvider>(context, listen: false)
                            .changeOrderStatus(
                                widget.orders.docId!, 'Delivered');
                        Notifications notification = Notifications(
                          title: 'Order Received',
                          subtitle: 'Thank you for using Neddle Network',
                          timeStamp: DateTime.now().toString(),
                          tailorId: widget.orders.sellerId,
                          customerId: widget.orders.customerId,
                        );
                        await Provider.of<DataProvider>(context, listen: false)
                            .sendNotification(notification);
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Rate this Product'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingBar.builder(
                                    initialRating: _currentRating.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _currentRating = rating.toInt();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<DataProvider>(context,
                                            listen: false)
                                        .addRating(widget.orders.productId!,
                                            _currentRating);
                                    Navigator.of(context).pop(_currentRating);
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        await Provider.of<DataProvider>(context, listen: false)
                            .changeOrderStatus(
                                widget.orders.docId!, 'Delivered');
                        Notifications notification = Notifications(
                          title: 'Order Received',
                          subtitle: 'Thank you for using Neddle Network',
                          timeStamp: DateTime.now().toString(),
                          tailorId: widget.orders.sellerId,
                          customerId: widget.orders.customerId,
                        );
                        await Provider.of<DataProvider>(context, listen: false)
                            .sendNotification(notification);
                        Navigator.of(context).pop();
                        await Provider.of<DataProvider>(context, listen: false)
                            .loadStatus(widget.orders.docId!);
                        setState(() {});
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    status = Provider.of<DataProvider>(context).status;
    final screenWidth = MediaQuery.of(context).size.width;
    if (tailorsData == null) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      );
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: ChatPage(tailorsData: tailorsData!),
            withNavBar: false,
          );
        },
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 40),
                      child: InkWell(
                        onTap: () {
                          status = null;
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
                        'Order Info',
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
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      width: screenWidth,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ImageSlideshow(
                        isLoop: widget.orders.images!.length > 1 ? true : false,
                        autoPlayInterval: 3000,
                        children: widget.orders.images!.map((e) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              e,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.orders.itemName.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${widget.orders.quantity} Pices',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        status == null
                            ? const Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            : Text(
                                status!,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: Row(
                      children: const [
                        Text(
                          'Your requirements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, bottom: 10, top: 10),
                    child: SizedBox(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.orders.requirements.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
