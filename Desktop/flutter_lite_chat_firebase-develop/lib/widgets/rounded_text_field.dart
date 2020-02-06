import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final TextInputType keyboard;
  final String hintText;
  final Function onChanged;
  final Color color1;
  final Color color2;
  final bool obscureText;

  const RoundedTextField(
      {Key key,
      this.keyboard = TextInputType.emailAddress,
      this.hintText = 'Write something',
      this.obscureText = false,
      @required this.onChanged,
      this.color1,
      this.color2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          borderSide: BorderSide(color: color1, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          borderSide: BorderSide(color: color2, width: 2.0),
        ),
      ),
    );
  }
}
