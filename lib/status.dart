import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:whats_project/modelsstatus/headstate.dart';
import 'package:whats_project/modelsstatus/recentupdates.dart';
import 'package:whats_project/modelsstatus/viewedupdates.dart';
import 'package:whats_project/modelsstatus/writestory.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_project/modelsstatus/writestoryimg.dart';

class Status extends StatefulWidget {
  Status({Key? key, this.userid}) : super(key: key);
  var userid;
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  UploadImageStory() async {
    var imgpicker = ImagePicker();
    var imgpicked = await imgpicker.pickImage(source: ImageSource.gallery);

    if (imgpicked != null) {
      var file = File(imgpicked.path);
      var nameimage = basename(imgpicked.path);
      var rand = Random().nextInt(10000000);
      var ref = FirebaseStorage.instance.ref("Images").child("$rand$nameimage");
      await ref.putFile(file);
      var imagurl = ref.getDownloadURL();
      return imagurl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              height: 80,
              width: 50,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => WriteStory()));
                },
                child: Icon(Icons.edit),
                backgroundColor: Colors.grey,
              )),
          FloatingActionButton(
            onPressed: () async {
              var imgurl = await UploadImageStory();
              if (imgurl != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WriteOnImg(imgpath: imgurl)));
              }
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Headstate(
              userid: widget.userid,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 33,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Text(
                  "  Recent updates",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Recentupdates(
              userid: widget.userid,
            ),
            Viewedupdates()
          ],
        ),
      ),
    );
  }
}
