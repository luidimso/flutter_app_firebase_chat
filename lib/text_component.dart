import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextComponent extends StatefulWidget {
  @override
  _TextComponentState createState() => _TextComponentState();
}

class _TextComponentState extends State<TextComponent> {
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () {}
          ),
          Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(
                    hintText: "Send a message"
                ),
                onChanged: (text) {
                  setState(() {
                    _hasText = text.isNotEmpty;
                  });
                },
                onSubmitted: (text) {},
              )
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _hasText ? () {} : null
          )
        ],
      ),
    );
  }
}
