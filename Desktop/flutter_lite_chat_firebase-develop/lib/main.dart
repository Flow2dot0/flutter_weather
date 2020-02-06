import 'package:flutter/material.dart';
import 'package:flutter_lite_chat_firebase/screens/chat_screen.dart';
import 'package:flutter_lite_chat_firebase/screens/home_screen.dart';
import 'package:flutter_lite_chat_firebase/screens/login_screen.dart';
import 'package:flutter_lite_chat_firebase/screens/register_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        ChatScreen.routeName: (context) => ChatScreen(),
      },
    );
  }
}
