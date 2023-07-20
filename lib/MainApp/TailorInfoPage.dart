// ignore_for_file: unused_local_variable, file_names

import 'package:flutter/material.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/MainApp/ChatPage.dart';
import 'package:needle_network_main/MainApp/CustomOrderPage.dart';
import 'package:needle_network_main/MainApp/TailorProductsPage.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../ModalClasses/Products.dart';

class TailorInfoPage extends StatefulWidget {
  final TailorsData tailorsData;

  const TailorInfoPage({Key? key, required this.tailorsData}) : super(key: key);

  @override
  State<TailorInfoPage> createState() => _TailorInfoPageState();
}

class _TailorInfoPageState extends State<TailorInfoPage> {
  List<Products> allProducts = [];
  bool? productsLoaded;
  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false)
        .loadProducts(widget.tailorsData.docId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    allProducts = Provider.of<DataProvider>(context).products;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 40),
                      child: InkWell(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: ChatPage(tailorsData: widget.tailorsData),
                            withNavBar: false,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.message,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
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
                      height: 250,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.tailorsData.shopImage.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      height: 80,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: ClipOval(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ColoredBox(
                                  color: Colors.red,
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20, bottom: 5),
                                  child: Text(
                                    'Location',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: SizedBox(
                                    child: Text(
                                      widget.tailorsData.address.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: Text(
                          'Open hours',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: widget.tailorsData.open24Hours == false
                            ? Text(
                                '${widget.tailorsData.openingTime} to ${widget.tailorsData.closingTime}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                '24 hours open',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          'Services',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      width: screenWidth,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          if (widget.tailorsData.pantCoat == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: SizedBox(
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      List<Products> selectedProduct =
                                          allProducts
                                              .where((element) =>
                                                  element.pantCoat == true)
                                              .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TailorProductsPage(
                                            tailorsData: widget.tailorsData,
                                            products: selectedProduct,
                                            title: 'Pant Coat',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Pant Coat'),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.tailorsData.lahenga == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: SizedBox(
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      List<Products> selectedProduct =
                                          allProducts
                                              .where((element) =>
                                                  element.lahenga == true)
                                              .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TailorProductsPage(
                                            tailorsData: widget.tailorsData,
                                            products: selectedProduct,
                                            title: 'Lahenga',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Lahenga'),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.tailorsData.sherwani == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: SizedBox(
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      List<Products> selectedProduct =
                                          allProducts
                                              .where((element) =>
                                                  element.sherwani == true)
                                              .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TailorProductsPage(
                                            tailorsData: widget.tailorsData,
                                            products: selectedProduct,
                                            title: 'Sherwani',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Sherwani'),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.tailorsData.suits == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: SizedBox(
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      List<Products> selectedProduct =
                                          allProducts
                                              .where((element) =>
                                                  element.suit == true)
                                              .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TailorProductsPage(
                                            tailorsData: widget.tailorsData,
                                            products: selectedProduct,
                                            title: 'Suit',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Suits'),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.tailorsData.uniforms == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: SizedBox(
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      List<Products> selectedProduct =
                                          allProducts
                                              .where((element) =>
                                                  element.uniform == true)
                                              .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TailorProductsPage(
                                            tailorsData: widget.tailorsData,
                                            products: selectedProduct,
                                            title: 'Uniform',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Uniforms'),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.tailorsData.waistCoat == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: SizedBox(
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      List<Products> selectedProduct =
                                          allProducts
                                              .where((element) =>
                                                  element.waistCoat == true)
                                              .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TailorProductsPage(
                                            tailorsData: widget.tailorsData,
                                            products: selectedProduct,
                                            title: 'WaistCoat',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('WaistCoats'),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          'Audience',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: SizedBox(
                      width: screenWidth,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          if (widget.tailorsData.men == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Men',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.tailorsData.women == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Women',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.tailorsData.children == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Children',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.tailorsData.elders == true)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Elders',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 20,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: screenWidth,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomOrderPage(
                                    tailorsData: widget.tailorsData),
                              ),
                            );
                          },
                          child: const Text('Custom order'),
                        ),
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
