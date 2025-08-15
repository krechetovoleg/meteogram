import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorController {
  Color bColor = const Color.fromARGB(170, 68, 137, 255);
  Color bColorText = const Color.fromARGB(170, 68, 137, 255);
  int intColor = 0;
  var isLoading = true;

  Future<void> initMainColor() async {
    final prefs = await SharedPreferences.getInstance();
    Color col;
    Color colText;

    try {
      col = prefs.getString('bColor') != null
          ? Color(
              int.parse(
                prefs.getString('bColor')!.split('(0x')[1].split(')')[0],
                radix: 16,
              ),
            )
          : const Color.fromARGB(170, 68, 137, 255);

      colText = prefs.getString('bColorText') != null
          ? Color(
              int.parse(
                prefs.getString('bColorText')!.split('(0x')[1].split(')')[0],
                radix: 16,
              ),
            )
          : const Color.fromARGB(170, 68, 137, 255);
    } catch (e) {
      col = const Color.fromARGB(170, 68, 137, 255);
      colText = const Color.fromARGB(170, 68, 137, 255);
    }

    changeMainColor(col);
    changeTextColor(colText);
  }

  void changeMainColor(Color inColor) async {
    try {
      isLoading = true;
      bColor = inColor;
    } finally {
      isLoading = false;
    }
  }

  void changeTextColor(Color inColor) async {
    try {
      isLoading = true;
      bColorText = inColor;
    } finally {
      isLoading = false;
    }
  }
}
