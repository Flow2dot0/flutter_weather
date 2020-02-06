import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lite_chat_firebase/widgets/rounded_button.dart';
import 'package:flutter_lite_chat_firebase/widgets/rounded_text_field.dart';
import 'package:flutter_lite_chat_firebase/services/my_firebase.dart';

import 'chat_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset(
                    'images/logo.png',
                  ),
                  height: 400.0,
                ),
              ),
            ),
            // TODO : continue...
            RoundedTextField(
              keyboard: TextInputType.emailAddress,
              color1: Colors.blueAccent.shade100,
              color2: Colors.blueAccent.shade700,
              hintText: 'Enter your email',
              onChanged: (String v) {
                email = v;
                print(email);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            RoundedTextField(
              obscureText: true,
              color1: Colors.blueAccent.shade100,
              color2: Colors.blueAccent.shade700,
              hintText: 'Enter your password',
              onChanged: (String v) {
                password = v;
                print(password);
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              label: 'Register !',
              onPressed: () async {
                MyFirebase fbInstance = MyFirebase();
                fbInstance.initAuth();
                await fbInstance
                    .registerUser(emailStr: email, password: password)
                    .then((FirebaseUser user) =>
                        Navigator.pushNamed(context, ChatScreen.routeName))
                    .catchError((e) => print(e));
              },
              color: Colors.blueAccent.shade700,
            )
          ],
        ),
      ),
    );
  }
}
