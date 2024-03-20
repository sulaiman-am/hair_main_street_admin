import 'dart:convert';

MyUser userFromdata(String str) => MyUser.fromdata(json.decode(str));

class MyUser {
  String? uid;
  String? fullname;
  String? email;
  String? phoneNumber;
  String? address;
  bool? isBuyer;
  bool? isVendor;
  bool? isAdmin;

  MyUser(
      {this.uid,
      this.address,
      this.email,
      this.phoneNumber,
      this.fullname,
      this.isAdmin,
      this.isBuyer,
      this.isVendor});

  factory MyUser.fromdata(Map<String, dynamic> data) => MyUser(
      uid: data["uid"],
      fullname: data["fullname"],
      email: data["email"],
      phoneNumber: data["phoneNumber"],
      address: data["address"],
      isAdmin: data['isAdmin'],
      isBuyer: data['isBuyer'],
      isVendor: data['isVendor']);

  String getUserType() {
    if (isBuyer == true) {
      return 'buyer';
    } else if (isVendor == true) {
      return 'vendor';
    } else if (isAdmin == true) {
      return 'admin';
    } else {
      return 'unknown';
    }
  }
}
