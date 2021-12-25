import 'package:flutter/material.dart';
import 'package:whats_project/models/createprofile.dart';

class Buttoncard extends StatefulWidget {
  Buttoncard({Key? key, required this.icon, required this.name})
      : super(key: key);
  final IconData icon;
  final String name;
  @override
  _ButtoncardState createState() => _ButtoncardState();
}

class _ButtoncardState extends State<Buttoncard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (Builder) => CreateProfile()));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(
            widget.icon,
            color: Colors.white,
          ),
        ),
        title: Text(widget.name),
      ),
    );
  }
}
