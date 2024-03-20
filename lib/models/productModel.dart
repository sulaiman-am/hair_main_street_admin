import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Product productFromdata(String str) => Product.fromdata(json.decode(str));

String productTodata(Product data) => json.encode(data.todata());

class Product {
  dynamic productID;
  bool? allowInstallment;
  Timestamp? createdAt;
  String? description;
  bool? hasOption;
  List<dynamic>? image;
  String? name;
  int? price;
  int? quantity;
  Timestamp? updatedAt;
  dynamic vendorId;

  Product({
    this.productID,
    this.allowInstallment,
    this.createdAt,
    this.description,
    this.hasOption,
    this.image,
    this.name,
    this.price,
    this.quantity,
    this.updatedAt,
    this.vendorId,
  });

  factory Product.fromdata(Map<String, dynamic> data) => Product(
        allowInstallment: data["allowInstallment"],
        createdAt: data["createdAt"],
        description: data["description"],
        hasOption: data["hasOption"],
        image: List<dynamic>.from(data["image"].map((x) => x)),
        name: data["name"],
        price: data["price"],
        quantity: data["quantity"],
        updatedAt: data["updatedAt"],
        vendorId: data["vendorID"],
      );

  Map<String, dynamic> todata() => {
        "allowInstallment": allowInstallment,
        "createdAt": createdAt,
        "description": description,
        "hasOption": hasOption,
        "image": List<dynamic>.from(image!.map((x) => x)),
        "name": name,
        "price": price,
        "quantity": quantity,
        "updatedAt": updatedAt,
        "vendorID": vendorId,
      };
}
