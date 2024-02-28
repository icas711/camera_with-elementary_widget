

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF0C9869);
const kSelectedColor = Color(0xFF156e50);
const kTextColor = Color(0xFF3C4046);
const kBackgroundColor = Color(0xFFF7F6FC);
const kFontWeight = FontWeight.w700;
const double kDefaultPadding = 20.0;

abstract class ThemeText {
  static const TextStyle progressHeader = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w600);

  static const TextStyle progressBody = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.blueAccent,
      fontSize: 12,
      fontWeight: FontWeight.w400);

  static const TextStyle progressFooter = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w600);

  static const TextStyle ercCardheader = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700);

  static const TextStyle ercCard = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400);

  static const TextStyle sliverText = TextStyle(
      fontFamily: 'Montserrat',
      color: kPrimaryColor,
      fontSize: 20,
      fontWeight: FontWeight.w400);
  static const TextStyle buttonText = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w400);
  static const TextStyle sliverTextHeader = TextStyle(
      fontFamily: 'Montserrat',
      color: kPrimaryColor,
      fontSize: 22,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 2.0,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ],
      fontWeight: FontWeight.w400);

  static const TextStyle splashHead = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w400);

  static const TextStyle bottommenu = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none
  );

  static const TextStyle logo = TextStyle(
      fontFamily: 'MaterialIcons',
      color: Colors.blueAccent,
      fontSize: 40,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none
  );


  static const TextStyle welcome = TextStyle(
      fontFamily: 'Montserrat',
      color: kPrimaryColor,
      fontSize: 30,
      decoration: TextDecoration.none,

      fontWeight: FontWeight.w600);

  static const TextStyle descr = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 16,
      decoration: TextDecoration.none,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(.5, .5),
          blurRadius: 2.0,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ],
      fontWeight: FontWeight.w300);

  static const TextStyle grid = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black54,
      fontSize: 8,
      fontWeight: FontWeight.w400);
}
