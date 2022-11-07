import 'package:flutter/material.dart';

class DataSeed {
  String title = "2I Stundenplan";

  String api = "https://kbw.senpai.one/tmp.json";

  static Color getCourseColor(String course) {
    switch (course.toUpperCase()) {
      case "D":
        return Color(0xFFD9042B);
      case "F":
        return Color(0xFF0476D9);
      case "G":
        return Color(0xFFA6036D);
      case "WR":
        return Color(0xFFF2B705);
      case "TUU":
        return Color(0xFFE08424);
      case "M":
        return Color(0xFF0E17E0);
      case "E":
        return Color(0xFF5FDE88);
      case "RW":
        return Color(0xFFE093DC);
      case "S":
        return Color(0xFF0DE0DC);
      default:
        return Color.fromARGB(255, 143, 143, 143);
    }
  }
}
