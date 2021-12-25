import 'package:flutter/material.dart';
import 'package:whats_project/models/buttoncard.dart';
import 'package:whats_project/models/contactcard.dart';
import 'package:whats_project/models/modelchat.dart';

class SelectContact extends StatefulWidget {
  SelectContact({Key? key}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<ChatModel> people = [
    ChatModel(name: "Hossam", message: "Hello", time: "", avaterurl: ""),
    ChatModel(name: "Hossam", message: "Hello", time: "", avaterurl: ""),
    ChatModel(name: "Hossam", message: "Hello", time: "", avaterurl: ""),
    ChatModel(name: "Hossam", message: "Hello", time: "", avaterurl: ""),
    ChatModel(name: "Hossam", message: "Hello", time: "", avaterurl: ""),
    ChatModel(name: "Hossam", message: "Hello", time: "", avaterurl: ""),
    ChatModel(name: "Hossam", message: "Hello", time: "", avaterurl: ""),
    ChatModel(name: "Hossam", message: "Hello", time: "", avaterurl: ""),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Contact",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Text("256 contacts")
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 26,
              )),
          PopupMenuButton<String>(
              onSelected: (value) {},
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text("Invite Friend"),
                    value: "Invite Friend",
                  ),
                  PopupMenuItem(
                    child: Text("Contacts"),
                    value: "Contacts",
                  ),
                  PopupMenuItem(
                    child: Text("Refresh"),
                    value: "Refresh",
                  ),
                  PopupMenuItem(
                    child: Text("Help"),
                    value: "Help",
                  ),
                ];
              })
        ],
      ),
      body: ListView.builder(
        itemCount: people.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Buttoncard(icon: Icons.group, name: "Add Group");
          } else if (index == 1) {
            return Buttoncard(icon: Icons.person_add, name: "Add Person");
          }
          return ContactCard(chat: people[index - 2]);
        },
      ),
    );
  }
}
