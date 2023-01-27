import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../db/firebasedb.dart';


class ImagePickerController extends GetxController {
  static CollectionReference userReference =
  FirebaseFirestore.instance.collection("users");
  CollectionReference imageReference = FirebaseFirestore.instance.collection("images");

  // User? currentuser = FirebaseAuth.instance.currentUser;
  File? imageFile;
  File? coverFile;
  String coverUpdateKey = "coverUpdatekey";
  String imageUpdateKey = "imageUpdatekey";

  pickCoverImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,);
    // final XFile? video = await _picker.pickVideo(source: ImageSource.camera);


    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        coverFile = File(croppedFile.path);
        print("image.path: ${image.path}");
        update([coverUpdateKey]);
        onInit();
      await  uploadCoverImageToFirebase(context);
      }
    }
  }
  pickUserProfileImage(BuildContext context) async {
    ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,);
    // final XFile? video = await _picker.pickVideo(source: ImageSource.camera);


    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.original,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9
        // ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        imageFile = File(croppedFile.path);
        print("image.path: ${image.path}");
        update([imageUpdateKey]);
        // _picker = File(image.path) as ImagePicker;

      await uploadImageToFirebase(context);
      }
    }
  }
  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }
  Future uploadImageToFirebase(BuildContext context) async {

    try {
      String imagesUrl = "";
      User? user = FirebaseAuth.instance.currentUser;
      String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();
      /// UPLOAD IMAGE TO FIREBASE
      firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
      // get reference to storage root
      firebase_storage.Reference referenceRoot = firebase_storage.FirebaseStorage.instance.ref();
      firebase_storage.Reference referenceDirectory = referenceRoot.child("images");
      // create reference for image to be stores
      firebase_storage.Reference referenceImageToUpload = referenceDirectory.child(UniqueName);
      // store the file
      await referenceImageToUpload.putFile(imageFile!);

      /// Send Image URL to Firestore
      imagesUrl = await referenceImageToUpload.getDownloadURL();
      if(imagesUrl != null){
        String uid="";
        print("uid:$uid");
        if(user!= null){
          uid=user!.uid;
        }
        print("uid:$uid");
        try {
          // Map<String, dynamic> userProfileData = {
          //   "profileImageUrl": imageUrl,
          // };
          await FirebaseChatCore.instance.updateimageUrl(
              types.User(
                  id: uid,
                  imageUrl: imagesUrl,
                  )
          );

          // CollectionReference cpu=FirebaseFirestore.instance.collection("post");
          // await cpu.doc(uid).update({"userImageUrl": imagesUrl});
          DocumentReference currentUserReference = userReference.doc(uid);
          await currentUserReference.update({"profileImageUrl":imagesUrl});
          return true;
        } on Exception catch (e) {
          return false;
        }
      }
    }
    catch(e){
      print(e);
    }

  }
  Future uploadCoverImageToFirebase(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();
    /// UPLOAD IMAGE TO FIREBASE
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref = storage.ref().child("cover").child(UniqueName);
    try {
      // store the file
      await ref.putFile(coverFile!);
      /// Send Image URL to Firestore
      String imagecoverUrl = "";
      imagecoverUrl = await ref.getDownloadURL();
      if(imagecoverUrl != null){
        String uid='';
        //print("uid:$uid");
        if(user!= null){
           uid=user!.uid;
        }
        print("uid:$uid");
        try {
          // Map<String, dynamic> userProfileData = {
          //   "coverImageUrl": imagecoverUrl,
          // };
          // await FirebaseChatCore.instance.updatecoverImageInFirestore(
          //     types.User(
          //         id: uid,
          //         metadata: userProfileData)
          // );
          DocumentReference currentUserReference = userReference.doc(uid);
          await currentUserReference.update({"coverImageUrl":imagecoverUrl});
          return true;
        } on Exception catch (e) {
          print("cover img m error");
          return false;
        }
        Map<String, dynamic> data = {
          "uid": uid,
          "image url": imagecoverUrl.toString(),
        };

        print(data);
        imageReference
            .add(data)
            .then((value) => print("Successfully add to firestore"))
            .onError((error, stackTrace) => print('Error'));
      }
    }
    catch(e){
      print("cover img m error");
      print(e);
    }

  }
}



/////////////////////////////For Practise Seprate Method////////////////////////////
// uploadImageToFirebase(BuildContext context) async {
//   /// UPLOAD IMAGE TO FIREBASE
//   String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();
//   firebase_storage.Reference ref = storage.ref().child("images").child("/$UniqueName");
//   String imageUrl="";
//   try {
//     // store the file
//     await ref.putFile(imageFile!);
//     imageUrl = await ref.getDownloadURL();
//
//     if(imageUrl != null){
//       User? user=FirebaseAuth.instance.currentUser;
//       String uid="";
//       print("uid:$uid");
//
//       if(user!= null){
//         uid=user!.uid;
//       }
//       print("uid:$uid");
//
//       Map<String, dynamic> data = {
//         "uid": uid,
//         "image url": imageUrl.toString(),
//       };
//
//       print(data);
//       imagerefrence
//           .add(data)
//           .then((value) => print("Successfully add to firestore"))
//           .onError((error, stackTrace) => print('Error'));
//     }
//   } catch (error) {
//     print(error);
//   }
// }