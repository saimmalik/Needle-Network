// ignore_for_file: file_names, unused_local_variable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/Login&Signup/LoginPage.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final fkey = GlobalKey<FormState>();
  final emailCont = TextEditingController();
  bool loading = false;
  bool isValidEmail(String value) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final screenHight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Form(
        key: fkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHight / 2.5,
                width: 300,
                child: Image.asset('assets/ForgotPassword.jpg'),
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Forgot',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                child: Text(
                  "Don't worry! It happens.Please enter the email address associated with your account.",
                  overflow: TextOverflow.clip,
                ),
              ),
              SizedBox(
                height: screenHight / 45,
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
                height: screenHight / 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: screenWidth - 60,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (fkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        bool emailSent = await Provider.of<DataProvider>(
                                context,
                                listen: false)
                            .resetPassword(emailCont.text);
                        if (emailSent) {
                          setState(() {
                            loading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: 50,
                                  child: Column(
                                    children: const [
                                      Text(
                                        'We sent an email please change your password from there.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                        (route) => route.isFirst,
                                      );
                                    },
                                    child: const Text('ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'An error occured',
                            backgroundColor: Colors.grey,
                            textColor: Colors.black,
                          );
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    },
                    child: loading == false
                        ? const Text('Submit')
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
            ],
          ),
        ),
      ),
    );
  }
}
