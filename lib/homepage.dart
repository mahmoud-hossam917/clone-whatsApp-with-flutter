import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_project/calls.dart';
import 'package:whats_project/chatscreen.dart';
import 'package:whats_project/login.dart';
import 'package:whats_project/models/noresultpage.dart';
import 'package:whats_project/models/searchpage.dart';
import 'package:whats_project/status.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key, this.usid, this.username}) : super(key: key);
  var usid;
  var username;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var image;
  final imagepicker = ImagePicker();
  uploudimage() async {
    var pickedimage = imagepicker.pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        image = pickedimage;
      });
    }
  }

  bool state = false;
  bool statescreen = false;
  String? search = '';
  QuerySnapshot<Map<String, dynamic>>? need;
  getusername() async {
    var user = await FirebaseAuth.instance.currentUser;
    var info = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: user?.email)
        .get();
    return info.docs[0]['Username'];
  }

  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: (!state)
                    ? Text("WelcomeApp")
                    : TextField(
                        cursorColor: Colors.red,
                        onChanged: (val) {
                          setState(() {
                            search = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: Colors.white,
                          filled: true,
                          focusColor: Colors.red,
                          prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  search = '';
                                  state = false;
                                  statescreen = false;
                                });
                              },
                              icon: Icon(
                                Icons.clear,
                              )),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Colors.red)),
                        ))),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  padding: EdgeInsets.only(bottom: 10),
                );
              },
            ),
            backgroundColor: Colors.red,
            toolbarHeight: 50,
            bottom: TabBar(indicatorColor: Colors.white, tabs: [
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.message,
                      size: 20,
                    ),
                    Text(" Chats")
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [Icon(Icons.bookmark), Text("Status")],
                ),
              ),
              Tab(
                child: Row(children: [Icon(Icons.call), Text("Calls")]),
              )
            ]),
            actions: [
              new IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  if (!state) {
                    search = '';
                    setState(() {
                      state = true;
                    });
                  } else {
                    if (search != null) {
                      need = null;
                      var persons = await FirebaseFirestore.instance
                          .collection("Users")
                          .where('Username', isEqualTo: search)
                          .get();
                      var personswithemail = await FirebaseFirestore.instance
                          .collection("Users")
                          .where("Email", isEqualTo: search)
                          .get();

                      search = '';

                      if (persons != null && persons.docs.length >= 1) {
                        need = persons;

                        if (need != null)
                          setState(() {
                            statescreen = true;
                          });
                      } else if (personswithemail != null &&
                          personswithemail.docs.length >= 1) {
                        need = personswithemail;
                        setState(() {
                          statescreen = true;
                        });
                      } else {
                        setState(() {
                          statescreen = true;
                        });
                      }
                    }
                  }
                },
              ),
              new Padding(padding: EdgeInsets.symmetric(horizontal: 5.0))
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage("Images/mahmoud.jpg"),
                    ),
                    accountName: Text("${widget.username}"),
                    accountEmail: Text("${user?.email}")),
                ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Help"),
                  leading: Icon(Icons.help),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("About"),
                  leading: Icon(Icons.help_center),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Logout"),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      title: "ensure",
                      body: Text("Are u want to logout !"),
                      btnOkOnPress: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      btnCancelOnPress: () {},
                    )..show();
                  },
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(300)),
                  child: Image.asset(
                    "Images/logo4.jpg",
                    height: 200,
                    width: 200,
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              (!statescreen)
                  ? new ChatScreen(
                      usid: widget.usid,
                    )
                  : new Searchpage(
                      data: need,
                      usid: widget.usid,
                    ),
              new Status(
                userid: widget.usid,
              ),
              new Calls(),
            ],
          ),
        ));
  }
}
