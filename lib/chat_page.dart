import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _sendMessage(String text) {
    Firestore.instance.collection("messages").add({"text": text});
  }
}
