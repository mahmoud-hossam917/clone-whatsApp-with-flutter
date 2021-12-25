import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_project/models/modelchat.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whats_project/models/ownmessage.dart';
import 'package:whats_project/models/replay.dart';
import 'package:whats_project/models/selectcontact.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.chat, this.usid, this.usfr})
      : super(key: key);
  final ChatModel chat;
  var usid, usfr;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  AddFriendToUser(QuerySnapshot<Map<String, dynamic>> user,
      QuerySnapshot<Map<String, dynamic>> user2, bool state) async {
    var getid = await FirebaseFirestore.instance
        .collection('chat')
        .where('email', isEqualTo: user.docs[0]['Email'])
        .get();

    var Response = await FirebaseFirestore.instance
        .collection('chat')
        .doc('${getid.docs[0].id}')
        .collection('friends')
        .where('email', isEqualTo: user2.docs[0]['Email'])
        .get();
    if (Response.docs.length < 1) {
      await FirebaseFirestore.instance
          .collection('chat')
          .doc('${getid.docs[0].id}')
          .collection('friends')
          .add({
        'email': user2.docs[0]['Email'],
        'username': user2.docs[0]['Username']
      });
      var idfr = await FirebaseFirestore.instance
          .collection('chat')
          .doc('${getid.docs[0].id}')
          .collection('friends')
          .where('email', isEqualTo: user2.docs[0]['Email'])
          .get();
      if (state) {
        setState(() {
          widget.usfr = idfr.docs[0].id;
        });
      }
    }
    return 0;
  }

  var msg = '';
  var _controller = TextEditingController();
  var user = FirebaseAuth.instance.currentUser;

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('chat')
        .doc('${widget.usid}')
        .collection('friends')
        .doc('${widget.usfr}')
        .collection('allmessages')
        .orderBy('Date', descending: false)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        leadingWidth: 70,
        toolbarHeight: 60,
        backgroundColor: Colors.red,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueGrey,
              //  backgroundImage: AssetImage(),
              child: SvgPicture.asset(
                "Images/person.svg",
                color: Colors.white,
                width: 30,
                height: 30,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
              onSelected: (value) {},
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text("View conect"),
                    value: "Group",
                  ),
                  PopupMenuItem(
                    child: Text("View conect"),
                    value: "Group",
                  ),
                  PopupMenuItem(
                    child: Text("View conect"),
                    value: "Group",
                  ),
                  PopupMenuItem(
                    child: Text("View conect"),
                    value: "Group",
                  ),
                ];
              })
          //Padding(padding: EdgeInsets.symmetric(horizontal: 5.0))
        ],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chat.name,
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
            ),
            Text(
              "Last Seen Today at 12.05",
              style: TextStyle(fontSize: 9),
            )
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              // height: MediaQuery.of(context).size.height - 150,
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return (snapshot.hasData)
                      ? ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: snapshot.data?.docs.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == snapshot.data?.docs.length) {
                              return Container(
                                height: 60,
                              );
                            }
                            return (snapshot.data?.docs[index]['sender'] ==
                                    user?.email)
                                ? OwnMessage(
                                    msg: snapshot.data?.docs[index]['msg'],
                                    date: snapshot.data?.docs[index]['time'],
                                  )
                                : Replay(
                                    msg: snapshot.data?.docs[index]['msg'],
                                    date: snapshot.data?.docs[index]['time']);
                          },
                        )
                      : Container();
                },
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width - 55,
                              child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    onChanged: (val) {
                                      setState(() {
                                        msg = val;
                                      });
                                    },
                                    controller: _controller,
                                    cursorColor: Colors.red,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type a Message",
                                        contentPadding: EdgeInsets.all(5),
                                        prefixIcon: IconButton(
                                          icon: Icon(
                                            Icons.emoji_emotions,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {},
                                        ),
                                        suffixIcon: Row(
                                          //   crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      builder: (Builder) =>
                                                          bottomsheet());
                                                },
                                                icon: Icon(
                                                  Icons.attach_file,
                                                  color: Colors.red,
                                                )),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        )),
                                  ))),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: 8, right: 5, left: 2),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  if (msg.length >= 1) {
                                    _controller.clear();
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(microseconds: 300),
                                        curve: Curves.easeOut);
                                    DateTime now = DateTime.now();
                                    String dateFormat =
                                        DateFormat("hh:mm").format(now);

                                    var us =
                                        await FirebaseAuth.instance.currentUser;
                                    var infouser = await FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .where('Email', isEqualTo: us?.email)
                                        .get();
                                    var infouser2 = await FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .where('Email',
                                            isEqualTo:
                                                widget.chat.Receiveremail)
                                        .get();

                                    await AddFriendToUser(
                                        infouser, infouser2, true);
                                    await AddFriendToUser(
                                        infouser2, infouser, false);
                                    var docid, docid2;
                                    print(
                                        "-------------------------------------${widget.usid}");
                                    docid = await FirebaseFirestore.instance
                                        .collection('chat')
                                        .where('email', isEqualTo: us?.email)
                                        .get();

                                    docid2 = await FirebaseFirestore.instance
                                        .collection('chat')
                                        .doc("${docid.docs[0].id}")
                                        .collection("friends")
                                        .where("email",
                                            isEqualTo:
                                                widget.chat.Receiveremail)
                                        .get();

                                    await FirebaseFirestore.instance
                                        .collection('chat')
                                        .doc("${docid.docs[0].id}")
                                        .collection("friends")
                                        .doc("${docid2.docs[0].id}")
                                        .collection("allmessages")
                                        .add({
                                      "msg": msg,
                                      "sender": user?.email,
                                      "receiver": infouser2.docs[0]['Email'],
                                      "Date":
                                          DateTime.now().microsecondsSinceEpoch,
                                      "time": dateFormat
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('chat')
                                        .doc("${docid.docs[0].id}")
                                        .collection("friends")
                                        .doc("${docid2.docs[0].id}")
                                        .set({
                                      "email": infouser2.docs[0]['Email'],
                                      "username": infouser2.docs[0]['Username'],
                                      "lastmsge": msg,
                                      "Date": dateFormat,
                                      "time":
                                          DateTime.now().microsecondsSinceEpoch
                                    });

                                    //////////////////////////////
                                    if (infouser2.docs[0]['Email'] !=
                                        us?.email) {
                                      docid = await FirebaseFirestore.instance
                                          .collection('chat')
                                          .where('email',
                                              isEqualTo: infouser2.docs[0]
                                                  ['Email'])
                                          .get();

                                      docid2 = await FirebaseFirestore.instance
                                          .collection('chat')
                                          .doc("${docid.docs[0].id}")
                                          .collection("friends")
                                          .where("email", isEqualTo: us?.email)
                                          .get();
                                      await FirebaseFirestore.instance
                                          .collection('chat')
                                          .doc("${docid.docs[0].id}")
                                          .collection("friends")
                                          .doc("${docid2.docs[0].id}")
                                          .collection("allmessages")
                                          .add({
                                        "msg": msg,
                                        "sender": user?.email,
                                        "receiver": infouser2.docs[0]['Email'],
                                        "Date": DateTime.now()
                                            .microsecondsSinceEpoch,
                                        "time": dateFormat
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('chat')
                                          .doc("${docid.docs[0].id}")
                                          .collection("friends")
                                          .doc("${docid2.docs[0].id}")
                                          .set({
                                        "email": infouser.docs[0]['Email'],
                                        "username": infouser.docs[0]
                                            ['Username'],
                                        "lastmsge": msg,
                                        "Date": dateFormat,
                                        "time": DateTime.now()
                                            .microsecondsSinceEpoch
                                      });
                                    }

                                    msg = '';
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(
                      Icons.insert_drive_file, Colors.indigo, "Decoumnt"),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(Icons.person, Colors.blue, "Contact"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconcreation(IconData icon, Color color, String text) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (Builder) => SelectContact()));
        },
        child: Column(children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 30,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          )
        ]));
  }
}
