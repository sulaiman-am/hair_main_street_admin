import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hair_main_street_admin/models/userModel.dart';
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
