import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:whats_project/models/modelchat.dart';
import 'package:whats_project/models/chatpage.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, this.usid}) : super(key: key);
  var usid;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.message),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .doc("${widget.usid}")
              .collection('friends')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            int? cnt = snapshot.data?.size;
            if (snapshot.hasData && cnt != null) {
              return ListView.builder(
                itemCount: snapshot.data?.size,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Divider(
                        height: 10.0,
                      ),
                      ListTile(
                          onTap: () async {
                            ChatModel send = ChatModel();
                            send.Receiveremail =
                                snapshot.data?.docs?[index]['email'];

                            send.name = snapshot.data?.docs?[index]['username'];
                            var usfr = await FirebaseFirestore.instance
                                .collection('chat')
                                .doc('${widget.usid}')
                                .collection('friends')
                                .where('email', isEqualTo: send.Receiveremail)
                                .get();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          chat: send,
                                          usid: widget.usid,
                                          usfr: usfr.docs[0].id,
                                        )));
                          },
                          leading: CircleAvatar(
                            maxRadius: 30,
                            backgroundColor: Colors.grey,
                            foregroundColor: Theme.of(context).primaryColor,
                            backgroundImage: AssetImage("Images/mahmoud.jpg"),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data.docs[index]['username'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data.docs[index]['Date'],
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              )
                            ],
                          ),
                          subtitle: Container(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              snapshot.data.docs[index]['lastmsge'],
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.grey),
                            ),
                          ))
                    ],
                  );
                },
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
