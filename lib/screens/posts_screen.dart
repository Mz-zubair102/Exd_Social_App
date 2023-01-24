import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controller/Posts_Screen_Controller.dart';
import 'package:exd_social_app/controller/profile_screen_controller.dart';
import 'package:exd_social_app/screens/Image_picker_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
import 'create_post_screen.dart';
import 'crete_comment_screen.dart';
import 'home_screen.dart';
import 'likes_Screen----.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class PostsScreen extends StatefulWidget {
  final UserProfileModel userdetails;


  const PostsScreen({Key? key, required this.userdetails,}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  CollectionReference postRefrence =
  FirebaseFirestore.instance.collection("post");
  CollectionReference uerRefrence =
  FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      // _isLiked=(likes[user!.uid]==true);
    return GetBuilder<PostsScreenController>(
        init: PostsScreenController(),
        builder: (_) {
      return FutureBuilder(
          future: uerRefrence.doc(user!.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              return Center(child: Text("Document does not exist"));
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              ///------------With Model--------------------------///
              // Map<String, dynamic> data =
              // snapshot.data!.data() as Map<String, dynamic>;
              // UsersModel userdetail = UsersModel.fromJson(
              //     data, snapshot.data!.id);
              UserProfileModel userdetail=UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data!);
              // UserProfileModel detail=UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data);
              return SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Divider(
                              height: 5, color: Colors.grey, thickness: 3,))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ProfileScreen());
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.cyan.shade300,
                                              image: DecorationImage(
                                                  image: NetworkImage(userdetail
                                                      .profileImageUrl),
                                                  fit: BoxFit.cover)),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() =>
                                                    CreatePostScreen(
                                                        userdetail: userdetail));
                                              },
                                              child: Container(
                                                height: 36,
                                                width: 260,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(left: 20,
                                                      top: 8.0,
                                                      bottom: 8.0,
                                                      right: 8.0),
                                                  child: Text(
                                                    "what's on your mind?",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight
                                                            .w500),),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    border: Border.all(width: 1,
                                                      color: Colors.grey
                                                          .shade500,),
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(10))
                                                ),
                                              ),
                                            )
                                            // Text(
                                            //   widget.userdetail.name,
                                            //   style: TextStyle(
                                            //       color: Colors.black,
                                            //       fontSize: 20,
                                            //       fontWeight: FontWeight.bold),
                                            // ),
                                            // Text(
                                            //   widget.userdetail.email,
                                            //   style: TextStyle(
                                            //       color: Colors.lightBlueAccent,
                                            //       fontSize: 16),
                                            // ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.to(() =>
                                        CreatePostScreen(
                                          userdetail: userdetail,
                                        ));
                                  },
                                  icon: Icon(Icons.photo_library_sharp,
                                      color: Colors.green, size: 30))
                            ],
                          ),
                        ),
                        SizedBox(
                            child: Container(
                              width: Get.width,
                              height: 12,
                              color: Colors.grey.shade400,
                            )),
                        StreamBuilder<QuerySnapshot>(
                            stream: postRefrence.orderBy("datetimepost",descending: true).snapshots(),
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

                                  // CommentModel detail=snapshot.data![index];
                                  // UserModel detail=UserModel.fromDocumentSnapshot(snapshot: snapshot.data!.docs[index]);
                                  // return Text("Full Name: ${detail.name} ${data['name']}");
                                  // Map<String, dynamic> data =
                                  // snapshot.data!.data() as Map<String, dynamic>;
                                  // postModel detail =
                                  // postModel.fromJson(data, snapshot.data!.id);
                                  return Container(
                                    child: ListView.separated(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> doc = snapshot
                                            .data!.docs[index].data() as Map<
                                            String,
                                            dynamic>;
                                        String docId = snapshot.data!
                                            .docs[index].id;
                                        PostModel detail = PostModel.fromJson(
                                            doc, docId);
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                                              detail.userImageUrl),
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
                                                              color: Colors.red,
                                                            ))
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(detail.posttext,
                                                        style: TextStyle(
                                                            color: Colors.black
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
                                                  padding: const EdgeInsets.all(
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
                                                                  "${detail.likecount} Likes")),
                                                          Text("${detail.commentcount} Comments"),
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
                                                                      onPressed: ()async{
                                                                         _.likepost(postid: detail.id, uid: user!.uid, likes: detail.likes, likeusername: userdetail.firstName, likeuserimageurl: userdetail.profileImageUrl);
                                                                         // await _.addLikesToFirestore(postid: detail.id, likeusername: userdetail.name, likeuserimageurl: userdetail.profileImageUrl);
                                                                      },
                                                                  icon:detail.likes.contains(user!.uid)
                                                                      ? const Icon(
                                                                    MdiIcons
                                                                        .thumbUp,
                                                                    color: Colors
                                                                        .red,)
                                                                      :const Icon(
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
                                                          SizedBox(width: 8,),
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
                                                              Text("Comments",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),),
                                                            ],
                                                          ),
                                                          SizedBox(width: 8,),
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
                                      separatorBuilder: (BuildContext context,
                                          int index) {
                                        return Container(
                                          width: Get.width,
                                          height: 12,
                                          color: Colors.grey.shade400,
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
                            })
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          });
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Divider(
                    height: 5, color: Colors.grey, thickness: 3,))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ProfileScreen());
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.cyan.shade300,
                                    image: DecorationImage(
                                        image: NetworkImage(widget
                                            .userdetails.profileImageUrl),
                                        fit: BoxFit.cover)),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userdetails.firstName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Text("20 min."),
                                  Text(
                                    widget.userdetails.metadata.email,
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(() =>
                              CreatePostScreen(
                                userdetail: widget.userdetails,
                              ));
                        },
                        icon: Icon(CupertinoIcons.add_circled_solid,
                            color: Colors.lightBlueAccent.shade200, size: 32))
                  ],
                ),
              ),
              SizedBox(
                  child: Container(
                    width: Get.width,
                    height: 12,
                    color: Colors.grey.shade400,
                  )),
              FutureBuilder<QuerySnapshot>(
                  future: postRefrence.get(),
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
                        // CommentModel detail=snapshot.data![index];
                        // UserModel detail=UserModel.fromDocumentSnapshot(snapshot: snapshot.data!.docs[index]);
                        // return Text("Full Name: ${detail.name} ${data['name']}");
                        // Map<String, dynamic> data =
                        // snapshot.data!.data() as Map<String, dynamic>;
                        // postModel detail =
                        // postModel.fromJson(data, snapshot.data!.id);
                        return Container(
                          child: ListView.separated(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> doc = snapshot.data!
                                  .docs[index].data() as Map<String, dynamic>;
                              String docId = snapshot.data!.docs[index].id;
                              PostModel detail = PostModel.fromJson(doc, docId);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                                                .cyan.shade300,
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
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            detail.username,
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          Text(
                                                            "20 min.",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey
                                                                    .shade800),
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
                                                    color: Colors.red,
                                                  ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(detail.posttext),
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
                                            widget.userdetails.coverImageUrl,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("12 Likes"),
                                                Text("12 Comments"),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons
                                                          .thumb_up_alt_outlined,
                                                      color: Colors.red,
                                                    )),
                                                Text("12 Comments"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context,
                                int index) {
                              return Container(
                                width: Get.width,
                                height: 12,
                                color: Colors.grey.shade400,
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:exd_social_app/Screens/profile_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../Models/user_model.dart';
// import 'create_post_screen.dart';
//
// class PostsScreen extends StatefulWidget {
//   final UsersModel userdetail;
//   CollectionReference postRefrence = FirebaseFirestore.instance.collection("post");
//   PostsScreen({Key? key, required this.userdetail}) : super(key: key);
//
//   @override
//   State<PostsScreen> createState() => _PostsScreenState();
// }
//
// class _PostsScreenState extends State<PostsScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           Get.to(() => ProfileScreen());
//                         },
//                         child: Container(
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 50,
//                                 height: 50,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.cyan.shade300,
//                                     image: DecorationImage(
//                                         image: NetworkImage(widget
//                                             .userdetail.profileImageUrl),
//                                         fit: BoxFit.cover)),
//                               ),
//                               const SizedBox(
//                                 width: 8,
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     widget.userdetail.name,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   // Text("20 min."),
//                                   Text(
//                                     widget.userdetail.email,
//                                     style: TextStyle(
//                                         color: Colors.lightBlueAccent,
//                                         fontSize: 16),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                         onPressed: () {
//                           Get.to(() => CreatePostScreen(
//                                 userdetail: widget.userdetail,
//                               ));
//                         },
//                         icon: Icon(CupertinoIcons.add_circled_solid,
//                             color: Colors.lightBlueAccent.shade200, size: 32))
//                   ],
//                 ),
//               ),
//             ),
//
//             Container(
//               child: ListView.separated(
//                 physics: ScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: 20,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(6.0),
//                     child: Container(
//                       width: Get.width,
//                       child: Column(
//                         children: [
//                           Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: 50,
//                                             height: 50,
//                                             decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.cyan.shade300,
//                                                 image: DecorationImage(
//                                                     image: NetworkImage(widget
//                                                         .userdetail
//                                                         .profileImageUrl),
//                                                     fit: BoxFit.cover)),
//                                           ),
//                                           const SizedBox(
//                                             width: 8,
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text("Name",style: TextStyle(fontSize: 19,color:Colors.black,fontWeight: FontWeight.bold),),
//                                               Text("20 min.",style: TextStyle(fontSize:14,color:Colors.grey.shade800),)
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   IconButton(
//                                       onPressed: () {},
//                                       icon: Icon(
//                                         Icons.share,
//                                         color: Colors.red,
//                                       ))
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Text(
//                                   "For information on the generic Dart part of this file, see the For information on the generic Dart part of this file, see the For information on the generic Dart part of this file, see the For information on the generic Dart part of this file, see the "),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           SizedBox(
//                             width: Get.width,
// // height: 150,
//                             child: Container(
//                               height: 200,
//                               child: Image.network(
//                                 widget.userdetail.coverImageUrl,
//                                 fit: BoxFit.fitWidth,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("12 Likes"),
//                                     Text("12 Comments"),
//                                   ],
//                                 ),
//                                 Divider(),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     IconButton(
//                                         onPressed: () {},
//                                         icon: Icon(
//                                           Icons.thumb_up_alt_outlined,
//                                           color: Colors.red,
//                                         )),
//                                     Text("12 Comments"),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 separatorBuilder: (BuildContext context, int index) {
//                   return Container(
//                     width: Get.width,
//                     height: 12,
//                     color: Colors.grey.shade400,
//                   );
//                 },
//               ),
//             )
//             // ListView.builder(
//             //     physics: ScrollPhysics(),
//             //     shrinkWrap: true,
//             //     itemCount: widget.callslist.length,
//             //     itemBuilder: (context,int index){
//             //       CallsModel callslistpass=widget.callslist[index];
//             //       return WhtsAppCallScreenListTile(callsdetail: callslistpass);
//             //     }),
//           ],
//         ),
//       ),
//     ));
//   }
// }
