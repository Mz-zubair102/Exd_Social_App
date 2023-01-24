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

class PostsScreenController extends GetxController {

  static CollectionReference likeReference =
  FirebaseFirestore.instance.collection("like");
  CollectionReference postReference =
  FirebaseFirestore.instance.collection("post");
  User? currentuser = FirebaseAuth.instance.currentUser;
  CollectionReference commentRefrence =
  FirebaseFirestore.instance.collection("comment");


  ///Method likes and dislike by array on post and count likesand send likesuser detail  send to firebase
  Future<void> likepost({required String postid,required String uid,required List likes,required String likeusername, required String likeuserimageurl})async{
    try{
      if(likes.contains(uid)){
        // DocumentReference currentLikesRefrence = likeReference.doc(uid);
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
        Map<String, dynamic> data = {
        "uid": uid,
        "postid": postid,
        "likeusername": likeusername,
        "likeuserImageUrl": likeuserimageurl,
        "likedatetime": formattedDate,};
        // int likeslen=0;
        // await currentLikesRefrence
        //     .update(data).then((value) => print("Successfully add to firestore"))
        //     .onError((error, stacktrace) => print("Error $error"));
        await likeReference
            .add(data).then((value) => print("Successfully add to firestore"))
            .onError((error, stacktrace) => print("Error $error"));
        // QuerySnapshot snap=await likeReference.where("postid" ,isEqualTo: postid ).get();
        // likeslen=snap.docs.length;
        // await postReference.doc(postid).update({"likecount": likeslen});

        await postReference.doc(postid).update({
          // if the likes list contains the user uid, we need to remove it
          'likes':FieldValue.arrayRemove([uid]),
          "likecount": FieldValue.increment(-1),
          // "likecount": likeslen
        });
      }else{
        likeReference.doc(uid).delete();
        // likeslen=snap.docs.length;
        // await postReference.doc(postid).update({"likescount": likeslen});
        await postReference.doc(postid).update({
          // else we need to add uid to the likes array
          'likes':FieldValue.arrayUnion([uid]),
          "likecount": FieldValue.increment(1),
        });
      }

    }catch(e){
      print(e.toString());
    }
  }



///////////////////////////////For Practise Seprate Method///////////////////////////////////////////////////

 ///Method likes and dislike by array and count likes on post
  Future<void> likespost(String postid,String uid,List likes)async{
    try{
      if(likes.contains(uid)){
        await postReference.doc(postid).update({
           // if the likes list contains the user uid, we need to remove it
          'likes':FieldValue.arrayRemove([uid]),"likecount": FieldValue.increment(-1),

        });
      }else{
        await postReference.doc(postid).update({
          // else we need to add uid to the likes array
          'likes':FieldValue.arrayUnion([uid]),"likecount": FieldValue.increment(1),
        });
      }

    }catch(e){
      print(e.toString());
    }
  }
    // ignore: unnecessary_overrides
    void onInit() {
      super.onInit();
    }
    ///Method Likes User detail send to firebase
    Future<void> addLikesToFirestore(
        {required String postid, required String likeusername, required String likeuserimageurl}) async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      // CollectionReference postReference = FirebaseFirestore.instance.collection("post");
      String uid = "";
      if (currentUser != null) {
        uid = currentUser.uid;
      }
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
      // String nowdatetime = DateTime.now().microsecondsSinceEpoch.toString();
      // DocumentReference currentUserRefrence = commentReference.doc(currentUser!.uid);
      Map<String, dynamic> data = {
        "uid": uid,
        "postid": postid,
        "likeusername": likeusername,
        "likeuserImageUrl": likeuserimageurl,
        "likedatetime": formattedDate,
      };
     await likeReference
          .add(data).then((value) => print("Successfully add to firestore"))
          .onError((error, stacktrace) => print("Error $error"));
    }
  }
