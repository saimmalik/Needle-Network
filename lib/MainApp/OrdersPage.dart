// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/MainApp/OrderInfo.dart';
import 'package:needle_network_main/ModalClasses/Orders.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Orders>? orders = [];
  List<TailorsData>? tailors = [];
  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).loadTailors();
    Provider.of<DataProvider>(context, listen: false).getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    orders = Provider.of<DataProvider>(context).orders;
    tailors = Provider.of<DataProvider>(context).tailorsData;
    if (orders == null || tailors == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
    return Scaffold(
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
                        'Orders',
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
          orders!.isNotEmpty
              ? Expanded(
                  child: RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<DataProvider>(context, listen: false)
                        .getOrders();
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemCount: orders!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime =
                          DateTime.parse(orders![index].timeStamp!);
                      String formattedTime =
                          DateFormat.MMMMEEEEd().format(dateTime);
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderInfo(
                                orders: orders![index],
                                tailorsData: tailors!,
                              ),
                            ),
                          );
                        },
                        leading: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: orders![index].images![0],
                              progressIndicatorBuilder:
                                  (context, url, progress) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                                ],
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          orders![index].itemName.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: orders![index].status == 'Cancelled'
                            ? const Text('Cancelled')
                            : orders![index].status == 'Delivered'
                                ? const Text('Delivered')
                                : Text('${orders![index].quantity} Pices'),
                        trailing: Text(formattedTime),
                      );
                    },
                  ),
                ))
              : const Expanded(
                  child: Center(
                    child: Text('No orders found'),
                  ),
                ),
        ],
      ),
    );
  }
}
