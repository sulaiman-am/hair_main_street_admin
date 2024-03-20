import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  String? orderId;
  String? buyerId;
  String? vendorId;
  int? totalPrice;
  String? shippingAddress;
  String? orderStatus;
  Timestamp? createdAt;
  dynamic updatedAt;
  String? paymentMethod;
  String? paymentStatus;

  Orders({
    this.orderId,
    this.buyerId,
    this.vendorId,
    this.totalPrice,
    this.shippingAddress,
    this.orderStatus,
    this.createdAt,
    this.updatedAt,
    this.paymentMethod,
    this.paymentStatus,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orderId: json["orderID"],
        buyerId: json["buyerID"],
        vendorId: json["vendorID"],
        totalPrice: json["totalPrice"],
        shippingAddress: json["shipping address"],
        orderStatus: json["order status"],
        createdAt: json["created at"],
        updatedAt: json["updated at"],
        paymentMethod: json['payment method'],
        paymentStatus: json['payment status'],
      );
  factory Orders.fromdata(Map<String, dynamic> data) => Orders(
        orderId: data["orderID"],
        buyerId: data["buyerID"],
        vendorId: data["vendorID"],
        totalPrice: data["totalPrice"],
        shippingAddress: data["shipping address"],
        orderStatus: data["order status"],
        createdAt: data["created at"],
        updatedAt: data["updated at"],
        paymentMethod: data['payment method'],
        paymentStatus: data['payment status'],
      );
  Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "buyerID": buyerId,
        "vendorID": vendorId,
        "totalPrice": totalPrice,
        "shipping address": shippingAddress,
        "order status": orderStatus,
        "created at": createdAt,
        "updated at": updatedAt,
        "payment method": paymentMethod,
        "payment status": paymentStatus,
      };
}

OrderItem orderItemFromJson(String str) => OrderItem.fromJson(json.decode(str));

String orderItemToJson(OrderItem data) => json.encode(data.toJson());

class OrderItem {
  String? productId;
  String? quantity;
  String? price;

  OrderItem({
    this.productId,
    this.quantity,
    this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json["productID"],
        quantity: json["quantity"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "quantity": quantity,
        "price": price,
      };
}
