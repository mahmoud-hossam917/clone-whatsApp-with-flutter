import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whats_project/main.dart';
import 'package:whats_project/status.dart';

class ShowStory extends StatefulWidget {
  ShowStory({Key? key, this.userid}) : super(key: key);
  var userid;
  @override
  _ShowStoryState createState() => _ShowStoryState();
}

class _ShowStoryState extends State<ShowStory> {
  final _storycontroller = StoryController();
  @override
  void dispose() {
    _storycontroller.dispose();
    super.dispose();
  }

  final StoryController _controller = StoryController();
  bool state = true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .doc('${widget.userid}')
          .collection('status')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final storyitem = <StoryItem>[];
          for (final story in snapshot.data.docs) {
            if (story['type'] == 'image') {
              storyitem.add(StoryItem.pageImage(
                  controller: _controller,
                  url: story['imgpath'],
                  caption: story['written']));
            } else {
              storyitem.add(StoryItem.text(
                  title: story['written'],
                  backgroundColor: (story['color'] == 0)
                      ? Colors.blue
                      : (story['color'] == 1)
                          ? Colors.black
                          : Colors.red));
            }
          }
          return StoryView(
            storyItems: storyitem,
            controller: _controller,
            progressPosition: ProgressPosition.top,
            onComplete: () {
              Navigator.of(context).pop();
            },
          );
        }
        return Container();
      },
    );
  }
}
