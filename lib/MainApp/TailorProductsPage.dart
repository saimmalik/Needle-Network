// ignore_for_file: file_names, must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:needle_network_main/MainApp/ProductDetailPage.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import '../ModalClasses/Products.dart';

class TailorProductsPage extends StatefulWidget {
  TailorsData tailorsData;
  List<Products> products;
  String title;
  TailorProductsPage({
    super.key,
    required this.tailorsData,
    required this.products,
    required this.title,
  });

  @override
  State<TailorProductsPage> createState() => _TailorProductsPageState();
}

class _TailorProductsPageState extends State<TailorProductsPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 40,
                ),
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
          widget.products.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text('No items found'),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      itemCount: widget.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        List<int> rating = widget.products[index].rating!;
                        int sum =
                            rating.reduce((value, element) => value + element);
                        double average = sum / rating.length;
                        int averageRating = average.round();

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  products: widget.products[index],
                                  tailorsData: widget.tailorsData,
                                  category: widget.title,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 2,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    widget.products[index].images![0]
                                        .toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.products[index].title
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'RS/${widget.products[index].price}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            decoration: widget.products[index]
                                                        .discount !=
                                                    0
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        if (widget.products[index].discount !=
                                            0)
                                          Text(
                                            'RS/${widget.products[index].price! - widget.products[index].discount!}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text(
                                              'Rating',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                5,
                                                (index) => Icon(
                                                  index < averageRating
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: index < averageRating
                                                      ? Colors.yellow
                                                      : Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
