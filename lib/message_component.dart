import 'package:flutter/material.dart';

class MessageComponent extends StatelessWidget {
  MessageComponent(this.data, this.itsMe);

  final Map<String, dynamic> data;
  final bool itsMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10
      ),
      child: Row(
        children: <Widget>[
          !itsMe ?
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["profile"]),
            ),
          ) : Container(),
          Expanded(
              child: Column(
                crossAxisAlignment: itsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  data["image"] != null ?
                  Image.network(data["image"],
                    width: 250
                  ) :
                  Text(data["text"],
                    textAlign: itsMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                  Text(data["name"],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              )
          ),
          itsMe ?
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["profile"]),
            ),
          ) : Container()
        ],
      ),
    );
  }
}
