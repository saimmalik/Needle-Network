// ignore_for_file: file_names, must_be_immutable, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/MainApp/ConfirmOrderPage.dart';
import 'package:needle_network_main/ModalClasses/Products.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:needle_network_main/ModalClasses/UserData.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  Products products;
  TailorsData? tailorsData;
  String category;
  ProductDetailPage({
    super.key,
    required this.products,
    this.tailorsData,
    required this.category,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    List<int> rating = widget.products.rating!;
    int sum = rating.reduce((value, element) => value + element);
    double average = sum / rating.length;
    int averageRating = average.round();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
                    'Detail',
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: Container(
                      height: 250,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ImageSlideshow(
                          isLoop: true,
                          autoPlayInterval: 3000,
                          children: widget.products.images!.map(
                            (e) {
                              return Image.network(
                                e,
                                fit: BoxFit.cover,
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          widget.products.title.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, top: 10),
                            child: Text(
                              'RS/ ${widget.products.price!}',
                              style: TextStyle(
                                fontSize: 20,
                                decoration: widget.products.discount != 0
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          widget.products.discount != 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(right: 20, top: 10),
                                  child: Text(
                                    'RS/ ${widget.products.price! - widget.products.discount!}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              Provider.of<DataProvider>(context, listen: false)
                                  .loadUserData();
                              UserData? userData = Provider.of<DataProvider>(
                                context,
                                listen: false,
                              ).userData;
                              if (userData!.address == null) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Please set your address first',
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('ok'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConfirmOrderPage(
                                      products: widget.products,
                                      category: widget.category,
                                      tailorData: widget.tailorsData!,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text('Buy'),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          'Discription',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          widget.products.discription!,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          'Rating',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < averageRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: index < averageRating
                                  ? Colors.yellow
                                  : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
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
