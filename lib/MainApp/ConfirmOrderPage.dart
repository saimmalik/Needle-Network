// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/ModalClasses/Orders.dart';
import 'package:needle_network_main/ModalClasses/Products.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:needle_network_main/ModalClasses/UserData.dart';
import 'package:provider/provider.dart';

class ConfirmOrderPage extends StatefulWidget {
  Products products;
  String category;
  TailorsData tailorData;
  ConfirmOrderPage({
    super.key,
    required this.products,
    required this.category,
    required this.tailorData,
  });

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  UserData? userData;
  final requirementsCont = TextEditingController();
  final quantityCont = TextEditingController();
  final fkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<DataProvider>(context).userData;
    final screenWidth = MediaQuery.of(context).size.width;
    if (userData == null) {
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Form(
        key: fkey,
        child: Column(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 40),
                        child: Text(
                          widget.products.title!,
                          style: const TextStyle(
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
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: TextFormField(
                        controller: quantityCont,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required';
                          }
                          if (int.parse(value) > 5) {
                            return 'Can not order more then 5 pieces';
                          }
                          if (int.parse(value) < 1) {
                            return 'Invalid Value';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Quantity',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: TextFormField(
                        controller: requirementsCont,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Discribe your requirements',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: screenWidth,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (fkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                Orders orders = Orders(
                                  category: widget.category,
                                  customerId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  sellerId: widget.tailorData.docId,
                                  images: widget.products.images,
                                  itemName: widget.products.title,
                                  requirements: requirementsCont.text,
                                  customerName: userData!.name,
                                  address: userData!.address,
                                  productId: widget.products.DocId!,
                                  status: 'Pending',
                                  timeStamp: DateTime.now().toString(),
                                  price: widget.products.price,
                                  quantity: quantityCont.text,
                                  orderType: 'Normal',
                                );
                                bool requested =
                                    await Provider.of<DataProvider>(context,
                                            listen: false)
                                        .sendOrderRequest(orders, null);
                                if (requested) {
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: loading == false
                                ? const Text('Confirm Order')
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '   Please wait...',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
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
    );
  }
}
