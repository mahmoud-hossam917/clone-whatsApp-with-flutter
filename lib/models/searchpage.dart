import 'package:flutter/material.dart';
import 'package:whats_project/models/chatpage.dart';
import 'package:whats_project/models/modelchat.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_project/models/noresultpage.dart';

class Searchpage extends StatefulWidget {
  Searchpage({Key? key, this.data, this.usid}) : super(key: key);
  QuerySnapshot<Map<String, dynamic>>? data;
  var usid;
  @override
  _SearchpageState createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  @override
  Widget build(BuildContext context) {
    int? cnt = widget.data?.size;
    return (cnt != null && cnt >= 1)
        ? ListView.builder(
            itemCount: widget.data?.size,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Divider(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () async {
                      ChatModel send = new ChatModel();
                      send.name = widget.data?.docs[index]['Username'];
                      send.Receiveremail = widget.data?.docs[index]['Email'];

                      var usfr = await FirebaseFirestore.instance
                          .collection('chat')
                          .doc('${widget.usid}')
                          .collection('friends')
                          .where('email', isEqualTo: send.Receiveremail)
                          .get();
                      if (usfr.docs.length > 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                      chat: send,
                                      usid: widget.usid,
                                      usfr: usfr.docs[0].id,
                                    )));
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    chat: send,
                                    usid: widget.usid,
                                  )));
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("Images/mahmoud.jpg"),
                    ),
                    title: Text(widget.data?.docs[index]['Username']),
                  )
                ],
              );
            },
          )
        : NoResultpage();
  }
}
