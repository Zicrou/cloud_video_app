import 'package:flutter/material.dart';

abstract class AppColors {
  static const darkGreenColor = Color(0xFF2a6559);
  static const lightRedColor = Color(0xFFfbd7d3);
  static const darkBlueColor = Color(0xFF045664);
  static const lightBlueColor = Color(0xFF385867);
  static const brownColor = Color(0xFF682d05);
  static const greyColor = Color(0xffe0e1e1);
  static const lightGreyColor = Color(0xffe8e6e0);

  //static const primaryColor = Color(0xFFa73f72);
  static const primaryColor = Color.fromARGB(255, 0, 173, 253);
  static const secondaryColor = Color(0xFF80c6ce);
  static const backgroundColor = greyColor;
  static const tertiaryColor = brownColor;
  static const textColor = Color.fromRGBO(61, 82, 136, 1);
  static const buttonColor = Color.fromRGBO(27, 88, 241, 1.0);
  static const whiteColor = Color(0xFFFAFAFB);
  static const appBarColor = darkBlueColor;
  static const blackColor = Color(0xFF050505);
  static const errorColor = Color(0xFFF33B3B);
  static const backgroundWallet = lightRedColor;
  static const polylineColor = Colors.blue;
  static const shadowColor = Colors.black87;
  static const cardColor = Color(0xFFEDF0F3);
  static const textBoxColor = Color(0xFFe9e9e9);
  static const darker = Color(0xFF8D8D8D);
  static const completeColor = Color.fromARGB(255, 182, 56, 56);
  static const inProgressColor = Color(0XFF056174);
  static const todoColor = Color(0xffd1d2d7);

  static List<Color> selectedBackgroundColor = <Color>[
    AppColors.secondaryColor,
  ];

  static List<Color> unSelectedBackgroundColor = <Color>[AppColors.whiteColor];
}
