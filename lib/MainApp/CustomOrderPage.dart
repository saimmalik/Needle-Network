// ignore_for_file: file_names, must_be_immutable, unused_local_variable, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/ModalClasses/Orders.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:provider/provider.dart';
import '../ModalClasses/UserData.dart';

class CustomOrderPage extends StatefulWidget {
  TailorsData tailorsData;
  CustomOrderPage({super.key, required this.tailorsData});

  @override
  State<CustomOrderPage> createState() => _CustomOrderPageState();
}

class _CustomOrderPageState extends State<CustomOrderPage> {
  bool loading = false;
  UserData? userData;
  final List<File> _images = [];
  int? selectedImage = 0;
  final fkey = GlobalKey<FormState>();
  final titleCont = TextEditingController();
  final categoryCont = TextEditingController();
  final quantityCont = TextEditingController();
  final requirementsCont = TextEditingController();
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      if (_images.length < 5) {
        setState(() {
          _images.add(imageTemp);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.withOpacity(0.9),
              title: const Text(
                'Max Images Reached',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                  'You have reached the maximum limit of 5 images.',
                  style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromARGB(255, 136, 153, 73);
                        } else if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return const Color.fromARGB(255, 136, 153, 73);
                      },
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } on PlatformException catch (e) {
      print('Can not pick image :' + e.toString());
    }
  }

  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<DataProvider>(context).userData;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 40, bottom: 10),
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
                padding: EdgeInsets.only(left: 20, top: 40, bottom: 10),
                child: Text(
                  'Custom Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: fkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: 10,
                      ),
                      child: InkWell(
                        onTap: () {
                          _images.isEmpty
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: const Text(
                                        "Choose",
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              pickImage(ImageSource.camera);
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              pickImage(ImageSource.gallery);
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: const Icon(
                                              Icons.image,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : null;
                        },
                        child: Container(
                          height: 250,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _images.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _images[selectedImage!],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    _images.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 20,
                              right: 20,
                              bottom: 10,
                            ),
                            child: SizedBox(
                              height: 100,
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _images.length < 5
                                    ? _images.length + 1
                                    : _images.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  if (_images.length < 5 &&
                                      index == _images.length) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: const Text(
                                                "Choose",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      pickImage(
                                                          ImageSource.camera);
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.grey,
                                                      size: 50,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      pickImage(
                                                          ImageSource.gallery);
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.image,
                                                      color: Colors.grey,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add_a_photo,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        selectedImage = index;
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: index == selectedImage
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              _images[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: titleCont,
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
                          hintText: 'Title',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      child: TextFormField(
                        controller: categoryCont,
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
                          hintText: 'Category',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
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
                        top: 10,
                        bottom: 10,
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
                        maxLines: 6,
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
                            onPressed: () async {
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
                                if (_images.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: 'Please add atleast 1 image',
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }
                                if (fkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  Orders customOrder = Orders(
                                    itemName: titleCont.text,
                                    category: categoryCont.text,
                                    requirements: requirementsCont.text,
                                    customerName: userData!.name,
                                    address: userData!.address,
                                    customerId: userData!.docId,
                                    sellerId: widget.tailorsData.docId,
                                    timeStamp: DateTime.now().toString(),
                                    status: 'Pending',
                                    quantity: quantityCont.text,
                                    orderType: 'Custom',
                                  );
                                  bool requestSent = await Provider.of<
                                          DataProvider>(context, listen: false)
                                      .sendOrderRequest(customOrder, _images);
                                  if (requestSent) {
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            },
                            child: loading == false
                                ? const Text('Request')
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
