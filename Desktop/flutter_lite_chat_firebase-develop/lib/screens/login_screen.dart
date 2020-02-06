import 'package:flutter/material.dart';
import 'package:flutter_lite_chat_firebase/widgets/rounded_button.dart';
import 'package:flutter_lite_chat_firebase/widgets/rounded_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset(
                  'images/logo.png',
                ),
                height: 400.0,
              ),
            ),
            // TODO : continue...
            RoundedTextField(
              color1: Colors.blueAccent.shade100,
              color2: Colors.blueAccent.shade400,
              hintText: 'Enter your email',
              onChanged: (String email) {},
            ),
            SizedBox(
              height: 10.0,
            ),
            RoundedTextField(
              color1: Colors.blueAccent.shade100,
              color2: Colors.blueAccent.shade400,
              hintText: 'Enter your password',
              onChanged: (String password) {},
            ),
            SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              label: 'Go !',
              onPressed: () {},
              color: Colors.blueAccent.shade100,
            )
          ],
        ),
      ),
    );
  }
}
