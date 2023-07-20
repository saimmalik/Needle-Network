// ignore_for_file: file_names, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  List<String>? images = [];
  String? address;
  String? itemName;
  String? category;
  String? requirements;
  String? customerName;
  String? customerId;
  String? sellerId;
  String? productId;
  String? timeStamp;
  String? status;
  int? price;
  String? quantity;
  String? orderType;
  String? docId;
  Orders({
    this.images,
    this.address,
    this.itemName,
    this.category,
    this.requirements,
    this.customerName,
    this.customerId,
    this.sellerId,
    this.productId,
    this.timeStamp,
    this.status,
    this.price,
    this.quantity,
    this.orderType,
    this.docId,
  });
  Orders copyWith({
    List<String>? images = const [],
    String? address,
    String? itemName,
    String? category,
    String? requirements,
    String? customerName,
    String? customerId,
    String? productId,
    String? sellerId,
    String? timeStamp,
    String? status,
    int? price,
    String? quantity,
    String? orderType,
  }) {
    return Orders(
      images: images ?? this.images,
      address: address ?? this.address,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      requirements: requirements ?? this.requirements,
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      sellerId: sellerId ?? this.sellerId,
      productId: productId ?? this.productId,
      timeStamp: timeStamp ?? this.timeStamp,
      status: status ?? this.status,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      orderType: orderType ?? this.orderType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Images': images,
      'Address': address,
      'Item Name': itemName,
      'Category': category,
      'Requirements': requirements,
      'Customer Name': customerName,
      'CustomerId': customerId,
      'SellerId': sellerId,
      'ProductId': productId,
      'TimeStamp': timeStamp,
      'Status': status,
      'Price': price,
      'Quantity': quantity,
      'Order Type': orderType,
    };
  }

  factory Orders.fromMap(DocumentSnapshot<Map<String, dynamic>> snap) {
    Map<String, dynamic> map = snap.data()!;
    List<dynamic> images = map['Images'] ?? [];
    List<String>? stringImages =
        images.map((image) => image.toString()).toList();
    return Orders(
      images: stringImages,
      address: map['Address'],
      category: map['Category'],
      itemName: map['Item Name'],
      requirements: map['Requirements'],
      customerName: map['Customer Name'],
      customerId: map['CustomerId'],
      sellerId: map['SellerId'],
      productId: map['ProductId'],
      timeStamp: map['TimeStamp'],
      status: map['Status'],
      price: map['Price'],
      quantity: map['Quantity'],
      orderType: map['Order Type'],
      docId: snap.id,
    );
  }
}
