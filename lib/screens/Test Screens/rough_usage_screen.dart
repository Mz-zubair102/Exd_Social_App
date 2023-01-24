import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controller/chat_Users_list_screen_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersInfo extends StatefulWidget {
  const UsersInfo({Key? key}) : super(key: key);

  @override
  State<UsersInfo> createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {
  final auth = FirebaseAuth.instance;
  CollectionReference uerRefrence =
  FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Users Info"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

            // StreamBuilder<QuerySnapshot>(
            // stream: _usersStream,
            //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Something went wrong');
            //     }
            //
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Text("Loading");
            //     }
            //
            //     return ListView(
            //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
            //         Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            //         return ListTile(
            //           title: Text(data['firstName']),
            //           subtitle: Text(data['metadata.name']),
            //         );
            //       }).toList(),
            //     );
            //   },
            // ),
            FutureBuilder<DocumentSnapshot>(
            future: userReference.doc("1QCcYJofLheIdlMnfOlWhsSTWki2").get(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return Text("Full Name: ${data['firstName']} ${data['metadata\.${"name"}']}");
              }

              return Text("loading");
            },
        )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
