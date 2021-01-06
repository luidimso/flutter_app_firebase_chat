import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_chat/message_component.dart';
import 'package:flutter_app_firebase_chat/text_component.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  final GoogleSignIn signin = GoogleSignIn();
  FirebaseUser _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text(_user != null ? "Hi, ${_user.displayName}" : "Chat App"),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          _user != null ?
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    signin.signOut();
                    _scaffold.currentState.showSnackBar(
                        SnackBar(
                          content: Text("You success logout!")
                        )
                    );
                  }
              ) : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("messages").orderBy("time").snapshots(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator()
                      );
                    default:
                      List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();
                      return ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return MessageComponent(documents[index].data, documents[index].data["uid"] == _user?.uid);
                        }
                      );
                  }
                }
              )
          ),
          _isLoading ? LinearProgressIndicator() : Container(),
          TextComponent(_sendMessage)
        ],
      ),
    );
  }

  void _sendMessage({String text, File image}) async {
    final FirebaseUser user = await _login();

    if(user == null) {
      _scaffold.currentState.showSnackBar(
        SnackBar(
          content: Text("Can't login. Try again."),
          backgroundColor: Colors.red,
        )
      );
    }

    Map <String, dynamic> data = {
      "uid": user.uid,
      "name": user.displayName,
      "profile": user.photoUrl,
      "time": Timestamp.now()
    };

    if(text != null) {
      data["text"] = text;
    }

    if(image != null) {
      StorageUploadTask task = FirebaseStorage.instance.ref().child(user.uid + DateTime.now().millisecondsSinceEpoch.toString()).putFile(image);
      setState(() {
        _isLoading = true;
      });
      StorageTaskSnapshot snapshot = await task.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      data["image"] = url;
      setState(() {
        _isLoading = false;
      });
    }

    Firestore.instance.collection("messages").add(data);
  }

  Future<FirebaseUser> _login() async {
    if(_user != null) return _user;

    try {
      final GoogleSignInAccount account = await signin.signIn();
      final GoogleSignInAuthentication auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: auth.idToken,
          accessToken: auth.accessToken
      );
      final AuthResult result = await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseUser user = result.user;
      return user;
    } catch(error) {
      return null;
    }
  }
}
