// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/Login&Signup/ChangePassword.dart';
import 'package:needle_network_main/Login&Signup/SignupPage.dart';
import 'package:needle_network_main/MainApp/PersistentBottomBar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final fkey = GlobalKey<FormState>();
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  bool gloading = false;
  bool loading = false;
  bool showPassword = true;
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
      backgroundColor: Colors.white,
      body: Form(
        key: fkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHight / 2.5,
                width: 300,
                child: Image.asset('assets/Login.jpg'),
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
                        bool loggedIn = await Provider.of<DataProvider>(context,
                                listen: false)
                            .login(
                          emailCont.text,
                          passwordCont.text,
                        );
                        if (loggedIn) {
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
                        ? const Text('Login')
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
              SizedBox(
                height: screenHight / 40,
              ),
              Row(
                children: const [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHight / 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 55,
                  width: screenWidth - 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color.fromARGB(255, 209, 214, 213);
                          } else if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }
                          return const Color.fromARGB(255, 209, 214, 213);
                        },
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        gloading = true;
                      });
                      bool loggedin = await Provider.of<DataProvider>(context,
                              listen: false)
                          .signInWithGoogle();
                      if (loggedin) {
                        setState(() {
                          gloading = false;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersistentBottomBar(),
                          ),
                        );
                      } else {
                        if (loggedin) {
                          setState(() {
                            gloading = false;
                          });
                          Fluttertoast.showToast(
                            msg: 'An error occured',
                            backgroundColor: Colors.grey,
                            textColor: Colors.black,
                          );
                        }
                      }
                    },
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Logo(Logos.google),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: gloading == false
                            ? const Text(
                                'Continue with Google',
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New to Needle Network? ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
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
