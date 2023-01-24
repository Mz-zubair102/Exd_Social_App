import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/message_model.dart';
import '../Models/user_model.dart';

TextEditingController chatController = TextEditingController();
User? user = FirebaseAuth.instance.currentUser;
CollectionReference userReference =
FirebaseFirestore.instance.collection("users");

class ChatUsersListScreenController extends GetxController {
  // for adding chat user of our conversation

  Future<bool> addChatUser(String email) async {
    final data = await userReference.where("email", isEqualTo: email).get();

    if (data.docs.isNotEmpty && data.docs.first.id != user!.uid) {
      userReference
          .doc(user!.uid)
          .collection("myusers")
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      false;
    }
    return false;
  }

  void showMessageDialoge(context) {
    String email = "";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(
                Icons.person_add,
                color: Colors.cyan,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Add User",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              )
            ],
          ),
          content: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)),
              hintText: "Email",
              prefixIcon: const Icon(Icons.email,color: Colors.cyan,),
            ),
            onChanged: (value) => email = value,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 16,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                if (email.isNotEmpty) {
                  ChatUsersListScreenController().addChatUser(email).then((value) {
                    Get.back();
                    if (!value) {
                      final snackBar = SnackBar(
                        content: const Text('User Doesnot  Exist'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                }
              },
              child: const Text(
                "Add ",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ));
  }






  ///////////////////////////////////For Practise Seprate Method/////////////////////
  /// Useful for getting conversation id
  static String getConversationID(String id) =>
      user!.uid.hashCode <= id.hashCode
          ? '${user!.uid}_$id'
          : '${id}_${user?.uid}';

  /// for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UsersModel user) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  /// for sending message

  static Future<void> sendMessage(UsersModel userdetail, String msg) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    // message to send
    final Message message = Message(
        toId: userdetail.id,
        msg: msg,
        read: "",
        type: Type.text,
        fromId: user!.uid,
        sent: time);
    final ref = FirebaseFirestore.instance
        .collection('chats/${getConversationID(userdetail.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}