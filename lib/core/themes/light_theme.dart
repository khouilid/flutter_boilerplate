import 'package:flutter/material.dart';
import '../helpers/color_manager.dart';

final lightTheme = ThemeData.light().copyWith(
  primaryColor: AppColors.chateauGreen,
  colorScheme: ColorScheme.light(
    primary: AppColors.chateauGreen,
    secondary: AppColors.scOrange,
    error: AppColors.valentineRed,
    surface: AppColors.white,
    onPrimary: AppColors.white,
    onSecondary: AppColors.white,
    onError: AppColors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: AppColors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.chateauGreen,
    foregroundColor: AppColors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.chateauGreen,
    unselectedItemColor: Colors.grey,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.chateauGreen,
    foregroundColor: AppColors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.chateauGreen,
      foregroundColor: AppColors.white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.chateauGreen,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.grey,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.chateauGreen),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.valentineRed),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
