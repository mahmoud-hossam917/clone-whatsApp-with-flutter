import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class WriteStory extends StatefulWidget {
  WriteStory({Key? key}) : super(key: key);

  @override
  _WriteStoryState createState() => _WriteStoryState();
}

class _WriteStoryState extends State<WriteStory> {
  int index = 0;
  var written = "";
  uploadstory() async {
    var us = await FirebaseAuth.instance.currentUser;
    var info = await FirebaseFirestore.instance
        .collection('chat')
        .where('email', isEqualTo: us?.email)
        .get();
    await FirebaseFirestore.instance
        .collection('chat')
        .doc("${info.docs[0].id}")
        .collection('status')
        .add({"type": "written", "written": written, "color": index});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (index == 0)
          ? Colors.blue
          : (index == 1)
              ? Colors.black
              : Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              index++;
                              index %= 3;
                            });
                          },
                          icon: Icon(Icons.color_lens),
                          color: Colors.white,
                        ),
                      ),
                      (written.length > 0)
                          ? Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: () async {
                                    await uploadstory();
                                    written = "";
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.send, color: Colors.red),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: (index == 0)
                              ? Colors.blue
                              : (index == 1)
                                  ? Colors.black
                                  : Colors.red,
                          margin: EdgeInsets.only(right: 2, bottom: 2, left: 2),
                          child: TextFormField(
                            autofocus: false,
                            cursorColor: Colors.red,
                            style: TextStyle(color: Colors.white),
                            onChanged: (val) {
                              setState(() {
                                written = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Write Status",
                              hintStyle: TextStyle(color: Colors.white),
                              focusColor: Colors.red,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
