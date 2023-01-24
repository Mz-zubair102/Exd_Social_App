import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:exd_social_app/Models/users_model.dart';
import 'package:exd_social_app/controller/create_comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../Models/comment_model.dart';
import '../Models/post_model.dart';
import '../Models/user_model.dart';

class CommentMeScreen extends StatefulWidget {
  final PostModel? postdetail;
  final UserProfileModel? userdetail;
  const CommentMeScreen({Key? key, this.postdetail,this.userdetail}) : super(key: key);
  @override
  _CommentMeScreenState createState() => _CommentMeScreenState();
}

class _CommentMeScreenState extends State<CommentMeScreen> {
  final formKey = GlobalKey<FormState>();
  CollectionReference commentRefrence =
  FirebaseFirestore.instance.collection("comment");
  final TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateCommentController>(
        init:CreateCommentController(),
        builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Comment Page"),
          backgroundColor: Colors.cyan,
        ),
        body: Container(
          child: CommentBox(
            userImage: CommentBox.commentImageParser(
                imageURLorPath: widget.userdetail?.profileImageUrl),
            // child: commentChild(filedata),
            labelText: 'Write a comment...',
            errorText: 'Comment cannot be blank',
            withBorder: false,
            sendButtonMethod: () {
              if (formKey.currentState!.validate()) {
                _.addCommentToFirestore(commenttext: _.commenttextcontroller.text, profileImageUrl:widget.userdetail!.profileImageUrl, username: widget.userdetail!.firstName, postid: widget.postdetail!.id, datetimepost: widget.postdetail!.datetimepost);
                print(_.commenttextcontroller.text);
                // _.Commentcount(widget.postdetail!.id);
                // _.getcomments(widget.postdetail?.id);
                // setState(() {
                //   var value = {
                //     'name': widget.postdetail?.username,
                //     'pic':  widget.postdetail?.userImageUrl,
                //     'message': _.commenttextcontroller.text,
                //     'date': '2021-01-01 12:00:00'
                //   };
                //   filedata.insert(0, value);
                // });
                _.commenttextcontroller.clear();
                FocusScope.of(context).unfocus();
              } else {
                print("Not validated");
              }
            },
            formKey: formKey,
            commentController:_.commenttextcontroller,
            backgroundColor: Colors.cyan,
            textColor: Colors.white,
            sendWidget: const Icon(Icons.send_sharp, size: 30, color: Colors.white),
            child: StreamBuilder<QuerySnapshot>(
                stream: commentRefrence
                    .where("postid", isEqualTo: widget.postdetail!.id).orderBy("datetimecomment",descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, int index) {
                            Map<String,dynamic> doc=snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            String docId=snapshot.data!.docs[index].id;
                            CommentModel detail=CommentModel.fromJson(doc, docId);
                           return Padding(
                             padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                             child: ListTile(
                               leading: GestureDetector(
                                 onTap: () async {
                                   // Display the image in large form.
                                   print("Comment Clicked");
                                 },
                                 child: Container(
                                   height: 50.0,
                                   width: 50.0,
                                   decoration: new BoxDecoration(
                                       color: Colors.cyan,
                                       borderRadius: new BorderRadius.all(const Radius.circular(50))),
                                   child: CircleAvatar(
                                       radius: 50,
                                       backgroundImage: CommentBox.commentImageParser(
                                         imageURLorPath:detail.userImageUrl
                                           // imageURLorPath: data[i]['pic']
                                       )
                                   ),
                                 ),
                               ),
                               title: Text(
                                 detail.username,
                                 // data[i]['name'],
                                 style: const TextStyle(fontWeight: FontWeight.bold),
                               ),
                               subtitle: Text(
                                 detail.commenttext,
                                   // data[i]['message']
                                 style: TextStyle(fontSize: 14),
                               ),
                               trailing: Text(
                                 detail.datetimecomment,
                                   // data[i]['date'],
                                   style: const TextStyle(color:Colors.grey,fontSize: 13,fontWeight: FontWeight.bold)
                               ),
                             ),
                           );
                          });
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
                }),
          ),
        ),
      );
    });
  }
}

// List filedata = [
//   {
//     'name': 'Chuks Okwuenu',
//     'pic': 'https://picsum.photos/300/30',
//     'message': 'I love to code',
//     'date': '2021-01-01 12:00:00'
//   },
//   {
//     'name': 'Biggi Man',
//     'pic': 'https://www.adeleyeayodeji.com/img/IMG_20200522_121756_834_2.jpg',
//     'message': 'Very cool',
//     'date': '2021-01-01 12:00:00'
//   },
//   {
//     'name': 'Tunde Martins',
//     'pic': 'assets/img/userpic.jpg',
//     'message': 'Very cool',
//     'date': '2021-01-01 12:00:00'
//   },
//   {
//     'name': 'Biggi Man',
//     'pic': 'https://picsum.photos/300/30',
//     'message': 'Very cool',
//     'date': '2021-01-01 12:00:00'
//   },
// ];
//
// Widget commentChild(data) {
//   return ListView(
//     children: [
//       for (var i = 0; i < data.length; i++)
//         Padding(
//           padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
//           child: ListTile(
//             leading: GestureDetector(
//               onTap: () async {
//                 // Display the image in large form.
//                 print("Comment Clicked");
//               },
//               child: Container(
//                 height: 50.0,
//                 width: 50.0,
//                 decoration: new BoxDecoration(
//                     color: Colors.cyan,
//                     borderRadius: new BorderRadius.all(Radius.circular(50))),
//                 child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: CommentBox.commentImageParser(
//                         imageURLorPath: data[i]['pic'])),
//               ),
//             ),
//             title: Text(
//               data[i]['name'],
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(data[i]['message']),
//             trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
//           ),
//         )
//     ],
//   );
// }