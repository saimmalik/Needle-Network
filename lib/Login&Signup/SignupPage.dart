// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print, unused_field, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/MainApp/PersistentBottomBar.dart';
import 'package:needle_network_main/ModalClasses/UserData.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final fkey = GlobalKey<FormState>();
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final nameCont = TextEditingController();
  final phoneCont = TextEditingController();
  bool showPassword = true;
  bool loading = false;
  File? _image;
  bool isValidEmail(String value) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(value);
  }

  Future pickimage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        _image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Can not pick image :' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: fkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50, bottom: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      '   SignUp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHight / 45,
              ),
              InkWell(
                onTap: () {
                  showDialog(
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  );
                },
                child: ClipOval(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: _image == null
                        ? const Center(
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 150,
                            ),
                          )
                        : Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, right: 10),
                    child: Icon(
                      Icons.alternate_email,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextFormField(
                        controller: emailCont,
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
                        decoration: const InputDecoration(
                          hintText: 'Email ID',
                          contentPadding: EdgeInsets.only(top: 20),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHight / 40,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, right: 10),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextFormField(
                        controller: nameCont,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
                          contentPadding: EdgeInsets.only(top: 20),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHight / 40,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, right: 10),
                    child: Icon(
                      Icons.phone_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextFormField(
                        controller: phoneCont,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (value.length > 15 && value.length < 8) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          contentPadding: EdgeInsets.only(top: 20),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHight / 40,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, right: 10),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextFormField(
                        controller: passwordCont,
                        obscureText: showPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              showPassword == false
                                  ? showPassword = true
                                  : showPassword = false;
                              setState(() {});
                            },
                            child: showPassword == false
                                ? const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.blue,
                                  )
                                : const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  ),
                          ),
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.only(top: 20),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHight / 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: screenWidth - 60,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_image == null) {
                        Fluttertoast.showToast(
                          msg: 'Please add your picture',
                          backgroundColor: Colors.grey,
                          textColor: Colors.black,
                        );
                        return;
                      }
                      if (fkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        UserData userData = UserData(
                          email: emailCont.text,
                          name: nameCont.text,
                          phoneNumber: phoneCont.text,
                        );
                        bool userCreated = await Provider.of<DataProvider>(
                          context,
                          listen: false,
                        ).createUser(userData, _image!, passwordCont.text);
                        if (userCreated) {
                          setState(() {
                            loading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersistentBottomBar(),
                            ),
                          );
                        } else {
                          setState(() {
                            loading = false;
                          });
                          Fluttertoast.showToast(
                            msg: 'An error occured',
                            backgroundColor: Colors.grey,
                            textColor: Colors.black,
                          );
                        }
                      }
                    },
                    child: loading == false
                        ? const Text(
                            'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
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
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an Account? ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
