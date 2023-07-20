// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String? title;
  String? subtitle;
  String? timeStamp;
  String? tailorId;
  String? customerId;
  String? docId;
  Notifications({
    this.title,
    this.subtitle,
    this.timeStamp,
    this.tailorId,
    this.customerId,
    this.docId,
  });
  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'SubTitle': subtitle,
      'TimeStamp': timeStamp,
      'TailorId': tailorId,
      'CustomerId': customerId,
    };
  }

  factory Notifications.fromMap(DocumentSnapshot<Map<String, dynamic>> snap) {
    Map<String, dynamic> map = snap.data()!;
    return Notifications(
      title: map['Title'],
      subtitle: map['SubTitle'],
      timeStamp: map['TimeStamp'],
      tailorId: map['TailorId'],
      customerId: map['CustomerId'],
      docId: snap.id,
    );
  }
}
