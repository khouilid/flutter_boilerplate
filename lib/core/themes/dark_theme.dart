import 'package:flutter/material.dart';
import '../helpers/color_manager.dart';

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: AppColors.chateauGreen,
  colorScheme: ColorScheme.dark(
    primary: AppColors.chateauGreen,
    secondary: AppColors.scOrange,
    error: AppColors.valentineRed,
    surface: const Color(0xFF121212),
    onPrimary: AppColors.white,
    onSecondary: AppColors.white,
    onError: AppColors.white,
    onSurface: AppColors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: AppColors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1F1F1F),
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
    color: AppColors.white,
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
