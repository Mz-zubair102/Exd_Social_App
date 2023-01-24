import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/Models/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/likes_model.dart';

class LikesTabScreen extends StatefulWidget {
  final PostModel? postdetail;
  const LikesTabScreen({Key? key,  this.postdetail}) : super(key: key);

  @override
  State<LikesTabScreen> createState() => _LikesTabScreenState();
}

class _LikesTabScreenState extends State<LikesTabScreen> {
  CollectionReference likeRefrence =
  FirebaseFirestore.instance.collection("likes");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: likeRefrence
                  .where("postid", isEqualTo: widget.postdetail!.id)
                  .get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Scaffold(
                body: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    // itemCount: 5,
                    itemBuilder: (context, int index) {
                      Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      String docId=snapshot.data!.docs[index].id;
                      LikesModel detail=LikesModel.fromJson(doc, docId);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () async {
                              // Display the image in large form.
                              // print("Likes Clicked");
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 45.0,
                                  width: 45.0,
                                  decoration:  BoxDecoration(
                                      color: Colors.cyan.shade300,
                                      borderRadius: const BorderRadius.all( Radius.circular(45))),
                                  child:  CircleAvatar(
                                      radius: 50,
                                      // backgroundImage: AssetImage("Assets/FirebaseLogo.png"),
                                      backgroundImage: NetworkImage(detail.userImageUrl)
                                  ),
                                ),
                                Positioned(
                                    left: 25,
                                    bottom: -5,
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration:const BoxDecoration(
                                          color: Colors.cyan,
                                          borderRadius:BorderRadius.all(
                                              Radius.circular(25))),
                                      child: Center(
                                          child: Icon(
                                            CupertinoIcons.hand_thumbsup_fill,
                                            color: Colors.red.withOpacity(0.8),
                                            size: 20,
                                          )),
                                    ))
                              ],
                            ),
                          ),
                          title: Text(
                            // "Abdullah",
                            detail.likeusername,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text(
                          //   detail.commenttext,
                          //   // data[i]['message']
                          //   style: TextStyle(fontSize: 14),
                          // ),
                          trailing:  Text(
                            // "17/01/2023",
                              detail.likedatetime,
                              style:  TextStyle(color:Colors.grey,fontSize: 13,fontWeight: FontWeight.bold)
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return const Center(
                child: Text("Nothing To Show"),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            return const Center(
              child: Text("Please wiat"),
            );
          }
      }
    );
  }
}
