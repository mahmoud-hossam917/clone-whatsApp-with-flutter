import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whats_project/modelsstatus/showstory.dart';
import 'package:whats_project/modelsstatus/writestoryimg.dart';

class Headstate extends StatefulWidget {
  Headstate({Key? key, this.userid}) : super(key: key);
  var userid;
  @override
  _HeadstateState createState() => _HeadstateState();
}

class _HeadstateState extends State<Headstate> {
  UploadImageStory() async {
    var imgpicker = ImagePicker();
    var imgpicked = await imgpicker.pickImage(source: ImageSource.gallery);

    if (imgpicked != null) {
      var file = File(imgpicked.path);
      var nameimage = basename(imgpicked.path);
      var rand = Random().nextInt(10000000);
      var ref = FirebaseStorage.instance.ref("Images").child("$rand$nameimage");
      await ref.putFile(file);
      var imagurl = ref.getDownloadURL();
      return imagurl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc('${widget.userid}')
            .collection('status')
            .snapshots(),
        builder: (context, snapshot) {
          return ListTile(
            onTap: () async {
              if (snapshot.hasData) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowStory(userid: widget.userid)));
              } else {
                var imgurl = await UploadImageStory();
                if (imgurl != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WriteOnImg(imgpath: imgurl)));
                }
              }
            },
            leading: (snapshot.hasData)
                ? CustomPaint(
                    painter: StatusPainter(),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("Images/mahmoud.jpg"),
                    ))
                : Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("Images/mahmoud.jpg"),
                        radius: 25,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 10,
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
            title: Text(
              "My status ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Tab to add status update"),
          );
        });
  }
}

degreetoangle(double degree) {
  return degree * pi / 180;
}

class StatusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 4.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    drawArc(canvas, size, paint);
  }

  void drawArc(Canvas canvas, Size size, Paint paint) {
    canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        degreetoangle(0), degreetoangle(360), false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
