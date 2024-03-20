// models/vendors_model.dart

import 'dart:convert';

Vendors vendorFromData(String str) => Vendors.fromData(json.decode(str));

String vendorToData(Vendors data) => json.encode(data.toData());

class Vendors {
  String? docID;
  String? userID;
  String? shopName;
  Map? accountInfo;
  Map? contactInfo;
  bool? firstVerification;
  bool? secondVerification;
  dynamic createdAt;

  Vendors({
    this.accountInfo,
    this.createdAt,
    this.contactInfo,
    this.secondVerification,
    this.firstVerification,
    this.shopName,
    this.docID,
    this.userID,
  });

  factory Vendors.fromData(Map<String, dynamic> data) => Vendors(
        userID: data['userID'],
        secondVerification: data['second verification'],
        firstVerification: data['first verification'],
        shopName: data['shop name'],
        contactInfo: data['contact info'],
        accountInfo: data['account info'],
        docID: data['docID'],
        createdAt: data['created at'],
      );

  Map<String, dynamic> toData({String? docID}) => {
        "account info": accountInfo,
        "docID": docID,
        "userID": userID,
        "contact info": contactInfo,
        "first verification": firstVerification,
        "second verification": secondVerification,
        "shop name": shopName,
        "created at": createdAt,
      };
}
