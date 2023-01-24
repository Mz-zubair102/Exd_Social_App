import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/Image_picker_profile_screen.dart';
import '../Screens/home_screen.dart';
import '../Screens/login_screen.dart';
import '../screens/Test Screens/firebase_screen.dart';
import '../screens/profile_screen.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class LoginScreenContrroler extends GetxController {
  static LoginScreenContrroler instance = Get.find();
  // TextEditingController for Email and Password

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController emailsignupController = TextEditingController();
  TextEditingController passworsignupdController = TextEditingController();

  // Hint Text and Label Text of Email TextFormField and Password TextFormField
  String textUser = "Enter Your Name";
  String textEmail = "Enter Your Email ";
  String textPass = "Enter Your Password ";

  String email="";
// Validator of Email
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter email in TextFormField";
    }
    if (!GetUtils.isEmail(value)) {
      return "Enter proper email address";
    }
    return null;
  }
  String? passwordValidator(String? value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }
  String? userValidator(String? value) {
    if (!value!.contains(RegExp(r'^[a-zA-Z0-9 ]+$'))) {
      return 'Enter Some Alphabets ';
    }
  }
    FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference userRefrence = FirebaseFirestore.instance.collection("users");
  static Future<bool> signUpUser({
    required String email,
    required String password,
    required String fullname,}) async {
    bool status = false;
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? currentUser = credential.user;
      if (currentUser != null) {
        Map<String, dynamic> userProfileData = {
          "name": fullname,
          "email": email,
          "password": password,
          "uid": currentUser.uid
        };
        await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
              firstName: fullname,
              id: credential.user!.uid,
              // imageUrl: 'https://i.pravatar.cc/300?u=$email',
              // lastName: _lastName,
              metadata: userProfileData
            ));
        // DocumentReference currentUserRefrence = userRefrence.doc(currentUser.uid);
        // Map<String, dynamic> userProfilesData = {
        //   "name": fullname,
        //   "email": email,
        //   "password": password,
        //   "uid": currentUser.uid
        // };
        // await currentUserRefrence.set(userProfilesData);
      }
      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return status;
  }

  void login({required String emailtext,required String passwordtext}){
    auth.signInWithEmailAndPassword(email: emailtext, password: passwordtext)
        .then((value) {
      //  utils().toastmessage(value.user!.email.toString());
      Get.defaultDialog(title:"Status",content: Text("Successfull Login") );
      Get.to(()=>HomeScreen());
    }).onError((error, stackTrace) {
      Get.defaultDialog(title:"Status",content: Text(error.toString()) );
    });
  }

}








// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../Screens/image_picker_Profile_Screen.dart';
// class LoginAndSignupScreenController extends GetxController {
//
//   static CollectionReference userRefrence = FirebaseFirestore.instance
//       .collection("user");
//   FirebaseAuth auth = FirebaseAuth.instance;
//   static LoginAndSignupScreenController instance = Get.find();
//
//
//   GlobalKey<FormState> formkey = GlobalKey();
//   GlobalKey<FormState> signupformkey = GlobalKey();
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();
//   TextEditingController emailsignupcontroller = TextEditingController();
//   TextEditingController passwordsignupcontroller = TextEditingController();
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController usernamecontroller = TextEditingController();
//   TextEditingController phonecontroller = TextEditingController();
//   TextEditingController cniccontroller = TextEditingController();
//
//   String hintemailtext = "Enter Your Email";
//   String hintpasswordtext = "Enter Your Password";
//   String labelemailtext = "Email...";
//   String labelpasswordText = "Password....";
//   String labelnameText = "Name....";
//   String labelusernameText = "Username....";
//   String labelphoneText = "Phone Number....";
//   String labelcnicText = "Cnic Number....";
//   File? ImageFile;
//
//   String? validatename(String? input) {
//     if (input == null || input.isEmpty) {
//       return "Name is required";
//     } else if ((!RegExp(r'^[a-z A-Z.\-]+$').hasMatch(input))) {
//       return 'Please Enter only Alphabets ';
//     }
//     return null;
//   }
//
//   String? validateemail(String? input) {
//     if (input == null || input.isEmpty) {
//       return "Email is required";
//     } else
//     if ((!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input))) {
//       return 'Please Enter Correct Email with @';
//     } else if (!GetUtils.isEmail(input)) {
//       return "enter valid email";
//     }
//     return null;
//   }
//
//   String? validateusername(String? input) {
//     if (input == null || input.isEmpty) {
//       return "User Name is required";
//     } else if ((!RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,29}$").hasMatch(input))) {
//       return 'Please Enter valid Username ';
//     }
//     return null;
//   }
//
//   String? validatepassword(String? input) {
//     if (input == null || input.isEmpty) {
//       return "Password is required";
//     } else if ((!RegExp(
//         r'^(?=.*?[A-Z]{1})(?=.*?[a-z])(?=.*?[0-9]{3})(?=.*?[!@#\$&*~]{1}).{8,}$')
//         .hasMatch(input))) {
//       return 'Please Enter valid password';
//     }
//     return null;
//   }
//
//   String? validatephone(String? input) {
//     if (input == null || input.isEmpty) {
//       return "Phone Number is required";
//     } else if ((!RegExp(r"^\+?0[0-9]{10}$").hasMatch(input))) {
//       return 'Please Enter Valid Phone Number';
//     }
//     return null;
//   }
//   void login({required String emailtext, required String passwordtext}) {
//       auth.signInWithEmailAndPassword(email: emailtext, password: passwordtext)
//           .then((value) {
//         Get.to(ImagePickerProfileScreen());
//       }).onError((error, stackTrace) {
//         Get.defaultDialog(title: "status", content: Text(error.toString()));
//       });
//     }
//
//   onloginPressed() {
//     Get.snackbar("Login Status", "Successfully Logged in",
//         backgroundColor: Colors.cyan, colorText: Colors.white);
//     Get.defaultDialog(title: "Status", content: Text("Successfully Logged in"));
//   }
//     Future<bool> signUpUser({
//       required String email,
//       required String password,
//       required String fullname,
//       required String phoneNumber,}) async {
//       bool status = false;
//       try {
//         final credential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         User? currentUser = credential.user;
//         if (currentUser != null) {
//           DocumentReference currentUserRefrence = userRefrence.doc(
//               currentUser.uid);
//           Map<String, dynamic> userProfileData = {
//             "name": fullname,
//             "phone": phoneNumber,
//             "email": email,
//             "password": password,
//             "uid": currentUser.uid
//           };
//           await currentUserRefrence.set(userProfileData);
//         }
//         // try {
//         //   final credential = await FirebaseAuth.instance
//         //       .createUserWithEmailAndPassword(email: email, password: password);
//         //
//         //   User? currentUser = credential.user;
//         //
//         //   if (currentUser != null) {
//         //     Map<String, dynamic> userProfileData = {
//         //       "name": fullname,
//         //       "phone": phoneNumber,
//         //       "email": email,
//         //       "uid": currentUser.uid
//         //     };
//         //
//         //     FirestoreDB.addUserProfile(data: userProfileData,uid: currentUser.uid);
//         //   }
//         status = true;
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'weak-password') {
//           print('The password provided is too weak.');
//         } else if (e.code == 'email-already-in-use') {
//           print('The account already exists for that email.');
//         }
//       } catch (e) {
//         print(e);
//       }
//       return status;
//     }
//   onSignupPressed() {
//     Get.snackbar("SignUp Status", "Successfully Signup",
//         backgroundColor: Colors.pink, colorText: Colors.white);
//     Get.defaultDialog(title: "Status", content: Text("Successfully SignedUP"));
//   }
//   }

