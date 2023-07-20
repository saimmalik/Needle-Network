// ignore_for_file: file_names
import 'dart:core';

class TailorsData {
  String? shopImage;
  String? shopName;
  String? address;
  double? latitude;
  double? longitude;
  Map<String, dynamic>? location;
  String? phoneNumber;
  String? aboutBusiness;
  String? openingTime;
  String? closingTime;
  bool? open24Hours;
  bool? suits;
  bool? uniforms;
  bool? pantCoat;
  bool? waistCoat;
  bool? lahenga;
  bool? sherwani;
  bool? men;
  bool? women;
  bool? children;
  bool? elders;
  String? docId;
  TailorsData({
    this.shopImage,
    this.shopName,
    this.address,
    this.latitude,
    this.longitude,
    this.location,
    this.phoneNumber,
    this.aboutBusiness,
    this.openingTime,
    this.closingTime,
    this.open24Hours,
    this.suits,
    this.uniforms,
    this.pantCoat,
    this.waistCoat,
    this.lahenga,
    this.sherwani,
    this.men,
    this.women,
    this.children,
    this.elders,
    this.docId,
  });
  TailorsData copyWith({
    String? shopImage,
    String? shopName,
    String? address,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? location,
    String? phoneNumber,
    String? aboutBusiness,
    String? openingTime,
    String? closingTime,
    bool? open24Hours,
    bool? suits,
    bool? uniforms,
    bool? pantCoat,
    bool? waistCoat,
    bool? lahenga,
    bool? sherwani,
    bool? men,
    bool? women,
    bool? children,
    bool? elders,
    String? docId,
  }) {
    return TailorsData(
      shopImage: shopImage ?? this.shopImage,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      aboutBusiness: aboutBusiness ?? this.aboutBusiness,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      open24Hours: open24Hours ?? this.open24Hours,
      suits: suits ?? this.suits,
      uniforms: uniforms ?? this.uniforms,
      pantCoat: pantCoat ?? this.pantCoat,
      waistCoat: waistCoat ?? this.waistCoat,
      lahenga: lahenga ?? this.lahenga,
      sherwani: sherwani ?? this.sherwani,
      men: men ?? this.men,
      women: women ?? this.women,
      children: children ?? this.children,
      elders: elders ?? this.elders,
      docId: docId ?? this.docId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Shop Image': shopImage,
      'Shop Name': shopName,
      'Address': address,
      'Latitude': latitude,
      'Longitude': longitude,
      'Location': location,
      'Phone Number': phoneNumber,
      'About Business': aboutBusiness,
      'Opening Time': openingTime,
      'Closing Time': closingTime,
      'Open 24 Hours': open24Hours,
      'Suits': suits,
      'Uniforms': uniforms,
      'Pant Coat': pantCoat,
      'WaistCoat': waistCoat,
      'Lahega': lahenga,
      'Sherwani': sherwani,
      'Men': men,
      'Women': women,
      'Children': children,
      'Elders': elders,
      'DocId': docId,
    };
  }

  factory TailorsData.fromMap(Map<String, dynamic> map) {
    // Map<String, dynamic> map = snap.data()!;
    return TailorsData(
      shopImage: map['Shop Image'],
      shopName: map['Shop Name'],
      address: map['Address'],
      latitude: map['Latitude'],
      longitude: map['Longitude'],
      location: map['Location'],
      phoneNumber: map['Phone Number'],
      aboutBusiness: map['About Business'],
      openingTime: map['Opening Time'],
      closingTime: map['Closing Time'],
      open24Hours: map['Open 24 Hours'],
      suits: map['Suits'],
      uniforms: map['Uniforms'],
      pantCoat: map['Pant Coat'],
      waistCoat: map['WaistCoat'],
      lahenga: map['Lahega'],
      sherwani: map['Sherwani'],
      men: map['Men'],
      women: map['Women'],
      children: map['Children'],
      elders: map['Elders'],
      docId: map['DocId'],
    );
  }
}
