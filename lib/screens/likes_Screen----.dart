import 'package:exd_social_app/Models/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../controller/Posts_Screen_Controller.dart';
import 'home_screen.dart';
import 'likes_tab_screen-------.dart';

class Like extends StatefulWidget {
  final PostModel postdetail;
   Like({Key? key,required this.postdetail}) : super(key: key);

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsScreenController>(
        init:PostsScreenController(),
        builder: (_) {
          return DefaultTabController(
              length: 1,
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    elevation: 5,
                    backgroundColor: Colors.cyan,
                    title: const Text("Likes Screen"),
                    actions: [
                      // IconButton(
                      //     onPressed: () {}, icon: Icon(Icons.search)),
                    ],
                    bottom: const TabBar(indicatorColor: Colors.white, tabs: [
                      Tab(
                          // child: Icon(CupertinoIcons.profile_circled,size: 30,)),
                      child: Text("Likes",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900))),
                    ]),
                  ),
                  body:  SafeArea(
                    child: TabBarView(
                      children: [
                        LikesTabScreen(postdetail: widget.postdetail,),
                      ],
                    ),
                  )));;
        });
  }
}
