import 'package:exd_social_app/Models/users_model.dart';
import 'package:exd_social_app/Widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Models/user_model.dart';
import '../controller/create_post_controller.dart';
import 'home_screen.dart';


class CreatePostScreen extends StatefulWidget {
  final UserProfileModel userdetail;

  CreatePostScreen({Key? key, required this.userdetail}) : super(key: key);
  TextEditingController postController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(
        init:CreatePostController(),
        builder: (logic) {
          id:
          logic.postImageUpdateKey;
      return Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          title: Text("Create Post Page"),
          backgroundColor: Colors.cyan,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200),
              onPressed: () {
                // _.uploadImageToFirebase(context);
                logic.addPostToFirestore(posttext:logic.posttextcontroller.text,
                    userimageurl: widget.userdetail.profileImageUrl,
                    username: widget.userdetail.firstName);
                FocusScope.of(context).unfocus();
                Get.to(const HomeScreen());
              },
              child: const Text('Post',style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold),),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.cyan,
                    // child: Row(
                    //   children: [
                    //     IconButton(onPressed: () {
                    //       Get.to(() => HomeScreen());
                    //     },
                    //         icon: const Icon(
                    //           Icons.arrow_back, color: Colors.white,)),
                    //     const Text('Create Post', style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 24,
                    //       fontWeight: FontWeight.w600,
                    //     ),),
                    //     const Spacer(),
                    //     ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //           backgroundColor: Colors.lightBlueAccent),
                    //       onPressed: () {
                    //         // _.uploadImageToFirebase(context);
                    //         logic.addPostToFirestore(
                    //             posttext: logic.posttextcontroller.text,
                    //             userimageurl: widget.userdetail.profileImageUrl,
                    //             username: widget.userdetail.name);
                    //
                    //         Get.to(const HomeScreen());
                    //       },
                    //       child: const Text('Post'),
                    //     )
                    //   ],
                    // ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.cyan.shade300,
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.userdetail.profileImageUrl),
                              fit: BoxFit.cover)),
                    ),
                    // Image.network(widget.userdetail.profileImageUrl),
                    // 'https://upload.wikimedia.org/wikipedia/commons/4/44/Facebook_Logo.png'),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(widget.userdetail.firstName, style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          // color:Colors.lightBlueAccent,
                          color: Colors.red.withOpacity(0.7),
                      ),),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.cyan),
                              onPressed: () {},
                              icon: const Icon(Icons.group),
                              label: Row(
                                children: const [
                                  Text('Friends'),
                                  Expanded(
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.cyan),
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: Row(
                                children: const [
                                  Text('Album'),
                                  Expanded(
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextInputField(
                        hinttext: 'What\'s on your Mind?',
                        maxline: 5,
                        label: "Enter Post text...",
                        mycontroller: logic.posttextcontroller),
                  ),
                  // TextFormField(
                  //   maxLines: 5,
                  //   decoration: const InputDecoration(
                  //     border: InputBorder.none,
                  //     hintText: 'What\'s on your Mind?',
                  //     hintStyle: TextStyle(fontSize: 20),
                  //   ),
                  //   controller: _.posttextcontroller,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        logic.pickPostImage(context);
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                          width: Get.width,
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              border: Border.all(
                                  color: Colors.cyan, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  // offset: const Offset(
                                  //   3.0,
                                  //   3.0,
                                  // ),
                                  blurRadius: 2.0,
                                  spreadRadius: 0.5,
                                ),
                              ]),
                          child: logic.postImageFile != null ? Image.file(
                            logic.postImageFile!, fit: BoxFit.cover,)
                              : Center(
                              child: IconButton(onPressed: () async {
                                await logic.pickPostImage(
                                    context);
                                FocusScope.of(context).unfocus();
                              },
                                icon: Center(child: Icon(
                                    Icons.image, color: Colors.white,
                                    size: 60)),))),
                      // Container(
                      //     height: 200,
                      //     width: MediaQuery.of(context).size.width,
                      //     color: Colors.grey,
                      //     child: _.imageFile != null
                      //         ?
                      //     Image.file(
                      //       _.imageFile!,fit: BoxFit.fill,
                      //     )
                      //         :
                      //     const Icon(MdiIcons.camera,size: 35,color: Colors.black,)
                      // ),
                    ),
                  ),
                ],
              ),

        ),
      );
    });
  }
}
