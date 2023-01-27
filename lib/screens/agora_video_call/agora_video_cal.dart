import 'package:agora_uikit/agora_uikit.dart';
import 'package:exd_social_app/screens/chat/rooms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class AgoraVideoCall extends StatefulWidget {
  final types.Room? room;
  const AgoraVideoCall({Key? key, this.room}) : super(key: key);

  @override
  State<AgoraVideoCall> createState() => _AgoraVideoCallState();
}

class _AgoraVideoCallState extends State<AgoraVideoCall> {
late final AgoraClient client;
  // final AgoraClient client = AgoraClient(
  //   agoraConnectionData: AgoraConnectionData(
  //     appId: "7f7278c4cbee43328c68950d21fa27e6",
  //     channelName: "test",
  //     username: "user",
  //   ),
  // );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    client=AgoraClient(agoraConnectionData: AgoraConnectionData(
      appId: "7f7278c4cbee43328c68950d21fa27e6",
      channelName: widget.room!.id,
    ));
    await client.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Agora VideoUIKit'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        // leading: IconButton(
        //   onPressed: (){
        //     Get.back;
        //   },
        //   icon: Icon(Icons.arrow_back,size: 32,color: Colors.white),
        // ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
            // showAVState: true,
            //   showNumberOfUsers: true,
            //   floatingLayoutContainerHeight: 200,
            //   floatingLayoutContainerWidth: 200,
            //   floatingLayoutMainViewPadding: EdgeInsets.all(8),
            //   disabledVideoWidget: Container(
            //     decoration: BoxDecoration(
            //         color: Colors.cyan,
            //       image: DecorationImage(
            //         image: NetworkImage(widget.room!.imageUrl.toString()),
            //         fit:BoxFit.fill
            //       )
            //     ),
            //   ),
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              autoHideButtons: true,
              autoHideButtonTime:10,
              client: client,
            ),
          ],
        ),
      ),
    );
  }
}
