import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/authentication/sign_in.dart';
import 'package:hair_main_street_admin/models/userModel.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';
import 'package:hair_main_street_admin/services/database.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  MyUser? convertToMyUserType(User? user) {
    return user != null
        ? MyUser(
            uid: user.uid,
            email: user.email,
            isBuyer: false,
            isAdmin: false,
            isVendor: true,
          )
        : null;
  }

// determine the auth state of the app
  Stream<MyUser?> get authState {
    return auth.authStateChanges().map((user) => convertToMyUserType(user));
    //auth.currentUser!.reload();
  }

// register with email and password
  Future createUserWithEmailandPassword(
    String? email,
    String? password,
    String name,
    String phone,
    String address,
  ) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);

      dynamic user = result.user;
      await DataBaseService(uid: user.uid).createUserProfile(
          email: email, name: name, phone: phone, address: address);
      return convertToMyUserType(user);
    } catch (e) {
      //print(e.toString());
      return e;
    }
  }

  // sign in with email and password
  Future signInWithEmailandPassword(String? email, String? password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      dynamic user = result.user;
      return convertToMyUserType(user);
    } catch (e) {
      //print(e.toString());
      return e;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }
}

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var user = Rx<MyUser?>(null);
  var users = Rx<User?>(null);
  var userName = ''.obs;
  var fullName = ''.obs;

  @override
  void onInit() {
    users.bindStream(_auth.authStateChanges());
    ever(users, _updateFullName);
    super.onInit();
  }

  void _updateFullName(User? user) async {
    if (user != null) {
      // Fetch full name from Firestore
      try {
        var userDoc =
            await _firestore.collection('userProfile').doc(user.uid).get();
        if (userDoc.exists) {
          fullName.value = userDoc.data()?['fullname'] ?? 'Admin';
          print('Fetched full name: ${fullName.value}');
        } else {
          fullName.value = 'Admin';
          print('User document does not exist.');
        }
      } catch (e) {
        fullName.value = 'Admin';
        print('Error fetching user document: $e');
      }
    } else {
      fullName.value = 'Admin';
      print('No user is currently signed in.');
    }
  }
  /*@override
  void onInit() {
    super.onInit();
    user.bindStream(_authService.authState);
    ever(user, handleAuthChanged);
  }*/

  void handleAuthChanged(MyUser? user) {
    if (user == null) {
      isLoggedIn.value = false;
    } else {
      isLoggedIn.value = true;
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      var result =
          await _authService.signInWithEmailandPassword(email, password);
      if (result is MyUser) {
        user.value = result;
        isLoggedIn.value = true;
        Get.offAll(() => DashboardPage());
      } else {
        Get.snackbar('Error', 'Sign-in failed. Please check your credentials.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    user.value = null;
    isLoggedIn.value = false;
    Get.offAll(() => SignInPage());
  }
}
