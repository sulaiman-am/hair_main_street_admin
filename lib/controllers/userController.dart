import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/models/userModel.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';
import 'package:hair_main_street_admin/controllers/authController.dart';
import 'package:hair_main_street_admin/services/database.dart';

class UserController extends GetxController {
  Rx<MyUser?> userState = Rx<MyUser?>(null);
  var isLoading = false.obs;
  var myUser = MyUser(isAdmin: true, isBuyer: false, isVendor: false).obs;
  var isObscure = true.obs;
  RxList<MyUser?> users = RxList<MyUser?>([]);

  get screenHeight => Get.height;

  // @override
  // void onInit() {
  //   // users.bindStream(fetchMyusers());
  //   // print(users.value);
  //   // userState.bindStream(determineAuthState());
  //   // super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  //   users.bindStream(fetchMyusers());
  // }

  toggle() {
    isObscure.value = !isObscure.value;
  }

  isLoadingState() {
    Future.delayed(const Duration(seconds: 3), () {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Timed Out",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[400],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.16,
        ),
      );
    });
  }

  // determine auth user
  Stream<MyUser?> determineAuthState() {
    Stream<MyUser?> stream = AuthService().authState;
    return stream;
  }

  Stream<List<MyUser?>> fetchMyusers() {
    return DataBaseService().fetchUsers();
  }

  // Create user
  createUser(
    String? email,
    String? password,
    String? name,
    String? phone,
    String? address,
  ) async {
    try {
      var response = await AuthService().createUserWithEmailandPassword(
          email, password, name!, phone!, address!);
      if (response is MyUser) {
        myUser.value = response;
        isLoading.value = false;
        Get.snackbar(
          "Success",
          "User Created",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.green[200],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.16,
          ),
        );
        Get.offAll(() => DashboardPage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          response.code.toString().split("_").join(" "),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.red[400],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.16,
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  // Sign in
  dynamic signIn(String? email, String? password) async {
    try {
      var response =
          await AuthService().signInWithEmailandPassword(email, password);
      if (response is MyUser) {
        myUser.value = response;
        isLoading.value = false;
        Get.snackbar(
          "Success",
          "User Signed In",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.green[200],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.16,
          ),
        );
        Get.offAll(() => DashboardPage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          response.code.toString().split("_").join(" "),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.red[700],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.16,
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      print("hello:${e.toString()}");
    }
  }

  // Sign out
  signOut() {
    AuthService().signOut();
    Get.snackbar(
      "Success",
      "User Signed Out",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1, milliseconds: 800),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      backgroundColor: Colors.green[200],
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: screenHeight * 0.16,
      ),
    );
    Get.offAll(() => DashboardPage());
  }
}
