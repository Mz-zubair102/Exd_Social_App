import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controller/profile_screen_controller.dart';
import 'package:exd_social_app/screens/Image_picker_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Models/post_model.dart';
import '../../Models/user_model.dart';
import '../../Widgets/text_field.dart';
import '../../Widgets/text_button_widget.dart';
import '../../Widgets/text_widget.dart';

import '../home_screen.dart';
import '../profile_screen.dart';
import '../login_screen.dart';

class FirebaseScreen extends StatefulWidget {
  const FirebaseScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseScreen> createState() => _FirebaseScreenState();
}

class _FirebaseScreenState extends State<FirebaseScreen> {
  CollectionReference uerRefrence =
  FirebaseFirestore.instance.collection("user");
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    return GetBuilder<ImagePickerController>(
        init:ImagePickerController(),
        builder: (logic) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Firebase SCREEN"),
              backgroundColor: Colors.cyan,
              actions: [
                IconButton(
                    onPressed: () {
                      auth.signOut().then((value) {
                        // Get.to(()=>LoginScreen());
                      }).onError((error, stackTrace) {});
                    },
                    icon: Icon(Icons.logout_outlined))
              ],
            ),
            // drawer: Drawer(
            //   elevation: 5,
            //   backgroundColor: Colors.grey.shade200,
            //   width: 300,
            //   // shape: ,
            //   child: ListView(
            //     children: [
            //       DrawerHeader(
            //           decoration: BoxDecoration(color: Colors.cyan),
            //           child: Image.asset("Assets/FirebaseLogo.png")),
            //       ListTile(
            //           onTap: () {
            //             Get.to(() => HomeScreen());
            //           },
            //           leading: Icon(
            //             Icons.account_box,
            //             size: 32,
            //             color: Colors.cyan,
            //           ),
            //           trailing: Icon(
            //             Icons.navigate_next,
            //             size: 32,
            //             color: Colors.cyan,
            //           ),
            //           title: Text(
            //             "Firebase Screen",
            //             style: TextStyle(
            //                 fontSize: 17,
            //                 color: Colors.cyan,
            //                 fontWeight: FontWeight.bold),
            //           )),
            //       ListTile(
            //           onTap: () {
            //             Get.to(() => ProfileScreen());
            //           },
            //           leading: Icon(
            //             Icons.account_box,
            //             size: 32,
            //             color: Colors.cyan,
            //           ),
            //           trailing: Icon(
            //             Icons.navigate_next,
            //             size: 32,
            //             color: Colors.cyan,
            //           ),
            //           title: Text(
            //             "Profile Screen",
            //             style: TextStyle(
            //                 fontSize: 17,
            //                 color: Colors.cyan,
            //                 fontWeight: FontWeight.bold),
            //           )),
            //       ListTile(
            //           onTap: () {
            //             Get.to(() => ImagePickerProfileScreen());
            //           },
            //           leading: Icon(
            //             Icons.image,
            //             size: 32,
            //             color: Colors.cyan,
            //           ),
            //           trailing: Icon(
            //             Icons.navigate_next,
            //             size: 32,
            //             color: Colors.cyan,
            //           ),
            //           title: Text(
            //             "Image Picker Screen",
            //             style: TextStyle(
            //                 fontSize: 17,
            //                 color: Colors.cyan,
            //                 fontWeight: FontWeight.bold),
            //           ))
            //     ],
            //   ),
            // ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: FutureBuilder<DocumentSnapshot>(
                  future: uerRefrence.doc(user!.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      ///------------With Model--------------------------///
                      Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                      UsersModel detail =
                      UsersModel.fromJson(data, snapshot.data!.id);
                      // UserModel detail=UserModel.fromDocumentSnapshot(snapshot: snapshot.data!.docs[index]);
                      // return Text("Full Name: ${detail.name} ${data['name']}");

                      return Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                  onTap: () async{
                                    await logic.pickCoverImage(context);
                                  },
                                  child: Container(
                                      width: Get.width,
                                      height: 160,
                                      color: Colors.grey.shade300,
                                      child: Image.network(detail.coverImageUrl,fit:BoxFit.fill)
                                  )
                              ),
                              Positioned(
                                  left: 10,
                                  bottom: -40,
                                  child: GestureDetector(
                                    onTap: ()async{
                                      await logic.pickUserProfileImage(context);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox(width: 100, height: 100,
                                        child: Container(
                                          color: Colors.grey.shade100,
                                          child: Image.network(
                                              detail.profileImageUrl,
                                              fit: BoxFit.cover),
                                          // child: Center(child: Icon(Icons.image,color: Colors.black,),),
                                        ),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  right: 10,
                                  top: 5,
                                  child: TextButton(
                                    onPressed: () async {
                                      await logic.pickCoverImage(context);
                                    },
                                    child: Text(
                                      "Edit Cover Photo",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Positioned(
                                  left: 100,
                                  bottom: -18,
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(36))),
                                    child: IconButton(
                                      onPressed: () async {
                                        await logic.pickUserProfileImage(context);
                                      },
                                      icon: Center(
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.black.withOpacity(0.8),
                                            size: 22,
                                          )),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(height: 40,),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 4,
                                  color: Colors.grey.shade200,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                  title: "Name",
                                                  detail: detail.name),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextWidget(
                                                  title: "Email",
                                                  detail: detail.email),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Text("loading");
                  },
                ),
              ),
            ),
          );
        });
  }
}
