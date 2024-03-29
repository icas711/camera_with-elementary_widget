import 'package:flutter/material.dart';

class MultiColorTween extends Tween<Color> {

  final List<Color> spectrum = [Colors.black,Colors.white,Colors.blue,Colors.red,Colors.green];


  @override
  Color transform(double t) {
    if (t == 0.0) {
      return spectrum[0];
    }
    if (t == 1.0) {
      return spectrum[spectrum.length - 2];
    }
    return lerp(t);
  }

  @override
  Color lerp(double t) {
    assert(t <= 1.0);
    assert(t >= 0.0);
    // Find where in our spectrum does `t` lie at
    final index = t * (spectrum.length - 1);

    // Floor is our start color, Ceil is our end color
    final colorIndex1 = index.floor();
    final colorIndex2 = (spectrum.length!=colorIndex1 + 1)?colorIndex1 + 1:colorIndex1 - 1;

    // Calculate where between these two colors, our color lies at. i.e. new `t` between the two colors
    final tweenOffset = index - colorIndex1;

    // Return the lerped color, or return the first color
    return Color.lerp(
        spectrum[colorIndex1], spectrum[colorIndex2], tweenOffset) ??
        spectrum[colorIndex1];
  }
}