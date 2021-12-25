import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_project/modelsstatus/showstory.dart';

class Recentupdates extends StatefulWidget {
  Recentupdates({Key? key, this.userid}) : super(key: key);
  var userid;
  @override
  _RecentupdatesState createState() => _RecentupdatesState();
}

class _RecentupdatesState extends State<Recentupdates> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .doc('${widget.userid}')
          .collection('friends')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.size,
            itemBuilder: (BuildContext context, int index) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .where('email',
                        isEqualTo: snapshot.data.docs[index]['email'])
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    var id = snapshot.data.docs[0].id;
                    var name = snapshot.data.docs[0]['username'];
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('chat')
                            .doc('$id')
                            .collection('status')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Divider(
                                  height: 10.0,
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ShowStory(
                                                  userid: id,
                                                )));
                                  },
                                  title: Text("$name"),
                                  subtitle: Text("Today at 12:45"),
                                  leading: CustomPaint(
                                      painter: StatusPainter(),
                                      child: CircleAvatar(
                                        radius: 26,
                                        backgroundImage:
                                            AssetImage("Images/mahmoud.jpg"),
                                      )),
                                ),
                              ],
                            );
                          }
                          return Container();
                        });
                  }
                  return Container();
                },
              );
            },
          );
        }
        return Container();
      },
    );
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
