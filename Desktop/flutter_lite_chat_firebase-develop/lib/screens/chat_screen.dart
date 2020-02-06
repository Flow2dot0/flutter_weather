import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lite_chat_firebase/services/my_firebase.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  MyFirebase _auth = MyFirebase();
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    isConnected();
  }

  void isConnected() async {
    _auth.initAuth();
    user =
        await _auth.getCurrentUser().catchError((e) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.white, Colors.blue])),
      ),
    );
  }
}
