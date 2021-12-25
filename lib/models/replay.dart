import 'package:flutter/material.dart';

class Replay extends StatefulWidget {
  Replay({Key? key, this.msg, this.date}) : super(key: key);
  String? msg = '';
  String? date = "";
  @override
  _ReplayState createState() => _ReplayState();
}

class _ReplayState extends State<Replay> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            color: Colors.white70,
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 5, right: 60, bottom: 10),
                    child: Text(
                      "${widget.msg}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )),
                Positioned(
                    bottom: 0,
                    right: 2,
                    child: Row(
                      children: [
                        Text(
                          "${widget.date}",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.done_all,
                          size: 20,
                          color: Colors.blue,
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
