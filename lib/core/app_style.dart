import 'package:flutter/material.dart';

class AppStyle {
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
  );
}

class AppColors {
  static const background = Colors.black;
  static const primary = Color(0xffD10713);
  static const white = Colors.white;
  static const grey = Colors.grey;
  static const background_gradient = LinearGradient(
    colors: [Color(0xff39101E), AppColors.background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
