import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street_admin/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailandPassword(
    String? email,
    String? password,
    String? name,
    String? phone,
    String? address,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);

      DataBaseService(uid: result.user!.uid).createUserProfile(
          email: email, name: name!, phone: phone!, address: address!);
      return result.user;
    } catch (e) {
      // Handle errors
      print(e);
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Sign-In Error: $e");
      return null;
    }
  }
}
