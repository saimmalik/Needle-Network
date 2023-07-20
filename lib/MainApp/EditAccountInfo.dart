// ignore_for_file: file_names, must_be_immutable, unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print, no_leading_underscores_for_local_identifiers
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/ModalClasses/UserData.dart';
import 'package:provider/provider.dart';
import 'ChangeLocation.dart';

class EditAccountInfo extends StatefulWidget {
  const EditAccountInfo({super.key});

  @override
  State<EditAccountInfo> createState() => _EditAccountInfoState();
}

class _EditAccountInfoState extends State<EditAccountInfo> {
  UserData? userData;
  final fKey = GlobalKey<FormState>();
  bool editInfo = false;
  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController locationCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  LatLng? cordinates;
  double? latitude;
  double? longitude;
  String? savedImage;
  bool infoChanged = false;
  bool loading = false;
  File? image;
  bool isValidEmail(String value) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(value);
  }

  Future pickimage(ImageSource source) async {
    try {
      final _image = await ImagePicker().pickImage(source: source);
      if (_image == null) return;
      final imageTemp = File(_image.path);
      setState(() {
        image = imageTemp;
      });
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
    if (!infoChanged) {
      savedImage = userData!.profilePic;
      emailCont.text = userData!.email.toString();
      nameCont.text = userData!.name.toString();
      userData!.address != null
          ? locationCont.text = userData!.address.toString()
          : null;
      userData!.latitude != null ? latitude = userData!.latitude : null;
      userData!.longitude != null ? longitude = userData!.longitude : null;
      phoneCont.text = userData!.phoneNumber.toString();
      infoChanged = true;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!editInfo) {
            editInfo = true;
            setState(() {});
          } else {
            if (fKey.currentState!.validate()) {
              UserData newData = UserData(
                email: userData!.email,
                name: nameCont.text.isNotEmpty ? nameCont.text : userData!.name,
                address: locationCont.text.isNotEmpty
                    ? locationCont.text
                    : userData!.address,
                latitude: latitude ?? userData!.latitude,
                longitude: longitude ?? userData!.longitude,
                phoneNumber: phoneCont.text.isNotEmpty
                    ? phoneCont.text
                    : userData!.phoneNumber,
              );
              bool dataUpdated =
                  await Provider.of<DataProvider>(context, listen: false)
                      .updateUserData(newData, image);
              if (dataUpdated) {
                Fluttertoast.showToast(
                  msg: 'Info changed Successfully',
                  backgroundColor: Colors.blue,
                );
              } else {
                Fluttertoast.showToast(
                  msg: 'An error occurred',
                  backgroundColor: Colors.blue,
                );
              }
              setState(() {});
            }
            editInfo = false;
            setState(() {});
          }
        },
        child: editInfo == false
            ? const Icon(Icons.edit)
            : const Icon(Icons.check),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 40),
                  child: editInfo == true
                      ? const Text(
                          'Edit Account Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 25,
                          ),
                        )
                      : const Text(
                          'Account Info',
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
              child: Form(
                key: fKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: InkWell(
                          onTap: () {
                            editInfo == true
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: const Text(
                                          "Choose",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                pickimage(ImageSource.camera);
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.blue,
                                                size: 50,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                pickimage(ImageSource.gallery);
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Icon(
                                                Icons.image,
                                                color: Colors.blue,
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
                          child: ClipOval(
                            child: image == null
                                ? CachedNetworkImage(
                                    imageUrl: savedImage!,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
                                            CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: TextFormField(
                        controller: emailCont,
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Email',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: TextFormField(
                        controller: nameCont,
                        enabled: editInfo == true ? true : false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Name',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: TextFormField(
                        controller: locationCont,
                        enabled: editInfo == true ? true : false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your location';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Location',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeLocation(),
                            ),
                          );
                          if (result != null) {
                            locationCont.text = result.location;
                            cordinates = result.coordinates;
                            latitude = cordinates!.latitude;
                            longitude = cordinates!.longitude;
                          }
                          setState(() {
                            result != null
                                ? locationCont.text = result.location.toString()
                                : userData!.address;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: TextFormField(
                        controller: phoneCont,
                        enabled: editInfo == true ? true : false,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please your phone number';
                          }
                          if (value.length > 15 && value.length < 8) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Phone Number',
                          fillColor: Colors.grey.shade100,
                          filled: true,
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
