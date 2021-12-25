import 'package:flutter/material.dart';

class NoResultpage extends StatefulWidget {
  NoResultpage({Key? key}) : super(key: key);

  @override
  _NoResultpageState createState() => _NoResultpageState();
}

class _NoResultpageState extends State<NoResultpage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 55),
      child: Text(
        "No Resultat found",
        style: TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
