// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? profilePic;
  String? email;
  String? name;
  String? phoneNumber;

  String? address;
  double? latitude;
  double? longitude;
  String? docId;
  UserData({
    this.profilePic,
    this.email,
    this.name,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.docId,
  });
  UserData copyWith({
    String? profilePic,
    String? email,
    String? name,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    String? docId,
  }) {
    return UserData(
      profilePic: profilePic ?? this.profilePic,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      docId: docId ?? this.docId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Profile Picture': profilePic,
      'Email': email,
      'Name': name,
      'Phone Number': phoneNumber,
      'Address': address,
      'Latitude': latitude,
      'Longitude': longitude,
    };
  }

  factory UserData.fromMap(DocumentSnapshot<Map<String, dynamic>> snap) {
    Map<String, dynamic> map = snap.data()!;
    return UserData(
      profilePic: map['Profile Picture'],
      email: map['Email'],
      name: map['Name'],
      phoneNumber: map['Phone Number'],
      address: map['Address'],
      latitude: map['Latitude'],
      longitude: map['Longitude'],
      docId: snap.id,
    );
  }
}
