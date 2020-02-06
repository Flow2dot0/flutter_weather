import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Color color;
  final Function onPressed;
  final Animation animation;

  const RoundedButton(
      {Key key,
      @required this.label,
      this.color,
      @required this.onPressed,
      this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 5.0,
      constraints: BoxConstraints.tightFor(
        height: 55.0,
        width: MediaQuery.of(context).size.width * (animation?.value ?? 1),
      ),
      onPressed: onPressed,
      fillColor: color,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
    );
  }
}
