import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComponent extends StatefulWidget {
  TextComponent(this.sendMessage);

  final Function({String text, File image}) sendMessage;

  @override
  _TextComponentState createState() => _TextComponentState();
}

class _TextComponentState extends State<TextComponent> {
  final TextEditingController _textController = TextEditingController();
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async {
                final File image = await ImagePicker.pickImage(source: ImageSource.camera);
                if (image == null) return;
                widget.sendMessage(image: image);
              }
          ),
          Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration.collapsed(
                    hintText: "Send a message"
                ),
                onChanged: (text) {
                  setState(() {
                    _hasText = text.isNotEmpty;
                  });
                },
                onSubmitted: (text) {
                  widget.sendMessage(text: text);
                  _resetText();
                },
              )
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _hasText ? () {
                widget.sendMessage(text: _textController.text);
                _resetText();
              } : null
          )
        ],
      ),
    );
  }

  void _resetText() {
    _textController.clear();
    setState(() {
      _hasText = false;
    });
  }
}
