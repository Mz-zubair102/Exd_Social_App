import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/screens/agora_video_call/agora_video_cal.dart';
import 'package:exd_social_app/screens/chat/rooms.dart';
import 'package:exd_social_app/screens/Test%20Screens/rough_usage_screen.dart';
import 'package:exd_social_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';

import 'Screens/chat/chat.dart';
import 'Screens/home_screen.dart';
import 'Screens/login_screen.dart';
import 'firebase_options.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  print("Handling a background message: ${message.messageId}");
}
getFcmToken()async{
  String? token=await FirebaseMessaging.instance.getToken();
  print("FCMTOken: $token");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await getFcmToken();
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
  alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if(settings.authorizationStatus == AuthorizationStatus.authorized){
    print("user grant permission");
  }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
    print("user grant provisional permission");
  }else{
    print("user declined or has no accepted permission");
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState(){
    // ToDO:implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      //   debugPrint("onMessage:");
      // // log("onMessage: $message");
      // print("onMessage: $message");
      // final snackBar = SnackBar(content: Text(message.notification?.title??""));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (message.notification != null) {
        message.notification!.title;
        Get.snackbar(onTap: (snack) {
          Map<String, dynamic> data = message.data;

          if (data["isNotify"] == 0) {
            Get.to(ChatPage(
              room: data["room"],
            ));
          }
        },
            "${message.notification!.title.toString().capitalizeFirst}",
            "${message.notification!.body.toString()}",
            backgroundGradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 248, 101, 148),
                Color.fromARGB(255, 255, 202, 166),
              ],
            ));
        // print('Message also contained a notification: ${message.notification!.toMap()}');
        print('Message also contained a notification: ${message.notification!.title}');
      }
    });
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();
  //
  //   print("Handling a background message: ${message.messageId}");
  // }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:SplashScreen(),
    );
  }
}

