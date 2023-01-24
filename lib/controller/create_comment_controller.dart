import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

import '../db/firebasedb.dart';

class CreateCommentController extends GetxController {
  GlobalKey<FormState> _postformke=GlobalKey();
  TextEditingController commenttextcontroller=TextEditingController();

  static CollectionReference commentReference =
  FirebaseFirestore.instance.collection("comment");
  CollectionReference postReference =
  FirebaseFirestore.instance.collection("post");
  User? currentuser = FirebaseAuth.instance.currentUser;

  File? commentImageFile;
  String commentImageUpdateKey = "commentImageUpdatekey";

  void addCommentToFirestore({required String commenttext,required String profileImageUrl,required String username,required String postid,required String datetimepost})async{
    User? currentUser=FirebaseAuth.instance.currentUser;
    int commentlen=0;
    // CollectionReference postReference = FirebaseFirestore.instance.collection("post");
    String uid="";
    if(currentUser!=null){
      uid=currentUser.uid;
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    // String nowdatetime = DateTime.now().microsecondsSinceEpoch.toString();
    // DocumentReference currentUserRefrence = commentReference.doc(currentUser!.uid);
    Map<String, dynamic> data={"uid": uid,"commenttext":commenttext,"userImageUrl":profileImageUrl,"datetimecomment":formattedDate,"username":username,"postid":postid,"datetimepostid":datetimepost};
    commentReference
        .add(data).then((value)
    => print("Successfully add to firestore"))
        .onError((error, stacktrace)
    =>print("Error $error"));
    QuerySnapshot snap=await commentReference.where("postid" ,isEqualTo: postid ).get();
    commentlen=snap.docs.length;
    await postReference.doc(postid).update({"commentcount": commentlen});
  }







//////////////////////////For Practise Seprate Method//////////////////////////////////////
  void getcommentslength(String postid)async{
    int commentlen=0;
    try{
      QuerySnapshot snap=await commentReference.where("postid" ,isEqualTo: postid ).get();
      commentlen=snap.docs.length;
      await postReference.doc(postid).update({"commentcount": commentlen});

    }catch (e){
      print(e);
    }
    onInit();
  }

  void Commentcount(String postid)async{
    await postReference.doc(postid).update({
      // else we need to add uid to the likes array
      "commentcount": FieldValue.increment(1)});
  }

}