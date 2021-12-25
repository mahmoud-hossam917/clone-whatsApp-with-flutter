import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whats_project/calls.dart';
import 'package:whats_project/chatscreen.dart';
import 'package:whats_project/homepage.dart';
import 'package:whats_project/login.dart';
import 'package:whats_project/models/chatpage.dart';
import 'package:whats_project/models/modelchat.dart';
import 'package:whats_project/models/selectcontact.dart';
import 'package:whats_project/signup.dart';
import 'package:whats_project/status.dart';

bool islogin = false;
var userid, orid;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    islogin = true;
    userid = await FirebaseFirestore.instance
        .collection('chat')
        .where('email', isEqualTo: user.email)
        .get();
    if (userid.docs.length > 0) orid = userid.docs[0].id;
  }
  runApp(myapp());
}

class myapp extends StatelessWidget {
  ChatModel ch = new ChatModel();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (islogin)
          ? Homepage(
              usid: orid,
            )
          : Login(),
      theme: ThemeData(primaryColor: Colors.red, focusColor: Colors.red),
      routes: {
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "signup": (context) => Signup(),
        "status": (context) => Status(),
        "calls": (context) => Calls(),
        "chatpage": (context) => ChatPage(chat: ch),
        "selectcontact": (context) => SelectContact()
      },
    );
  }
}
