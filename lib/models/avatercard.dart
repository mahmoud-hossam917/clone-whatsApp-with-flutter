import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whats_project/models/modelchat.dart';

class Avatercard extends StatefulWidget {
  Avatercard({Key? key, required this.chat}) : super(key: key);
  final ChatModel chat;
  @override
  _AvatercardState createState() => _AvatercardState();
}

class _AvatercardState extends State<Avatercard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 23,
              child: SvgPicture.asset(
                "Images/person.svg",
                color: Colors.white,
                height: 30,
                width: 30,
              ),
              backgroundColor: Colors.blueGrey[200],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 11,
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          widget.chat.name,
          style: TextStyle(fontSize: 12),
        )
      ]),
    );
  }
}
