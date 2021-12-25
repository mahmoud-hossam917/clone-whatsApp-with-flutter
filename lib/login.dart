import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_project/chatscreen.dart';
import 'package:whats_project/homepage.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AddUserToChat(QuerySnapshot<Map<String, dynamic>> user) async {
    var Response = await FirebaseFirestore.instance
        .collection('chat')
        .where('email', isEqualTo: user.docs[0]['Email'])
        .get();

    if (Response.docs.length < 1) {
      await FirebaseFirestore.instance.collection('chat').add({
        'email': user.docs[0]['Email'],
        'username': user.docs[0]['Username']
      });
    }
    return 0;
  }

  bool state = false;
  var myemail, mypassword;
  final formstate = GlobalKey<FormState>();
  signin() async {
    var formdata = formstate.currentState;
    if (formdata != null) {
      if (formdata.validate()) {
        formdata.save();
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: myemail, password: mypassword);
          return userCredential;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            AwesomeDialog(
                context: context,
                title: "Error",
                body: Text("No user found for that email."))
              ..show();
          } else if (e.code == 'wrong-password') {
            AwesomeDialog(
                context: context,
                title: "Error",
                body: Text("Wrong password provided for that user."))
              ..show();
          }
        }
      } else
        AwesomeDialog(
            context: context, title: "Erorr", body: Text("Not Valid"));
    } else
      AwesomeDialog(context: context, title: "Erorr", body: Text("Not Valid"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 50),
          child: Text(
            "WelcomeApp",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.red[400]),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 50, right: 20),
          child: Text(
            "Login",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formstate,
            child: Column(
              children: [
                TextFormField(
                  autofocus: false,
                  onSaved: (val) {
                    myemail = val;
                  },
                  validator: (val) {
                    if (val != null) {
                      if (val.length < 4) return "can't to be less than 4";
                      if (val.length > 40) return "can't to be more than 40";
                    } else
                      AwesomeDialog(
                          context: context,
                          title: "Erorr",
                          body: Text("Not Valid"))
                        ..show();
                  },
                  decoration: InputDecoration(
                      focusColor: Colors.red,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.red[300]),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  onSaved: (val) {
                    mypassword = val;
                  },
                  validator: (val) {
                    if (val != null) {
                      if (val.length < 4) return "can't to be less than 4";
                      if (val.length > 60) return "can't to be more than 40";
                    } else
                      AwesomeDialog(
                          context: context,
                          title: "Erorr",
                          body: Text("Not Valid"))
                        ..show();
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.red,
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.red,
                      ),
                      hintText: "password",
                      hintStyle: TextStyle(color: Colors.red[300]),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: state,
                      onChanged: (val) {
                        setState(() {
                          state = val!;
                        });
                      },
                      activeColor: Colors.red,
                    ),
                    Text(
                      "Remeber me",
                      style: TextStyle(color: Colors.red[300]),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forget Password",
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        UserCredential log = await signin();
                        if (log != null) {
                          var useid;
                          var us = await FirebaseAuth.instance.currentUser;
                          var info = await FirebaseFirestore.instance
                              .collection('Users')
                              .where("Email", isEqualTo: us?.email)
                              .get();
                          await AddUserToChat(info);
                          var info2 = await FirebaseFirestore.instance
                              .collection('chat')
                              .where("email", isEqualTo: us?.email)
                              .get();
                          useid = info2.docs[0].id;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepage(
                                        usid: useid,
                                        username: info.docs[0]['Username'],
                                      )));
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("signup");
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(300)),
                  child: Image.asset(
                    "Images/logo4.jpg",
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    )));
  }
}
