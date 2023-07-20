// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print, await_only_futures, avoid_function_literals_in_foreach_calls
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'ModalClasses/Notifications.dart';
import 'ModalClasses/Orders.dart';
import 'ModalClasses/MessageData.dart';
import 'ModalClasses/Products.dart';
import 'ModalClasses/TailorsData.dart';
import 'ModalClasses/UserData.dart';

class DataProvider extends ChangeNotifier {
  Future<bool> createUser(
      UserData userData, File image, String? password) async {
    try {
      String? url;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userData.email!,
        password: password!,
      )
          .then((value) async {
        final task = await FirebaseStorage.instance
            .ref('Customers')
            .child(DateTime.now().toIso8601String())
            .putFile(image);
        url = await task.ref.getDownloadURL();
        userData = userData.copyWith(profilePic: url);
        await FirebaseFirestore.instance
            .collection('Customers')
            .doc(value.user!.uid)
            .set(userData.toMap());
      });
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed to Create User : ' + e.toString());
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed to login : ' + e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed : ' + e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    UserData userData;
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(
        credential,
      )
          .then((value) async {
        final String? name =
            await FirebaseAuth.instance.currentUser!.displayName;
        final String? phoneNumber =
            await FirebaseAuth.instance.currentUser!.phoneNumber;
        final image = await FirebaseAuth.instance.currentUser!.photoURL;
        final email = FirebaseAuth.instance.currentUser!.email;
        userData = UserData(
            name: name,
            phoneNumber: phoneNumber,
            profilePic: image,
            email: email);
        await FirebaseFirestore.instance
            .collection('Customers')
            .doc(value.user!.uid)
            .set(userData.toMap());
      });

      return true;
    } catch (e) {
      print('Failed to sign in with Google: $e');
      return false;
    }
  }

  UserData? userData;

  loadUserData() {
    try {
      User? user;
      user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('Customers')
          .doc(user!.uid)
          .get()
          .then((value) {
        userData = UserData.fromMap(value);
        notifyListeners();
        print('Success');
      });
    } catch (e) {
      print('Failed' + e.toString());
    }
  }

  Future<bool> updateUserData(UserData userData, File? image) async {
    try {
      String? url;
      User? user;
      user = FirebaseAuth.instance.currentUser;
      if (image != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('Customers')
            .doc(user!.uid)
            .get();
        if (docSnapshot.exists) {
          final prevImageUrl = docSnapshot.get('Profile Picture');

          if (prevImageUrl != null) {
            final ref = FirebaseStorage.instance.refFromURL(prevImageUrl);
            await ref.delete();
          }
        }
        final task = await FirebaseStorage.instance
            .ref('Customers')
            .child(DateTime.now().toIso8601String())
            .putFile(image);
        url = await task.ref.getDownloadURL();
        userData = userData.copyWith(profilePic: url);
      }
      if (image == null) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('Customers')
            .doc(user!.uid)
            .get();
        if (docSnapshot.exists) {
          String url = docSnapshot.get('Profile Picture');
          userData = userData.copyWith(profilePic: url);
        }
      }
      await FirebaseFirestore.instance
          .collection('Customers')
          .doc(user!.uid)
          .update(userData.toMap());
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed' + e.toString());
      return false;
    }
  }

  Future<bool> saveLocation(String address, double lat, double lon) async {
    try {
      User? user;
      user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('Customers')
          .doc(user!.uid)
          .update({
        'Address': address,
        'Latitude': lat,
        'Longitude': lon,
      });
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed' + e.toString());
      return false;
    }
  }

  List<TailorsData> tailorsData = [];
  loadTailors() async {
    try {
      await FirebaseFirestore.instance
          .collection('Business Info')
          .get()
          .then((value) async {
        tailorsData = List.generate(
          value.size,
          (index) => TailorsData.fromMap(
            value.docs[index].data(),
          ),
        );
      });
      notifyListeners();
      print('Success');
    } catch (e) {
      print('Failed' + e.toString());
    }
  }

  TailorsData? tailor;
  loadTailorByUid(String? tailorId) async {
    await FirebaseFirestore.instance
        .collection('Business Info')
        .doc(tailorId)
        .get()
        .then((value) {
      tailor = TailorsData.fromMap(value.data()!);
    });
  }

  List<Products> products = [];
  Future<bool> loadProducts(String docId) async {
    try {
      products = List.empty();
      await FirebaseFirestore.instance
          .collection('AllItems')
          .where('User ID', isEqualTo: docId)
          .get()
          .then(
            (value) => {
              products = List.generate(
                value.size,
                (index) => Products.fromMap(
                  value.docs[index],
                ),
              ),
            },
          );
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed : ' + e.toString());
      return false;
    }
  }

  sendMessage(MessageData messageData) {
    try {
      FirebaseDatabase.instance
          .ref('Messages')
          .child(DateTime.now().microsecondsSinceEpoch.toString())
          .set(messageData.toMap())
          .then((value) {})
          .onError((error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
      });
      notifyListeners();
      print('Success');
    } catch (e) {
      print('Failed : ' + e.toString());
    }
  }

  Stream<List<MessageData>> getMessages(String id) {
    final ref = FirebaseDatabase.instance.ref('Messages');
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return ref.onValue.map((event) {
      List<MessageData> messages = [];
      var snapShot = event.snapshot;
      if (snapShot.value != null) {
        messages.clear();
        Map<dynamic, dynamic> values = snapShot.value as dynamic;
        values.forEach((key, value) {
          if (value['SenderId'] == userId || value['ReceiverId'] == userId) {
            messages.add(MessageData.fromMap(value));
          }
        });
      }
      return messages;
    });
  }

  Stream<List<MessageData>> getLastMessageOfEachUser() {
    final ref = FirebaseDatabase.instance.ref('Messages');
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return ref.onValue.map((event) {
      List<MessageData> messages = [];
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as dynamic;
        List<MessageData> allMessages = [];

        values.forEach((key, value) {
          if (value['CustomerId'] == userId) {
            Map<dynamic, dynamic> message = value as dynamic;
            allMessages.add(MessageData.fromMap(message));
          }
        });

        Map<String, List<MessageData>> messagesByReceiverId = {};

        allMessages.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));

        allMessages.forEach((message) {
          String receiverId = message.tailorId!;
          if (!messagesByReceiverId.containsKey(receiverId)) {
            messagesByReceiverId[receiverId] = [message];
          } else {
            messagesByReceiverId[receiverId]?.add(message);
          }
        });

        messagesByReceiverId.forEach((receiverId, messagesList) {
          messages.add(messagesList.first);
        });
      }
      return messages;
    });
  }

  Future<bool> sendOrderRequest(Orders order, List<File>? images) async {
    try {
      List<String> imageUrls = [];
      if (images != null) {
        for (int i = 0; i < images.length; i++) {
          String imageName = '${DateTime.now().millisecondsSinceEpoch}-$i';
          final Reference ref =
              FirebaseStorage.instance.ref('Orders').child(imageName);
          final UploadTask uploadTask = ref.putFile(images[i]);
          final TaskSnapshot downloadUrl = await uploadTask.whenComplete(() {});
          final String url = await downloadUrl.ref.getDownloadURL();
          imageUrls.add(url);
          order = order.copyWith(
            images: imageUrls,
          );
        }
      }

      await FirebaseFirestore.instance
          .collection('Orders')
          .doc()
          .set(order.toMap());
      notifyListeners();
      Fluttertoast.showToast(
        msg: 'Request sent',
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed' + e.toString(),
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return false;
    }
  }

  List<Orders> orders = [];

  Future<bool> getOrders() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('Orders')
          .where('CustomerId', isEqualTo: uid)
          .get()
          .then((value) {
        orders = List.generate(
            value.size, (index) => Orders.fromMap(value.docs[index]));
      });
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed: ' + e.toString());
      Fluttertoast.showToast(
        msg: 'Failed' + e.toString(),
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> changeOrderStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('Orders').doc(docId).update({
        'Status': newStatus,
      });
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed: $e');
      return false;
    }
  }

  String? status;
  Future<bool> loadStatus(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(docId)
          .get()
          .then((value) {
        status = value.get('Status');
      });
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed: $e');
      return false;
    }
  }

  Future<bool> sendNotification(Notifications notification) async {
    try {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc()
          .set(notification.toMap());
      notifyListeners();
      print('Success');
      return true;
    } catch (e) {
      print('Failed: $e');
      return false;
    }
  }

  List<Notifications> notifications = [];

  getNotification() async {
    try {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .where('CustomerId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        notifications = List.generate(
            value.size, (index) => Notifications.fromMap(value.docs[index]));
      });
      notifyListeners();
      print('Success');
    } catch (e) {
      print('Failed: $e');
    }
  }

  addRating(String productId, int newRating) async {
    try {
      DocumentReference productRef =
          FirebaseFirestore.instance.collection('AllItems').doc(productId);
      DocumentSnapshot productSnapshot = await productRef.get();
      List<int> existingRatings =
          List<int>.from(productSnapshot['Rating'] ?? []);
      existingRatings.add(newRating);
      await productRef.update({'Rating': existingRatings});
      notifyListeners();
      print('Success');
    } catch (e) {
      print('Failed: $e');
    }
  }
}
