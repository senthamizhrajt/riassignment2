import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/color_extensions.dart';
import 'app_colors.dart';

class LightTheme {
  static const String appFontFamily = 'Roboto';
  ThemeData get() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primaryColor),
      inputDecorationTheme: const InputDecorationTheme(hintStyle: TextStyle(color: Color(0xFF949C9E))),
      dividerColor: const Color(0xFFF2F2F2),
      dividerTheme: const DividerThemeData(color: Color(0xFFF2F2F2)),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
      ),
      dialogTheme: const DialogTheme(backgroundColor: Colors.white),
    );
  }
}
