import 'package:flutter/material.dart';

mixin Animations {
  AnimationController createAnimationController(
          {@required TickerProvider tickerProvider,
          @required Duration duration}) =>
      AnimationController(vsync: tickerProvider, duration: duration);

  Animation colorTween({
    @required AnimationController parent,
    @required Color beginColor,
    @required Color endColor,
  }) =>
      ColorTween(begin: beginColor, end: endColor).animate(parent);

  Animation curvedAnimation(
          {@required AnimationController parent, @required Curve curve}) =>
      CurvedAnimation(parent: parent, curve: curve);
}
