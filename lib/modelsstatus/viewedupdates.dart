import 'package:flutter/material.dart';

class Viewedupdates extends StatefulWidget {
  Viewedupdates({Key? key}) : super(key: key);

  @override
  _ViewedupdatesState createState() => _ViewedupdatesState();
}

class _ViewedupdatesState extends State<Viewedupdates> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 33,
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              " Viewed status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Divider(
                  height: (index == 0) ? 30 : 10,
                ),
                ListTile(
                  onTap: () {},
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("Images/mahmoud.jpg"),
                    radius: 25,
                  ),
                  title: Text("mahmoud"),
                  subtitle: Text("Today at 11:25"),
                ),
              ],
            );
          },
        ),
      ],
    ));
  }
}
