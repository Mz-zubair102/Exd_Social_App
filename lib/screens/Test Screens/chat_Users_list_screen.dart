import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../Models/user_model.dart';
import '../../controller/chat_Users_list_screen_controller.dart';
import '../chat_page.dart';

class ChatUsersListScreen extends StatefulWidget {
  final UsersModel userdetail;

  ChatUsersListScreen({
    Key? key,
    required this.userdetail,
  }) : super(key: key);

  @override
  State<ChatUsersListScreen> createState() => _ChatUsersListScreenState();
}

class _ChatUsersListScreenState extends State<ChatUsersListScreen> {
  CollectionReference uerRefrence =
  FirebaseFirestore.instance.collection("user");
  User? user = FirebaseAuth.instance.currentUser;

  // UserListController controller=Get.put(UserListController());

  ///Just For practise Use only I not use in this code
////////////////////////////By Future Method Get User Detail//////////////////
  CollectionReference userReference = FirebaseFirestore.instance.collection(
      'user');
  late Future<List<UsersModel>> usersFuture;

  // Future<List<UsersModel>> getusersListFromFirestore() async {
  //   List<UsersModel> usersList = [];
  //   // var q=await userReference.get();
  //   // for (var doc in q.docs) {
  //   //   Map<String,dynamic> docData=doc.data() as Map<String,dynamic>;
  //   //   usersList.add(PostModel.fromJson(docData, doc.id));
  //   // }
  //   userReference
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
  //       usersList.add(UsersModel.fromJson(docData, doc.id));
  //     }
  //     print("usersList.length");
  //     print(usersList.length);
  //   }).onError((error, stackTrace) {
  //     print("$error");
  //   });
  //   print("usersList.length");
  //   print(usersList.length);
  //   //await Future.delayed(Duration.zero);
  //   // setState(() {
  //   //
  //   // });
  //   return usersList;
  // },
  Future<List<UsersModel>> getusersListsFromFirestore() async {
    List<UsersModel> usersList = [];
    // var q=await userReference.doc(user!.uid).collection("my_user").get();
    // for (var doc in q.docs) {
    //   Map<String,dynamic> docData=doc.data() as Map<String,dynamic>;
    //   usersList.add(UsersModel.fromJson(docData, doc.id));
    // }
    userReference.doc(user!.uid).collection("my_user")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        usersList.add(UsersModel.fromJson(docData, doc.id));
      }
      print("usersList.length");
      print(usersList.length);
    }
    ).onError((error, stackTrace) {
      print("$error");
    });
    print("usersList.length");
    print(usersList.length);
    //await Future.delayed(Duration.zero);
    // setState(() {
    //
    // });
    return usersList;
  }

  // UserListController controller=Get.put(UserListController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // usersFuture = getusersListFromFirestore();
    usersFuture = getusersListsFromFirestore();
  }

//////////////////////////////END////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatUsersListScreenController>(
        init: ChatUsersListScreenController(),
        builder: (_) {
          // return FutureBuilder<List<UsersModel>>(
          //     future: getusersListsFromFirestore(),
      return FutureBuilder<QuerySnapshot>(
          future: uerRefrence.get(),
          // builder: (BuildContext context, AsyncSnapshot<List<UsersModel>> snapshot){
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            // if (snapshot.hasData && !snapshot.data!.exists) {
            //   return const Text("Document does not exist");
            // }
            if (snapshot.connectionState == ConnectionState.done) {
                  return Scaffold(
                    floatingActionButton: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: FloatingActionButton(
                        backgroundColor: Colors.cyan,
                        onPressed: () {
                          _.showMessageDialoge(context);
                          // _showMessageDialoge();
                        },
                        child: const Icon(Icons.add_comment_rounded),
                      ),
                    ),
                    body: Column(
                      children: [
                        Container(height: 100,
                          width: Get.width,
                          color: Colors.grey.shade300,
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              // itemCount: snapshot.data!.length,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, int index) {
                                Map<String, dynamic> doc = snapshot.data!
                                    .docs[index].data() as Map<String, dynamic>;
                                String docId = snapshot.data!.docs[index].id;
                                UsersModel userdetail = UsersModel.fromJson(
                                    doc, docId);
                                // UsersModel userdetail=snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                height: 50.0,
                                                width: 50.0,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.cyan,
                                                    // borderRadius: new BorderRadius.all(const Radius.circular(30)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            userdetail
                                                                .profileImageUrl),
                                                        fit: BoxFit.fill
                                                    )
                                                ),
                                              ),
                                              Positioned(
                                                  left: 32,
                                                  bottom: -4,
                                                  child: Container(
                                                    height: 18,
                                                    width: 18,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                18))),
                                                    child: Center(
                                                      child: Container(
                                                        height: 14,
                                                        width: 14,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            color: Colors.green
                                                        ),
                                                      ),
                                                      // child: Icon(
                                                      //   CupertinoIcons.hand_thumbsup_fill,
                                                      //   color: Colors.red.withOpacity(0.8),
                                                      //   size: 20,
                                                      // )
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8,),
                                        Text(
                                          userdetail.name,
                                          style: const TextStyle(fontSize: 12,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),);
                              }),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            //  scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> doc = snapshot.data!
                                  .docs[index].data() as Map<String, dynamic>;
                              String docId = snapshot.data!.docs[index].id;
                              UsersModel userdetail = UsersModel.fromJson(
                                  doc, docId);
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final _user = types.User(
                                        id: userdetail.uid,
                                        firstName: userdetail.name,
                                        imageUrl: userdetail.profileImageUrl,
                                      );
                                      Get.to(() =>
                                          ChatPages(
                                            // userdetail: userdetail,
                                            receiverUser: _user,
                                          ));

                                      /// By controller
                                      // controller.currentOtherUser=types.User(
                                      //   id: detail.uid,
                                      //   firstName:detail.name,
                                      //   imageUrl: detail.profileImageUrl,
                                      // );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          2.0, 8.0, 2.0, 0.0),
                                      child: ListTile(
                                        leading: GestureDetector(
                                          onTap: () async {
                                            // Display the image in large form.
                                            print("Likes Clicked");
                                          },
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                height: 50.0,
                                                width: 50.0,
                                                decoration: new BoxDecoration(
                                                    color: Colors.cyan,
                                                    borderRadius: new BorderRadius
                                                        .all(
                                                        const Radius.circular(
                                                            50))),
                                                child: CircleAvatar(
                                                    backgroundColor: Colors
                                                        .cyan,
                                                    radius: 50,
                                                    backgroundImage: NetworkImage(
                                                        userdetail
                                                            .profileImageUrl)
                                                ),
                                              ),
                                              Positioned(
                                                  left: 32,
                                                  bottom: -4,
                                                  child: Container(
                                                    height: 18,
                                                    width: 18,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                18))),
                                                    child: Center(
                                                      child: Container(
                                                        height: 14,
                                                        width: 14,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            color: Colors.green
                                                        ),
                                                      ),
                                                      // child: Icon(
                                                      //   CupertinoIcons.hand_thumbsup_fill,
                                                      //   color: Colors.red.withOpacity(0.8),
                                                      //   size: 20,
                                                      // )
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          userdetail.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          "User Last Message",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        trailing: Text(
                                            "14-1-2023",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                              // return Card(
                              //   color: Colors.lightBlueAccent.shade100,
                              //   margin: const EdgeInsets.symmetric(
                              //       horizontal: 8 * 0.4, vertical: 6),
                              //   elevation: 0.7,
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(20)),
                              //   child: InkWell(
                              //     onTap: () {
                              //
                              //       final _user =  types.User(
                              //         id: userdetail.uid,
                              //         firstName:userdetail.name,
                              //         imageUrl: userdetail.profileImageUrl,
                              //       );
                              //       Get.to(() => ChatPage(
                              //             // userdetail: userdetail,
                              //         receiverUser: _user,
                              //           ));
                              //       /// By controller
                              //       // controller.currentOtherUser=types.User(
                              //       //   id: detail.uid,
                              //       //   firstName:detail.name,
                              //       //   imageUrl: detail.profileImageUrl,
                              //       // );
                              //     },
                              //     child: ListTile(
                              //       leading: CircleAvatar(
                              //           // ignore: unnecessary_null_comparison
                              //           child: userdetail.profileImageUrl == null
                              //               ? Container(
                              //                   color: Colors.grey,
                              //                   child: const Icon(Icons.person),
                              //                 )
                              //               : Image.network(
                              //                   userdetail.profileImageUrl,
                              //                   fit: BoxFit.cover,
                              //                 )),
                              //       title: Text(
                              //         userdetail.name,
                              //         style: const TextStyle(
                              //             color: Colors.black87,
                              //             fontSize: 18,
                              //             fontWeight: FontWeight.w700),
                              //       ),
                              //       subtitle: const Text(
                              //         "Last User Message",
                              //         maxLines: 1,
                              //       ),
                              //       trailing: const Text(
                              //         "Time",
                              //         style: TextStyle(color: Colors.black87),
                              //       ),
                              //     ),
                              //   ),
                              // );
                            }),
                      ],
                    ),
                  );
            }
            return Center(child: CircularProgressIndicator());
          });
    });
  }

// void _showMessageDialoge() {
//   String email = "";
//   showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: Colors.grey.shade200,
//             contentPadding: const EdgeInsets.only(
//                 left: 24, right: 24, top: 20, bottom: 10),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20)),
//             title: Row(
//               children: const [
//                 Icon(
//                   Icons.person_add,
//                   color: Colors.cyan,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   "Add User",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                   ),
//                 )
//               ],
//             ),
//             content: TextFormField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 hintText: "Email",
//                 prefixIcon: const Icon(Icons.email,color: Colors.cyan,),
//               ),
//               onChanged: (value) => email = value,
//             ),
//             actions: [
//               MaterialButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 child: const Text(
//                   "Cancel",
//                   style: TextStyle(
//                     color: Colors.cyan,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               MaterialButton(
//                 onPressed: () {
//                   if (email.isNotEmpty) {
//                     ChatScreenController().addChatUser(email).then((value) {
//                       if (!value) {
//                         final snackBar = SnackBar(
//                           content: const Text('User Doesnot  Exist'),
//                           action: SnackBarAction(
//                             label: 'Undo',
//                             onPressed: () {
//                               // Some code to undo the change.
//                             },
//                           ),
//                         );
//
//                         // Find the ScaffoldMessenger in the widget tree
//                         // and use it to show a SnackBar.
//                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                       }
//                     });
//                   }
//                 },
//                 child: const Text(
//                   "Add ",
//                   style: TextStyle(
//                     color: Colors.cyan,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ));
// }
}
