import 'package:flutter/material.dart';
import 'package:whats_project/models/avatercard.dart';
import 'package:whats_project/models/contactcard.dart';
import 'package:whats_project/models/modelchat.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
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
  List<ChatModel> groups = [];
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
                "New Group",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                "Add New Participant",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  size: 26,
                )),
          ],
        ),
        body: Stack(children: [
          ListView.builder(
            itemCount: people.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  height: groups.length > 0 ? 90 : 10,
                );
              }
              return InkWell(
                  onTap: () {
                    if (people[index - 1].state == false) {
                      setState(() {
                        people[index - 1].state = true;
                        groups.add(people[index - 1]);
                      });
                    } else {
                      setState(() {
                        people[index - 1].state = false;
                        groups.remove(people[index - 1]);
                      });
                    }
                  },
                  child: ContactCard(
                    chat: people[index - 1],
                  ));
            },
          ),
          groups.length > 0
              ? Column(
                  children: [
                    Container(
                      height: 75,
                      color: Colors.white,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: people.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (people[index].state == true) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  people[index].state = false;
                                  groups.remove(people[index]);
                                });
                              },
                              child: Avatercard(chat: people[index]),
                            );
                          } else
                            return Container();
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    )
                  ],
                )
              : Container()
        ]));
  }
}
