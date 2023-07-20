// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  List<String>? images = [];
  String? title;
  int? price;
  int? discount;
  String? discription;
  List<int>? rating;
  String? DocId;
  bool? suit;
  bool? uniform;
  bool? pantCoat;
  bool? waistCoat;
  bool? lahenga;
  bool? sherwani;
  bool? men;
  bool? women;
  bool? children;
  bool? elders;
  String? userId;
  Products({
    this.images,
    this.title,
    this.price,
    this.discount,
    this.discription,
    this.rating,
    this.suit,
    this.uniform,
    this.pantCoat,
    this.waistCoat,
    this.lahenga,
    this.sherwani,
    this.men,
    this.women,
    this.children,
    this.elders,
    this.DocId,
    this.userId,
  });
  Products copyWith({
    List<String>? images = const [],
    String? title,
    int? price,
    int? discount,
    String? discription,
    List<int>? rating,
    String? DocId,
    bool? suit,
    bool? uniform,
    bool? pantCoat,
    bool? waistCoat,
    bool? lahenga,
    bool? sherwani,
    bool? men,
    bool? women,
    bool? children,
    bool? elders,
    String? userId,
  }) {
    return Products(
      images: images ?? this.images,
      title: title ?? this.title,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      discription: discription ?? this.discription,
      rating: rating ?? this.rating,
      DocId: DocId ?? this.DocId,
      suit: suit ?? this.suit,
      uniform: uniform ?? this.uniform,
      pantCoat: pantCoat ?? this.pantCoat,
      waistCoat: waistCoat ?? this.waistCoat,
      lahenga: lahenga ?? this.lahenga,
      sherwani: sherwani ?? this.sherwani,
      men: men ?? this.men,
      women: women ?? this.women,
      children: children ?? this.children,
      elders: elders ?? this.elders,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Images': images,
      'Title': title,
      'Price': price,
      'Discount': discount,
      'Discription': discription,
      'Rating': rating,
      'Suit': suit,
      'Uniform': uniform,
      'Pant Coat': pantCoat,
      'WaistCoat': waistCoat,
      'Lahega': lahenga,
      'Sherwani': sherwani,
      'Men': men,
      'Women': women,
      'Children': children,
      'Elders': elders,
      'User ID': userId,
    };
  }

  factory Products.fromMap(DocumentSnapshot<Map<String, dynamic>> snap) {
    Map<String, dynamic> map = snap.data()!;
    List<dynamic> images = map['Images'] ?? [];
    List<String>? stringImages =
        images.map((image) => image.toString()).toList();
    List<dynamic> ratings = map['Rating'] ?? [];
    List<int>? listRating = ratings
        .map(
          (e) => int.parse(e.toString()),
        )
        .toList();
    return Products(
      images: stringImages,
      title: map['Title'],
      price: map['Price'],
      discount: map['Discount'],
      discription: map['Discription'],
      rating: listRating,
      suit: map['Suit'],
      uniform: map['Uniform'],
      pantCoat: map['Pant Coat'],
      waistCoat: map['WaistCoat'],
      lahenga: map['Lahega'],
      sherwani: map['Sherwani'],
      men: map['Men'],
      women: map['Women'],
      children: map['Children'],
      elders: map['Elders'],
      userId: map['User ID'],
      DocId: snap.id,
    );
  }
}
