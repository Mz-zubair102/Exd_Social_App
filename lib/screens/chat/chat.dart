import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../agora_video_call/agora_video_cal.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.room,
  });

  final types.Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;
  // String authKey =
  //     "key=AAAAfahnBCc:APA91bHTlgCgNtUQQF4Rcy9ODRW0TLxW2RuYdHUDfy7JjwpF7FUnzJY_vS1R2AjanwYbxbGo5tWUMWfxQKDJD1ZjWTScnwMSwsVcPljOvTHwh6xk1Q2o0bRV22DXSchFD4kfVJN7kRPY";
  //
  // String token =
  //     "fqDEOHmARh6j0x4ouIroa7:APA91bHNnLTKThB-wT7NCWtsXNcQ_pGPjrKDU_RtVUSNJ3Qcs4HUJqvQfqLBzoh9DeTW7rn5MR_-YhMm7tVQoz5O0iWf7kPvHLZg7uh3j_u1B6xOgrI6qZe7uCHMLQayUXHt0GDYzNK8";
  //
  // String aliToken =
  //     "cII7Bix1T7-flvjIbwmDDf:APA91bERvTq_DIpJBvehZPsY_PAeA5UUwNOh4ZgyOwp0uN-eJI56erwzrnrsiXiFnkt6GwJ2VAlQuGCvXdD-NyqOGll30Kz_jGWLYCra3kyaEpDsFcPOjOUucSOmMyWRPwke83E85tpm";
  // Future<void> messageNotification() async {
  //   Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
  //
  //   Map<String, dynamic> body = {
  //     "to": aliToken,
  //     "notification": {
  //       "title": widget.room.name.toString().capitalizeFirst,
  //       "body": "New Notification"
  //     },
  //     "data": <String, dynamic>{
  //       "room": widget.room,
  //       "title": "Title of Your Notification",
  //       "isNotify": 0
  //     }
  //   };
  //
  //   http.Response response = await http.post(uri,
  //       body: jsonEncode(body),
  //       headers: <String, String>{
  //         "Content-Type": "application/json",
  //         "Authorization": authKey
  //       });
  //
  //   print(response.statusCode);
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: const Text('Chat'),
                centerTitle: true,
                backgroundColor: Colors.cyan,
                actions: [
            IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.phone,color: Colors.white,)),
            IconButton(onPressed: (){
              Get.to(()=>AgoraVideoCall(room: widget.room,));
            }, icon: Icon(CupertinoIcons.video_camera_solid,color: Colors.white,size:32)),
          ],
    ),
    body: StreamBuilder<types.Room>(
      initialData: widget.room,
      stream: FirebaseChatCore.instance.room(widget.room.id),
      builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
        initialData: const [],
        stream: FirebaseChatCore.instance.messages(snapshot.data!),
        builder: (context, snapshot) => Chat(
          isAttachmentUploading: _isAttachmentUploading,
          messages: snapshot.data ?? [],
          onAttachmentPressed: _handleAtachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: types.User(
            id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
          ),
        ),
      ),
    ),
  );

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) async{
    // await messageNotification();
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}









// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:mime/mime.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
//
// class ChatPage extends StatefulWidget {
//   const ChatPage({
//     super.key,
//     required this.room,
//   });
//
//   final types.Room room;
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   bool _isAttachmentUploading = false;
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           systemOverlayStyle: SystemUiOverlayStyle.light,
//           title: const Text('Chat'),
//           actions: [
//             IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.phone,color: Colors.white,)),
//             IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.video_camera_solid,color: Colors.white,)),
//           ],
//         ),
//         body: StreamBuilder<types.Room>(
//           initialData: widget.room,
//           stream: FirebaseChatCore.instance.room(widget.room.id),
//           builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
//             initialData: const [],
//             stream: FirebaseChatCore.instance.messages(snapshot.data!),
//             builder: (context, snapshot) => Chat(
//               isAttachmentUploading: _isAttachmentUploading,
//               messages: snapshot.data ?? [],
//               onAttachmentPressed: _handleAtachmentPressed,
//               onMessageTap: _handleMessageTap,
//               onPreviewDataFetched: _handlePreviewDataFetched,
//               onSendPressed: _handleSendPressed,
//               user: types.User(
//                 id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
//               ),
//             ),
//           ),
//         ),
//       );
//
//   void _handleAtachmentPressed() {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) => SafeArea(
//         child: SizedBox(
//           height: 144,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleImageSelection();
//                 },
//                 child: const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text('Photo'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // _handleFileSelection();
//                 },
//                 child: const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text('File'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text('Cancel'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleFileSelection() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.any,
//     );
//
//     if (result != null && result.files.single.path != null) {
//       _setAttachmentUploading(true);
//       final name = result.files.single.name;
//       final filePath = result.files.single.path!;
//       final file = File(filePath);
//
//       try {
//         final reference = FirebaseStorage.instance.ref(name);
//         await reference.putFile(file);
//         final uri = await reference.getDownloadURL();
//
//         final message = types.PartialFile(
//           mimeType: lookupMimeType(filePath),
//           name: name,
//           size: result.files.single.size,
//           uri: uri,
//         );
//
//         FirebaseChatCore.instance.sendMessage(message, widget.room.id);
//         _setAttachmentUploading(false);
//       } finally {
//         _setAttachmentUploading(false);
//       }
//     }
//   }
//
//   void _handleImageSelection() async {
//     final result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );
//
//     if (result != null) {
//       _setAttachmentUploading(true);
//       final file = File(result.path);
//       final size = file.lengthSync();
//       final bytes = await result.readAsBytes();
//       final image = await decodeImageFromList(bytes);
//       final name = result.name;
//
//       try {
//         final reference = FirebaseStorage.instance.ref(name);
//         await reference.putFile(file);
//         final uri = await reference.getDownloadURL();
//
//         final message = types.PartialImage(
//           height: image.height.toDouble(),
//           name: name,
//           size: size,
//           uri: uri,
//           width: image.width.toDouble(),
//         );
//
//         FirebaseChatCore.instance.sendMessage(
//           message,
//           widget.room.id,
//         );
//         _setAttachmentUploading(false);
//       } finally {
//         _setAttachmentUploading(false);
//       }
//     }
//   }
//
//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;
//
//       if (message.uri.startsWith('http')) {
//         try {
//           final updatedMessage = message.copyWith(isLoading: true);
//           FirebaseChatCore.instance.updateMessage(
//             updatedMessage,
//             widget.room.id,
//           );
//
//           final client = http.Client();
//           final request = await client.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (
//               await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';
//
//           if (!File(localPath).existsSync()) {
//             final file = File(localPath);
//             await file.writeAsBytes(bytes);
//           }
//         } finally {
//           final updatedMessage = message.copyWith(isLoading: false);
//           FirebaseChatCore.instance.updateMessage(
//             updatedMessage,
//             widget.room.id,
//           );
//         }
//       }
//
//       await OpenFilex.open(localPath);
//     }
//   }
//
//   void _handlePreviewDataFetched(
//     types.TextMessage message,
//     types.PreviewData previewData,
//   ) {
//     final updatedMessage = message.copyWith(previewData: previewData);
//
//     FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
//   }
//
//   void _handleSendPressed(types.PartialText message) {
//     FirebaseChatCore.instance.sendMessage(
//       message,
//       widget.room.id,
//     );
//   }
//
//   void _setAttachmentUploading(bool uploading) {
//     setState(() {
//       _isAttachmentUploading = uploading;
//     });
//   }
// }
