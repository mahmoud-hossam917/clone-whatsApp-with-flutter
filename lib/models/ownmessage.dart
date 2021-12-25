import 'package:flutter/material.dart';

class OwnMessage extends StatefulWidget {
  OwnMessage({Key? key, this.msg, this.date}) : super(key: key);
  String? msg = '';
  String? date = "";
  @override
  _OwnMessageState createState() => _OwnMessageState();
}

class _OwnMessageState extends State<OwnMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            color: Colors.red,
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 5, right: 60, bottom: 10),
                    child: Text(
                      "${widget.msg}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                Positioned(
                    bottom: 0,
                    right: 2,
                    child: Row(
                      children: [
                        Text(
                          "${widget.date}",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.done_all,
                          size: 20,
                          color: Colors.blue[200],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
