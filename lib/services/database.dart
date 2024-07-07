import 'dart:async';
import 'dart:io';
import 'package:hair_main_street_admin/models/orderModel.dart';
import 'package:hair_main_street_admin/models/userModel.dart';
import 'package:hair_main_street_admin/models/vendorsModel.dart';
import 'package:hair_main_street_admin/models/withdrawal_requests.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street_admin/models/productModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class DataBaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String? uid;
  DataBaseService({this.uid});

  User? currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection("userProfile");

  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  CollectionReference shopsCollection =
      FirebaseFirestore.instance.collection('vendors');
  CollectionReference withdrawalRequests =
      FirebaseFirestore.instance.collection('withdrawal requests');

  //verify role
  Future<Map<String, dynamic>?> verifyRole() async {
    try {
      DocumentSnapshot documentSnapshot =
          await userProfileCollection.doc(currentUser!.uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? user =
            documentSnapshot.data() as Map<String, dynamic>;
        //print(user);
        if (user["isVendor"] == true) {
          return {"Vendor": currentUser!.uid};
        } else if (user["isBuyer"] == true) {
          return {"Buyer": currentUser!.uid};
        } else {
          throw Exception();
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //create user profile
  Future createUserProfile({
    required String email,
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      // Create a cart subcollection
      await userProfileCollection
          .doc(uid)
          .collection('cart')
          .doc(uid)
          .set({'Products': []});

      // Make the user profile
      return await userProfileCollection.doc(uid).set({
        'fullname': name,
        'phonenumber': phone,
        'address': address,
        'isVendor': false,
        'isBuyer': false,
        'isAdmin': true,
      });
    } catch (e) {
      return e;
    }
  }

  //fetch cart products
  Stream<List<dynamic>> fetchCartItems() async* {
    try {
      var role = await verifyRole();
      //print(role);
      if (role!.keys.contains("Buyer")) {
        var result = userProfileCollection
            .doc(role["Buyer"])
            .collection("cart")
            .doc(role["Buyer"])
            .snapshots();
        var test = result;
        yield await test.map((event) {
          var data = event.data() as Map<String, dynamic>;
          //print(data);
          return data["Products"];
        }).toList();
      }
    } catch (e) {
      print(e);
    }

    // Close the Stream.
  }

  //add to cart function
  Future addToCart(Product product) async {
    try {
      var element = FieldValue.arrayUnion([product]);
      var role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        await userProfileCollection
            .doc(role["Buyer"])
            .collection('cart')
            .doc(role["Buyer"])
            .update({"Products": element});
        return "Success";
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print(e);
    }
  }

  //create order and update orders

  //image upload for products
  Future<List<dynamic>?> uploadProductImage() async {
    try {
      //actual image
      List<dynamic> productImageList = [];
      dynamic productImage;
      var appDirectoryPath = await getApplicationDocumentsDirectory();
      //pickFile
      final result = await FilePicker.platform.pickFiles(
        //type: FileType.any,
        allowMultiple: true,
        //allowedExtensions: ["png", "jpg", "jpeg"],
      );
      if (result != null) {
        print("result ${result.paths}");
        for (var image in result.files) {
          var targetPath =
              "${appDirectoryPath.path}/compressed_image[${result.files.indexOf(image)}].jpg";
          print("targetPath: $targetPath");
          print("image ${image.path}");
          //compress image
          final compressedImage = await FlutterImageCompress.compressAndGetFile(
            image.path!,
            targetPath,
            quality: 85,
            format: CompressFormat.jpeg,
          );

          //convert to file
          final finalImage = File(compressedImage!.path);
          //firebase Storage reference
          final storageReference = FirebaseStorage.instance.ref("productImage");
          //product images reference
          final productImageReference = storageReference
              .child("compress_image[${result.files.indexOf(image)}]");
          productImage = await productImageReference.putFile(finalImage);
          productImageList.add(productImage);
        }
        return productImageList;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //create product
  Future addProduct({Product? product}) async {
    try {
      //ensure only user with appropriate role can add product
      //get the current user role
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        return await productsCollection.doc().set({
          "name": product!.name,
          "price": product.price,
          "image": product.image,
          "hasOption": product.hasOption,
          "allowInstallment": product.allowInstallment,
          "quantity": product.quantity,
          "description": product.description,
          "vendorID": role["Vendor"],
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        });
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print("catch error $e");
    }
  }

  //update product
  Future updateProduct({String? fieldName, dynamic value, id}) async {
    try {
      //ensure only user with appropriate role can add product
      //get the current user role
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        return await productsCollection.doc(id).update({"$fieldName": value});
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print(e);
    }
  }

  //convert to product
  List<Product?> convertToProduct(QuerySnapshot<Object?> products) {
    if (products.docs.isEmpty) {}
    return products.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Product.fromdata(data);
    }).toList();
  }

  List<MyUser?> convertToUser(QuerySnapshot<Object?> users) {
    if (users.docs.isEmpty) {}
    return users.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      print("Raw data from Firestore: $data");

      try {
        MyUser user = MyUser.fromdata(data);

        return user;
      } catch (e) {
        print("Error converting user: $e");
        return null;
      }
    }).toList();
  }

  List<Orders?> convertToOrder(QuerySnapshot<Object?> orders) {
    print('convert');
    return orders.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Orders.fromdata(data);
    }).toList();
  }

  //fetch products
  Stream<List<Product?>> fetchProducts() {
    var stuff = productsCollection.snapshots();
    //print(stuff);
    return stuff.map(
      (event) => convertToProduct(event),
    );
  }

  //fetch users
  Stream<List<MyUser?>> fetchUsers() {
    var stuff = userProfileCollection.snapshots();
    //print(stuff);
    return stuff.map(
      (event) => convertToUser(event),
    );
  }

  //fetch single product
  Future fetchSingleProduct(dynamic id) async {
    DocumentSnapshot snapshot = await productsCollection.doc(id).get();
    if (snapshot.exists) {
      var product = snapshot.data() as Product;
      print(product);
      product.vendorId = id;
      print(product);
      return product;
    }
  }

  Stream<List<Orders>> getOrders() {
    try {
      return ordersCollection.snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => Orders.fromdata(doc.data() as Map<String, dynamic>))
            .toList();
      }).asBroadcastStream();
    } catch (e) {
      print("Error fetching orders: $e");
      return Stream.value([]);
    }
  }

  // Add the following method to your existing DatabaseService class
  Stream<List<Vendors>> getShops() {
    try {
      return shopsCollection.snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => Vendors.fromData(doc.data() as Map<String, dynamic>))
            .toList();
      }).asBroadcastStream();
    } catch (e) {
      print("Error fetching orders: $e");
      return Stream.value([]);
    }
  }

  List<Vendors?> convertToVendors(QuerySnapshot<Object?> shops) {
    if (shops.docs.isEmpty) {}
    return shops.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Vendors.fromData(data);
    }).toList();
  }

  Future<void> updateShop(Vendors shop) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('vendors').doc(shop.userID);
    final DocumentSnapshot docSnapshot = await documentReference.get();
    if (docSnapshot.exists) {
      await documentReference.update(shop.toData());
    } else {
      await documentReference.set(shop.toData());
    }
  }

  //payment stuff

  // Stream to get withdrawal requests
  Stream<List<Map<String, dynamic>>> getWithdrawalRequests() {
    return _db
        .collection('wallet')
        .doc(
            'kzkNrjdKyUP2U53G1FVNugrHLJL2') // Assuming this is the global document
        .collection('withdrawal requests')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the document ID
          'withdrawal amount': doc['withdrawal amount'],
          'userID': doc['userID'],
          'status': doc['status'],
        };
      }).toList();
    });
  }

  // Method to approve a withdrawal request
  Future<void> approveWithdrawalRequest(String userId, String requestId) async {
    final withdrawalRequestDoc = _db
        .collection('wallet')
        .doc(userId)
        .collection('withdrawal requests')
        .doc(requestId);

    final docSnapshot = await withdrawalRequestDoc.get();
    final docData = docSnapshot.data();

    if (docData == null) {
      throw Exception('Withdrawal request does not exist.');
    }

    if (docData['status'] == 'approved') {
      throw Exception('Request is already approved.');
    }

    await withdrawalRequestDoc.update({'status': 'approved'});

    final withdrawnAmount =
        (docData['withdrawal amount'] as num?)?.toDouble() ?? 0.0;

    if (userId.isNotEmpty) {
      await deductFromWallet(userId, withdrawnAmount);
    } else {
      throw Exception('User ID is empty or null');
    }
  }

  // Method to deduct the withdrawn amount from the user's wallet balance
  Future<void> deductFromWallet(String userId, double amount) async {
    try {
      // Correcting the collection path to match Firestore structure
      final walletDoc = _db.collection('wallet').doc(userId);
      final docSnapshot = await walletDoc.get();

      if (!docSnapshot.exists) {
        throw Exception('Wallet document for user $userId does not exist.');
      }

      final docData = docSnapshot.data();
      print('Document data for user $userId: $docData');

      if (docData != null) {
        final currentBalance = (docData['balance'] as num?)?.toDouble() ?? 0.0;
        print('Current balance: $currentBalance, Amount to deduct: $amount');

        if (currentBalance < amount) {
          throw Exception('Insufficient balance');
        }

        await walletDoc.update({'balance': currentBalance - amount});
        print(
            'Deducted $amount from user $userId. New balance: ${currentBalance - amount}');
      } else {
        throw Exception('Document data is null');
      }
    } catch (e) {
      print('Error deducting from wallet: $e');
      throw e; // Re-throw the error to handle it in the calling function
    }
  }

  // Update approval requests
  Future<void> updateWithdrawalRequest(
      WithdrawalRequest withdrawalRequest) async {
    try {
      final documentReference = _db
          .collection('wallet')
          .doc('kzkNrjdKyUP2U53G1FVNugrHLJL2')
          .collection('withdrawal requests')
          .doc(withdrawalRequest.id);

      // Update only the 'status' field
      await documentReference.update({'status': 'approved'});
    } catch (e) {
      print("Error updating withdrawal request: $e");
      throw e;
    }
  }

// requestID

  //referral

  //chats
}
