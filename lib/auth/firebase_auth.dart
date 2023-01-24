

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/utils.dart';


class Auth {
  static CollectionReference userRefrence = FirebaseFirestore.instance.collection("user");
  static Future<bool> signUpUser({
    required String email,
    required String password,
    required String fullname,
    required String phoneNumber,}) async {
    bool status = false;
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? currentUser = credential.user;
      if (currentUser != null) {
        DocumentReference currentUserRefrence = userRefrence.doc(currentUser.uid);
        Map<String, dynamic> userProfileData = {
          "name": fullname,
          "phone": phoneNumber,
          "email": email,
          "password": password,
          "uid": currentUser.uid
        };
        await currentUserRefrence.set(userProfileData);
      }
      // try {
      //   final credential = await FirebaseAuth.instance
      //       .createUserWithEmailAndPassword(email: email, password: password);
      //
      //   User? currentUser = credential.user;
      //
      //   if (currentUser != null) {
      //     Map<String, dynamic> userProfileData = {
      //       "name": fullname,
      //       "phone": phoneNumber,
      //       "email": email,
      //       "uid": currentUser.uid
      //     };
      //
      //     FirestoreDB.addUserProfile(data: userProfileData,uid: currentUser.uid);
      //   }
      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      utils().toastmessage(e.toString());
      print(e);
    }
    return status;
  }

  static Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    bool status = false;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password);
      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
      else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      utils().toastmessage(e.toString());
      // print(e);
    }
    return status;
  }
}
