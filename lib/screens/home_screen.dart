import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/screens/posts_screen.dart';
import 'package:exd_social_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Models/user_model.dart';
import '../Models/users_model.dart';
import '../Widgets/button_custom_widget.dart';
import '../Widgets/custom_text.dart';
import 'Image_picker_profile_screen.dart';
import 'Test Screens/firebase_screen.dart';
import 'chat/rooms.dart';
import 'Test Screens/chat_Users_list_screen.dart';
import 'create_post_screen.dart';
import 'crete_comment_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  // final auths =FirebaseAuth.instance.authStateChanges();

  // void currentuser() async {
  //   CollectionReference chatReference=FirebaseFirestore.instance.collection("chat");
  //   chatReference
  //       .where("remoteId", isEqualTo:widget.receiverUser.id )
  //       .where("id", isEqualTo:_user.id )
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       Map<String,dynamic> docData=doc.data() as Map<String,dynamic>;
  //       _messages.insert(0,types.Message.fromJson(docData));
  //     }
  //     setState(() {
  //
  //     });
  //   }).onError((error, stackTrace){
  //     print("$error");
  //   });
  //   // final response = await rootBundle.loadString('assets/messages.json');
  //   // final messages = (jsonDecode(response) as List)
  //   //     .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
  //   //     .toList();
  //
  //   setState(() {
  //     // _messages = messages;
  //   });
  // }
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: uerRefrence.doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            // return Scaffold(
            //   body: Center(
            //     child: CupertinoActivityIndicator(
            //       color: Color.fromARGB(255, 248, 101, 148),
            //     ),
            //   ),
            // );
            return Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            ///------------With Model--------------------------///
            // Map<String, dynamic> data =
            //     snapshot.data!.data() as Map<String, dynamic>;
            //Map<String,dynamic> data=snapshot.data!.data() as Map<String,dynamic>;
            UserProfileModel detail=UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data);
            print(detail);
            // UsersModel detail = UsersModel.fromJson(data, snapshot.data!.id);
            return DefaultTabController(
                    length: 4,
                    child: Scaffold(
                        resizeToAvoidBottomInset: true,
                        appBar: AppBar(
                          elevation: 5,
                          backgroundColor: Colors.cyan,
                          title: const Text("FIREBASE"),
                          actions: [
                            IconButton(
                                onPressed: () {
                                },
                                icon: Icon(CupertinoIcons.camera)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.search)),
                            IconButton(
                                onPressed: () {
                                  auth.signOut().then((value) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => LoginScreen()));
                                  }).onError((error, stackTrace) {});
                                },
                                icon: Icon(Icons.logout_outlined)),
                            IconButton(
                                onPressed: () {
                                  Get.to(()=>LoginScreen());
                                },
                                icon: Icon(CupertinoIcons.ellipsis_vertical)),

                          ],

                          bottom: TabBar(indicatorColor: Colors.white, tabs: [
                            Tab(child: Icon(Icons.home,size: 30,)),
                            Tab(
                                child: Icon(CupertinoIcons.profile_circled,size: 30,)),
                                // child: Text("CHATS",
                                //     style: TextStyle(
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w900))),
                            Tab(
                                child: Icon(Icons.chat,size: 30,),
                                // child: Text("STATUS",
                                //     style: TextStyle(
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w900))
                            ),
                            Tab(
                              child: Icon(Icons.settings,size: 30,),
                                // child: Text("CALLS",
                                //     style: TextStyle(
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w900))
                            ),
                          ]),
                        ),
                        drawer: Drawer(
                          elevation: 5,
                          backgroundColor: Colors.grey.shade200,
                          width: 300,
                          // shape: ,
                          child: ListView(
                            children: [
                              UserAccountsDrawerHeader(
                                accountName: Text(
                                  detail.firstName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.8),
                                      fontWeight: FontWeight.bold),
                                ),
                                accountEmail: Text(detail.metadata.email,
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                currentAccountPicture: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Container(
                                      color: Colors.grey.shade100,
                                      child: Image.network(detail.profileImageUrl,
                                          fit: BoxFit.cover),
                                      // child: Center(child: Icon(Icons.image,color: Colors.black,),),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.lightBlueAccent,
                                      // offset: const Offset(
                                      //   3.0,
                                      //   3.0,
                                      // ),
                                      blurRadius: 8.0,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                  image: DecorationImage(
                                    opacity: 80,
                                    // scale: 6,
                                    image: NetworkImage(
                                      detail.coverImageUrl,
                                    ),
                                    fit: BoxFit.fill,
                                    // image: AssetImage("Assets/FirebaseLogo.png"),
                                  ),
                                ),
                              ),
                              DrawerHeader(
                                  decoration:
                                  BoxDecoration(color: Colors.cyan.shade200),
                                  child: Image.asset(
                                    "Assets/FirebaseLogo.png",
                                  )),
                              ListTile(
                                  onTap: () {
                                    Get.to(() => ProfileScreen());
                                  },
                                  leading: Icon(
                                    Icons.account_box,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  title: Text(
                                    "Profile Screen",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold),
                                  )),
                              ListTile(
                                  onTap: () {
                                    Get.to(() => CommentMeScreen());
                                  },
                                  leading: Icon(
                                    Icons.comment,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  title: Text(
                                    "Create Comment Screen",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold),
                                  )),
                              ListTile(
                                  onTap: () {
                                    Get.to(() => CreatePostScreen(userdetail: detail));
                                  },
                                  leading: Icon(
                                    Icons.post_add_outlined,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  title: Text(
                                    "Create Post Screen",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold),
                                  )),
                              ListTile(
                                  onTap: () {
                                    Get.to(() => ImagePickerProfileScreen());
                                  },
                                  leading: Icon(
                                    Icons.image,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  title: Text(
                                    "Image Picker Screen",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold),
                                  )),
                              ListTile(
                                  onTap: () {
                                    Get.to(() => FirebaseScreen());
                                  },
                                  leading: Icon(
                                    Icons.add,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    size: 32,
                                    color: Colors.cyan,
                                  ),
                                  title: Text(
                                    "Firebase Screen",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),
                        body: SafeArea(
                          child: TabBarView(
                            children: [
                              PostsScreen(userdetails: detail),
                              ProfileScreen(),
                              RoomsPage(),
                              // ChatUsersListScreen(userdetail: detail,),
                              Center(child: Text("Setting"),)
                            ],
                          ),
                        )));
            // return Scaffold(
            //   appBar: AppBar(
            //     title: Text("Home Screen"),
            //     centerTitle: true,
            //     backgroundColor: Colors.cyan,
            //     actions: [
            //       IconButton(
            //           onPressed: () {
            //             auth.signOut().then((value) {
            //               Get.to(()=>LoginScreen());
            //             }).onError((error, stackTrace) {});
            //           },
            //           icon: Icon(Icons.logout_outlined))
            //     ],
            //   ),
            //   drawer: Drawer(
            //     elevation: 5,
            //     backgroundColor: Colors.grey.shade200,
            //     width: 300,
            //     // shape: ,
            //     child: ListView(
            //       children: [
            //         UserAccountsDrawerHeader(
            //             accountName: Text(detail.name,style: TextStyle(fontSize: 20,color:Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold),),
            //             accountEmail: Text(detail.email,style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            //           currentAccountPicture: ClipRRect(
            //             borderRadius: BorderRadius.circular(20),
            //             child: SizedBox(width: 10, height: 10,
            //               child: Container(
            //                 color: Colors.grey.shade100,
            //                 child: Image.network(
            //                     detail.profileImageUrl,
            //                     fit: BoxFit.cover),
            //                 // child: Center(child: Icon(Icons.image,color: Colors.black,),),
            //               ),
            //             ),
            //           ),
            //           decoration: BoxDecoration(
            //             color: Colors.grey.shade200,
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.lightBlueAccent,
            //                 // offset: const Offset(
            //                 //   3.0,
            //                 //   3.0,
            //                 // ),
            //                 blurRadius: 8.0,
            //                 spreadRadius: 0.5,
            //               ),
            //             ],
            //             image: DecorationImage(
            //               opacity: 80,
            //               // scale: 6,
            //               image:NetworkImage(detail.coverImageUrl,),
            //               fit: BoxFit.fill,
            //               // image: AssetImage("Assets/FirebaseLogo.png"),
            //             ),
            //           ),
            //
            //         ),
            //         DrawerHeader(
            //             decoration: BoxDecoration(color: Colors.cyan.shade200),
            //             child: Image.asset("Assets/FirebaseLogo.png",)),
            //         ListTile(
            //             onTap: () {
            //               Get.to(() => ProfileScreen());
            //             },
            //             leading: Icon(
            //               Icons.account_box,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             trailing: Icon(
            //               Icons.navigate_next,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             title: Text(
            //               "Profile Screen",
            //               style: TextStyle(
            //                   fontSize: 17,
            //                   color: Colors.cyan,
            //                   fontWeight: FontWeight.bold),
            //             )),
            //         ListTile(
            //             onTap: () {
            //               Get.to(() => Comment_Me_Screen());
            //             },
            //             leading: Icon(
            //               Icons.comment,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             trailing: Icon(
            //               Icons.navigate_next,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             title: Text(
            //               "Create Comment Screen",
            //               style: TextStyle(
            //                   fontSize: 17,
            //                   color: Colors.cyan,
            //                   fontWeight: FontWeight.bold),
            //             )),
            //         ListTile(
            //             onTap: () {
            //               Get.to(() => CreatePostScreen(userdetail: detail));
            //             },
            //             leading: Icon(
            //               Icons.post_add_outlined,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             trailing: Icon(
            //               Icons.navigate_next,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             title: Text(
            //               "Create Post Screen",
            //               style: TextStyle(
            //                   fontSize: 17,
            //                   color: Colors.cyan,
            //                   fontWeight: FontWeight.bold),
            //             )),
            //         ListTile(
            //             onTap: () {
            //               Get.to(() => ImagePickerProfileScreen());
            //             },
            //             leading: Icon(
            //               Icons.image,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             trailing: Icon(
            //               Icons.navigate_next,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             title: Text(
            //               "Image Picker Screen",
            //               style: TextStyle(
            //                   fontSize: 17,
            //                   color: Colors.cyan,
            //                   fontWeight: FontWeight.bold),
            //             )),
            //         ListTile(
            //             onTap: () {
            //               Get.to(() => FirebaseScreen());
            //             },
            //             leading: Icon(
            //               Icons.add,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             trailing: Icon(
            //               Icons.navigate_next,
            //               size: 32,
            //               color: Colors.cyan,
            //             ),
            //             title: Text(
            //               "Firebase Screen",
            //               style: TextStyle(
            //                   fontSize: 17,
            //                   color: Colors.cyan,
            //                   fontWeight: FontWeight.bold),
            //             )),
            //       ],
            //     ),
            //   ),
            //   body:SafeArea(
            //     child: SingleChildScrollView(
            //       child: Padding(
            //         padding: EdgeInsets.all(8.0),
            //         child:Column(
            //           children: [
            //             Card(
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Row(
            //                   children: [
            //                     Expanded(
            //                       child: GestureDetector(
            //                         onTap:(){
            //                           Get.to(()=>ProfileScreen());
            //                         },
            //                         child: Container(
            //                           child: Row(
            //                             children: [
            //                               Container(
            //                                 width: 50,height: 50,
            //                                 decoration: BoxDecoration(
            //                                     shape: BoxShape.circle,
            //                                     color: Colors.cyan.shade300,
            //                                     image: DecorationImage(
            //                                         image: NetworkImage(detail.profileImageUrl),
            //                                         fit: BoxFit.cover
            //                                     )
            //                                 ),
            //
            //                               ),
            //                               const SizedBox(width: 8,),
            //                               Column(
            //                                 mainAxisAlignment: MainAxisAlignment.start,
            //                                 crossAxisAlignment: CrossAxisAlignment.start,
            //                                 children: [
            //                                   Text(detail.name,style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            //                                   // Text("20 min."),
            //                                   Text(detail.email,style: TextStyle(color:Colors.lightBlueAccent,fontSize: 16),),
            //                                 ],
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                     IconButton(onPressed: (){Get.to(()=>CreatePostScreen(userdetail: detail,));}, icon: Icon(CupertinoIcons.add_circled_solid,color:Colors.lightBlueAccent.shade200,size:32))
            //                   ],
            //                 ),
            //               ),
            //             ),
            //
            //           ],
            //         )
            //       ),
            //     ),
            //   )
            //
            // );
          }
          return Scaffold(body:Center(child: CircularProgressIndicator()));
        });
  }
}
// Container(
// child: ListView.separated(
// itemCount: 20,
// itemBuilder: (context, index) {
// return Container(
// width: Get.width,
// child: Column(
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// children: [
// Row(
// children: [
//
// Expanded(
// child: Container(
// child: Row(
// children: [
// Container(
// width: 50,height: 50,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// color: Colors.cyan.shade300,
// image: DecorationImage(
// image: NetworkImage(detail.profileImageUrl),
// fit: BoxFit.cover
// )
// ),
//
// ),
// const SizedBox(width: 8,),
// Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text("Name"),
// Text("20 min.")
// ],
// )
// ],
// ),
// ),
// ),
// IconButton(onPressed: (){},
// icon: Icon(Icons.share,color: Colors.red,))
// ],
// ),
// const SizedBox(height: 10,),
// Text("For information on the generic Dart part of this file, see the For information on the generic Dart part of this file, see the For information on the generic Dart part of this file, see the For information on the generic Dart part of this file, see the "),
// ],
// ),
// ),
// const SizedBox(height: 10,),
//
// SizedBox(width: Get.width,
// // height: 150,
// child: Container(
// height: 200,
// child: Image.network(detail.coverImageUrl,
// fit: BoxFit.fitWidth,),
// ),
// ),
// const SizedBox(height: 10,),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text("12 Likes"),
// Text("12 Comments"),
// ],
// ),
// Divider(),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// IconButton(onPressed: (){},
// icon: Icon(Icons.thumb_up_alt_outlined,color: Colors.red,)),
// Text("12 Comments"),
// ],
// ),
// ],
// ),
// ),
//
//
//
//
// ],
// ),
// );
// }, separatorBuilder: (BuildContext context, int index) {
// return Container(width: Get.width,
// height: 10,
// color: Colors.grey,
// );
// },),
// ),
