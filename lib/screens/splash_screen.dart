
import 'dart:async';

import 'package:exd_social_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'Test Screens/firebase_screen.dart';
import 'Image_picker_profile_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void Nextscreen(BuildContext context) {
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;
    if(user!=null){
      Timer(const Duration(seconds: 6), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }else{
      Timer(const Duration(seconds: 6), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Nextscreen(context);
  }

  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage("Assets/FirebaseLogo.png"),height: 150,width: 200,),
              SizedBox(height: 10,),
              Text("Firebase App",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.amber),)
            ],
          ),
        )
    ));
  }
}
