import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_chat/text_component.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi"),
        elevation: 0,
      ),
      body: TextComponent(_sendMessage),
    );
  }

  void _sendMessage({String text, File image}) async {
    Map <String, dynamic> data = {};

    if(text != null) {
      data["text"] = text;
    }

    if(image != null) {
      StorageUploadTask task = FirebaseStorage.instance.ref().child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(image);
      StorageTaskSnapshot snapshot = await task.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      data["image"] = url;
    }

    Firestore.instance.collection("messages").add(data);
  }
}
