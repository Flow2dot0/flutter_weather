import 'package:flutter/material.dart';
import 'package:flutter_lite_chat_firebase/screens/register_screen.dart';
import 'package:flutter_lite_chat_firebase/ux/animations.dart';
import 'package:flutter_lite_chat_firebase/widgets/rounded_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, Animations {
  // init animations
  AnimationController _animationController;
  Animation _backgroundColorTween;
  Animation _curvedAnimation;

  @override
  void initState() {
    // required : add mixin [SingleTickerProviderStateMixin] and [Animations]
    // get a controller
    // add [TickerProvider] this
    _animationController = createAnimationController(
        tickerProvider: this, duration: Duration(seconds: 1));
    // choose animation
    _backgroundColorTween = colorTween(
        parent: _animationController,
        beginColor: Colors.blueAccent,
        endColor: Colors.white);
    _curvedAnimation =
        curvedAnimation(parent: _animationController, curve: Curves.decelerate);
    // run animation
    _animationController.forward();
    // update ui
    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // close the animation
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColorTween.value,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset(
                      'images/logo.png',
                    ),
                    height: 150.0 * _curvedAnimation.value,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 90),
                  totalRepeatCount: 2,
                  text: ['Lite Chat'.toUpperCase()],
                  textStyle: GoogleFonts.teko(
                    textStyle: TextStyle(
                        fontSize: 48.0,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100.0,
            ),
            // don't inherit from [Theme]
            RoundedButton(
                animation: _curvedAnimation,
                label: 'Log In',
                color: Colors.blueAccent.shade100,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                }),
            SizedBox(
              height: 20.0,
            ),
            RoundedButton(
                animation: _curvedAnimation,
                label: 'Register',
                color: Colors.blueAccent.shade700,
                onPressed: () {
                  Navigator.pushNamed(context, RegisterScreen.routeName);
                }),
          ],
        ),
      ),
    );
  }
}
