import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_project/status.dart';

class WriteOnImg extends StatefulWidget {
  WriteOnImg({Key? key, this.imgpath}) : super(key: key);
  var imgpath;
  @override
  _WriteOnImgState createState() => _WriteOnImgState();
}

class _WriteOnImgState extends State<WriteOnImg> {
  String written = "";
  uploadstory() async {
    var usr = await FirebaseAuth.instance.currentUser;
    var userid = await FirebaseFirestore.instance
        .collection('chat')
        .where("email", isEqualTo: usr?.email)
        .get();
    await FirebaseFirestore.instance
        .collection('chat')
        .doc('${userid.docs[0].id}')
        .collection('status')
        .add({'type': 'image', 'written': written, 'imgpath': widget.imgpath});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                "${widget.imgpath}",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                (written.length > 0)
                    ? Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                              onPressed: () async {
                                await uploadstory();
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.red,
                              )),
                        ),
                      )
                    : Container(),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  onChanged: (val) {
                    setState(() {
                      written = val;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Here",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
