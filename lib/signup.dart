import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_project/class/user.dart';
import 'package:whats_project/componont/alert.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool state = false;
  final formstate = GlobalKey<FormState>();
  USER user = new USER();
  SignUp() async {
    var formdata = formstate.currentState;
    if (formdata != null) {
      formdata.save();
      if (formdata.validate()) {
        try {
          showloading(context);
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: user.email, password: user.password);
          print("fadi");
          return userCredential;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Navigator.of(context).pop();
            AwesomeDialog(
                context: context,
                title: "Error",
                body: Text("Password is too weak"))
              ..show();
          } else if (e.code == 'email-already-in-use') {
            Navigator.of(context).pop();
            AwesomeDialog(
                context: context,
                title: "Error",
                body: Text("The account already exists for that email."))
              ..show();
          }
        } catch (e) {
          AwesomeDialog(context: context, title: "Error", body: Text("${e}"))
            ..show();
        }
      } else {
        AwesomeDialog(context: context, title: "Error", body: Text("Not Valid"))
          ..show();
      }
    } else {
      AwesomeDialog(context: context, title: "Error", body: Text("Not Valid"))
        ..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          child: Text(
            "WelcomeApp",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.red[400]),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30, right: 20),
          child: Text(
            "Signup",
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
                    user.email = val;
                  },
                  validator: (val) {
                    if (val != null) {
                      if (val.length > 30)
                        return "Email can't to be more than 30";
                      if (val.length < 5)
                        return "Email have to be more than 5 charcters";
                    } else
                      return "Email have to be more than 5 charcters";
                  },
                  decoration: InputDecoration(
                      focusColor: Colors.red,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.red,
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.red[300]),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red))),
                ),
                TextFormField(
                  autofocus: false,
                  onSaved: (val) {
                    user.username = val;
                  },
                  validator: (val) {
                    if (val != null) {
                      if (val.length > 30)
                        return "Username can't to be more than 30";
                      if (val.length < 4)
                        return "Username have to be more than 4 charcters";
                    } else
                      return "Username have to be more than 4 charcters";
                  },
                  decoration: InputDecoration(
                      focusColor: Colors.red,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                      hintText: "user name",
                      hintStyle: TextStyle(color: Colors.red[300]),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red))),
                ),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  onSaved: (val) {
                    user.password = val;
                  },
                  validator: (val) {
                    if (val != null) {
                      if (val.length > 60)
                        return "password can't to be more than 60";
                      if (val.length < 4)
                        return "password have to be more than 4 charcters";
                    } else
                      return "password have to be more than 4 charcters";
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
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  validator: (val) {
                    if (val != null) {
                      if (val != user.password)
                        return "there is something wrone please try to write the password ";
                    } else
                      return "there is something wrone please try to write the password ";
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.red,
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.red,
                      ),
                      hintText: "Confrim password",
                      hintStyle: TextStyle(color: Colors.red[300]),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red))),
                ),
                TextFormField(
                  autofocus: false,
                  onSaved: (val) {
                    user.phonenumber = val;
                  },
                  validator: (val) {
                    if (val != null) {
                      if (val.length > 11)
                        return "phonenumber can't to be more than 60";
                      if (val.length < 11)
                        return "phonenumber have to equal 11 charcters";
                    } else
                      return "phonenumber have to be equal 11 charcters";
                  },
                  decoration: InputDecoration(
                      focusColor: Colors.red,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.red,
                      ),
                      hintText: "phone number",
                      hintStyle: TextStyle(color: Colors.red[300]),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        UserCredential Response = await SignUp();
                        print("Ahmed");
                        if (Response != null) {
                          print("mahmoud");
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .add({
                            "Email": user.email,
                            "Username": user.username,
                            "password": user.password,
                            "Phonenumber": user.phonenumber
                          });
                          Navigator.of(context).pushReplacementNamed("login");
                        } else {
                          AwesomeDialog(
                              context: context,
                              title: "Erorr",
                              body: Text("Not Valid"));
                          Navigator.of(context).pushReplacementNamed("signup");
                        }
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
                )
              ],
            ),
          ),
        )
      ],
    )));
  }
}
