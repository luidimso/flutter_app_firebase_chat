import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextComponent extends StatefulWidget {
  TextComponent(this.sendMessage);

  Function(String) sendMessage;

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
              onPressed: () {}
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
                  widget.sendMessage(text);
                  _resetText();
                },
              )
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _hasText ? () {
                widget.sendMessage(_textController.text);
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
