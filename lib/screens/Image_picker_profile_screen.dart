import 'package:exd_social_app/Widgets/text_button_widget.dart';
import 'package:exd_social_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_screen_controller.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ImagePickerProfileScreen extends StatelessWidget {
  const ImagePickerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return GetBuilder<ImagePickerController>(
        init: ImagePickerController(),
        builder: (controller) {
          id:
          controller.imageUpdateKey;
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.cyan,
                title: Text("Pick Profile And Cover Photo",style: TextStyle(fontSize: 16),),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await Get.to(() => HomeScreen());
                    },
                    child: Text("Home",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white,fontSize:14)),
                  )
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GetBuilder<ImagePickerController>(
                        builder: (logic) {
                          logic.coverUpdateKey;
                          return GestureDetector(
                            onTap: () async {
                              await logic.pickCoverImage(context);
                            },
                            child: Container(
                                width: 250,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
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
                                child: logic.coverFile != null ? Image.file(
                                  logic.coverFile!, fit: BoxFit.cover,)
                                    : Center(
                                    child: IconButton(onPressed: () async {
                                      await logic.pickCoverImage(
                                          context);
                                    },
                                      icon: Center(child: Icon(
                                          Icons.image, color: Colors.white,
                                          size: 60)),))),
                          );
                        }),
                    SizedBox(height: 30),
                    TextButtonWidget(
                      btnname: "Upload Cover Image", onpressed: () async {
                      await controller.uploadCoverImageToFirebase(context);
                    },),
                    SizedBox(height: 30),
                    GetBuilder<ImagePickerController>(

                        builder: (logic) {
                          logic.imageUpdateKey;
                      return GestureDetector(
                        onTap: () async {
                          await logic.pickUserProfileImage(context);
                        },
                        child: Container(
                            width: 250,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
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
                            child: logic.imageFile != null ? Image.file(
                              logic.imageFile!, fit: BoxFit.cover,)
                                : Center(
                                child: IconButton(onPressed: () async {
                                  await logic.pickUserProfileImage(
                                      context);
                                },
                                  icon: Center(child: Icon(
                                      Icons.image, color: Colors.white,
                                      size: 60)),))),
                      );
                    }),
                    SizedBox(height: 30),
                    TextButtonWidget(
                      btnname: "Upload profile Image", onpressed: () async {
                      await controller.uploadImageToFirebase(context);
                    },)
                  ],
                ),
              )
          );
        });
  }
}

// Stack(
//   clipBehavior: Clip.none,
//   children: [
//     GetBuilder<ImagePickerController>(
//         id: logic.coverUpdateKey,
//         builder: (_) {
//           return GestureDetector(
//             onTap: () async {
//               await _.pickCoverImage(context);
//             },
//             child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 200,
//                 decoration: BoxDecoration(
//                     color: Colors.grey.shade400,
//                     border: Border.all(
//                         color: Colors.grey, width: 1),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey,
//                         offset: const Offset(
//                           5.0,
//                           5.0,
//                         ),
//                         blurRadius: 10.0,
//                         spreadRadius: 2.0,
//                       ),
//                     ]),
//                 child: _.coverFile != null
//                     ? Image.file(
//                         _.coverFile!,
//                         fit: BoxFit.cover,
//                       )
//                     : Center(
//                         child: IconButton(
//                         onPressed: () async {
//                           await _.pickCoverImage(context);
//                         },
//                         icon: Center(
//                             child: Icon(
//                                 Icons.camera_alt_outlined,
//                                 color: Colors.white,
//                                 size: 60)),
//                       ))),
//           );
//         }),
//     Positioned(
//       left: 10,
//       top: 125,
//       child: GetBuilder<ImagePickerController>(
//           id: logic.imageUpdateKey,
//           builder: (log) {
//             return GestureDetector(
//                 onTap: () async {
//                   await log.pickUserProfileImage(context);
//                 },
//                 child: ClipRRect(
//                   borderRadius:
//                       BorderRadius.circular(120),
//                   child: SizedBox(
//                     width: 120,
//                     height: 120,
//                     child: log.imageFile != null
//                         ? Image.file(
//                             log.imageFile!,
//                             fit: BoxFit.cover,
//                           )
//                         : Container(
//                             color: Colors.grey.shade300,
//                             child: Icon(
//                                 Icons
//                                     .account_circle_outlined,
//                                 size: 42,
//                                 color: Colors.white)),
//                   ),
//                 ));
//           }),
//     ),
//     Positioned(
//         left: 110,
//         top: 182,
//         child: Container(
//           height: 38,
//           width: 38,
//           decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius:
//                   BorderRadius.all(Radius.circular(38))),
//           child: IconButton(
//             onPressed: () async {
//               await logic.pickUserProfileImage(context);
//               // await logic.uploadImagetoFirebasestorage(context);
//             },
//             icon: Center(
//                 child: Icon(
//               Icons.camera_alt,
//               color: Colors.black.withOpacity(0.8),
//               size: 24,
//             )),
//           ),
//         )),
//     Positioned(
//         right: 10,
//         top: 5,
//         child: TextButton(
//           onPressed: () async {
//             await logic.pickCoverImage(context);
//           },
//           child: Text(
//             "Edit Cover Photo",
//             style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.blue.withOpacity(0.6),
//                 fontWeight: FontWeight.bold),
//           ),
//         )),
//   ],
// ),