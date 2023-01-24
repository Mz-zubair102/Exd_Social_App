import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controller/Posts_Screen_Controller.dart';
import 'package:exd_social_app/controller/profile_screen_controller.dart';
import 'package:exd_social_app/screens/Image_picker_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Models/post_model.dart';
import '../Models/user_model.dart';
import '../Models/users_model.dart';
import '../Widgets/text_field.dart';
import '../Widgets/text_button_widget.dart';
import '../Widgets/text_widget.dart';

import 'Test Screens/firebase_screen.dart';
import 'crete_comment_screen.dart';
import 'home_screen.dart';
import 'likes_Screen----.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference uerRefrence =
  FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference postRefrence =
  FirebaseFirestore.instance.collection("post");


  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return GetBuilder<ImagePickerController>(
        init: ImagePickerController(),
        initState: (_) {},
        builder: (logic) {
          return FutureBuilder(
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
                      // Map<String, dynamic> data =
                      // snapshot.data!.data() as Map<String, dynamic>;
                      // UsersModel userdetail =
                      // UsersModel.fromJson(data, snapshot.data!.id);
                      UserProfileModel userdetail=UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data!);
                      // UserModel detail=UserModel.fromDocumentSnapshot(snapshot: snapshot.data!.docs[index]);
                      // return Text("Full Name: ${detail.name} ${data['name']}");
                      return SafeArea(
                        child: Scaffold(
                          body: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Divider(height: 5,
                                      color: Colors.grey.shade900,
                                      thickness: 3,))
                                  ],
                                ),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
                                          await logic.pickCoverImage(context);
                                        },
                                        child: Container(
                                            width: Get.width,
                                            height: 160,
                                            decoration: BoxDecoration(
                                                color: Colors.cyan.shade100,
                                                border: Border.all(
                                                    color: Colors.grey, width: 1),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.red,
                                                    // offset: const Offset(
                                                    //   3.0,
                                                    //   3.0,
                                                    // ),
                                                    blurRadius: 8.0,
                                                    spreadRadius: 0.5,
                                                  ),
                                                ]),
                                            child:userdetail.profileImageUrl !=null? Image.network(
                                                userdetail.coverImageUrl,
                                                fit: BoxFit.fill):Center(child: Icon(Icons.camera_alt_rounded,size: 32,color:Colors.white),)
                                        )
                                    ),
                                    Positioned(
                                        left: 10,
                                        bottom: -40,
                                        child: GestureDetector(
                                          onTap: () async {
                                            await logic.pickUserProfileImage(context);
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: SizedBox(width: 80, height: 80,
                                              child: Container(
                                                color: Colors.cyan.shade300,
                                                child: Image.network(
                                                    userdetail.profileImageUrl,
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
                                                color: Colors.white,
                                                // color: Colors.blue.withOpacity(0.6),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    Positioned(
                                        left: 80,
                                        bottom: -18,
                                        child: Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              color: Colors.cyan,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(36))),
                                          child: IconButton(
                                            onPressed: () async {
                                              await logic.pickUserProfileImage(
                                                  context);
                                            },
                                            icon: Center(
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
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
                                      padding: const EdgeInsets.all(6),
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
                                                        detail: userdetail.firstName),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextWidget(
                                                        title: "Email",
                                                        detail: userdetail.metadata.email),
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
                                SizedBox(
                                    child: Container(
                                      width: Get.width,
                                      height: 10,
                                      color: Colors.grey.shade300,
                                    )),
                                GetBuilder<PostsScreenController>(
                                  init: PostsScreenController(),
                                    builder: (_) {
                                  return StreamBuilder<QuerySnapshot>(
                                      stream: postRefrence.where(
                                          "uid", isEqualTo: user!.uid)
                                          .orderBy("datetimepost", descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (snapshot.hasData) {
                                          if (snapshot.data != null) {
                                            //-----------------------By Document model------------------------------
                                            // 1----list view----userModel detail=snapshot.data![index];
                                            //3----single------userModel detail=snapshot.data!;
                                            // 2----list view--UserModel detail=UserModel.fromDocumentSnapshot(snapshot: snapshot.data!.docs[index]);
                                           // 4-----single--UserProfileModel detail=UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data);
                                            //-----------------------By Json Mosel--------------------
                                            // 1----single----Map<String, dynamic> data =snapshot.data!.data() as Map<String, dynamic>;;
                                            // userModel detail =userModel.fromJson(data, snapshot.data!.id);
                                            //---------------2.3 methos same-----------------
                                            // 2----List View------Map<String, dynamic> data =snapshot.data!.data() as Map<String, dynamic>;
                                            // UsersModel detail = UsersModel.fromJson(data, snapshot.data!.docs[index].id);
                                            //  2-----if use query in above listview----Map<String, dynamic> doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                            //                String docId = snapshot.data!.docs[index].id;
                                            //              PostModel detail = PostModel.fromJson(doc, docId);
                                            return Container(
                                              child: ListView.separated(
                                                physics: ScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  Map<String, dynamic> doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                                  String docId = snapshot.data!.docs[index].id;
                                                  PostModel detail = PostModel.fromJson(doc, docId);
                                                  return Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: Container(
                                                      width: Get.width,
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Container(
                                                                      child: Row(
                                                                        children: [
                                                                          Container(
                                                                            width: 50,
                                                                            height: 50,
                                                                            decoration: BoxDecoration(
                                                                                shape: BoxShape
                                                                                    .circle,
                                                                                color: Colors
                                                                                    .cyan
                                                                                    .shade300,
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage(
                                                                                        detail
                                                                                            .userImageUrl),
                                                                                    fit: BoxFit
                                                                                        .cover)),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Text(
                                                                                detail
                                                                                    .username,
                                                                                style: TextStyle(
                                                                                    fontSize: 19,
                                                                                    color: Colors
                                                                                        .black,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .bold),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,),
                                                                              Text(
                                                                                detail
                                                                                    .datetimepost,
                                                                                // "20 min.",
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors
                                                                                        .grey
                                                                                        .shade600),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed: () {},
                                                                      icon: Icon(
                                                                        Icons.share,
                                                                        color: Colors
                                                                            .red,
                                                                      ))
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(detail.posttext,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                          0.7),
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight
                                                                          .w500)
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          SizedBox(
                                                            width: Get.width,
// height: 150,
                                                            child: Container(
                                                              height: 200,
                                                              child: Image.network(
                                                                detail.postImageUrl,
                                                                fit: BoxFit.fitWidth,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .all(
                                                                8.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          Get.to(() =>
                                                                              Like(
                                                                                postdetail: detail,));
                                                                        },
                                                                        child: Text(
                                                                            "${detail
                                                                                .likecount} Likes")),
                                                                    Text("${detail
                                                                        .commentcount} Comments"),
                                                                  ],
                                                                ),
                                                                Divider(),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .spaceAround,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 8,),
                                                                        IconButton(
                                                                            onPressed: () async {
                                                                              _.likepost(
                                                                                  postid: detail
                                                                                      .id,
                                                                                  uid: user!
                                                                                      .uid,
                                                                                  likes: detail
                                                                                      .likes,
                                                                                  likeusername: userdetail
                                                                                      .firstName,
                                                                                  likeuserimageurl: userdetail
                                                                                      .profileImageUrl);
                                                                              // await _.addLikesToFirestore(postid: detail.id, likeusername: userdetail.name, likeuserimageurl: userdetail.profileImageUrl);
                                                                            },
                                                                            icon: detail
                                                                                .likes
                                                                                .contains(
                                                                                user!
                                                                                    .uid)
                                                                                ? const Icon(
                                                                              MdiIcons
                                                                                  .thumbUp,
                                                                              color: Colors
                                                                                  .red,)
                                                                                : const Icon(
                                                                              MdiIcons
                                                                                  .thumbUp,
                                                                              color: Colors
                                                                                  .grey,)

                                                                        ),
                                                                        Text("Like",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .grey),),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,),
                                                                    Row(
                                                                      children: [
                                                                        IconButton(
                                                                            onPressed: () {
                                                                              Get.to(
                                                                                  CommentMeScreen(
                                                                                    postdetail: detail,
                                                                                    userdetail: userdetail,));
                                                                            },
                                                                            icon: Icon(
                                                                              MdiIcons
                                                                                  .comment,
                                                                              color: Colors
                                                                                  .grey,)),
                                                                        Text(
                                                                          "Comments",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .grey),),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,),
                                                                    Row(
                                                                      children: [
                                                                        IconButton(
                                                                            onPressed: () {},
                                                                            icon: Icon(
                                                                              MdiIcons
                                                                                  .share,
                                                                              color: Colors
                                                                                  .grey,)),
                                                                        Text("Share",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .grey),),
                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                                // Row(
                                                                //   mainAxisAlignment:
                                                                //   MainAxisAlignment.spaceBetween,
                                                                //   children: [
                                                                //     IconButton(
                                                                //         onPressed: () {},
                                                                //         icon: Icon(
                                                                //           Icons.thumb_up_alt_outlined,
                                                                //           color: Colors.red,
                                                                //         )),
                                                                //     Text("12 Comments"),
                                                                //   ],
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (
                                                    BuildContext context,
                                                    int index) {
                                                  return Container(
                                                    width: Get.width,
                                                    height: 12,
                                                    color: Colors.grey.shade300,
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            return Center(
                                              child: Text("Nothing To Show"),
                                            );
                                          }
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text("${snapshot.error}"),
                                          );
                                        } else {
                                          return Center(
                                            child: Text("Please wiat"),
                                          );
                                        }
                                      });
                                }),


                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );

        });
  }
}
