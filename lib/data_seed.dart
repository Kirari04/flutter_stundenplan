import 'package:flutter/material.dart';

class DataSeed {
  String title = "2I Stundenplan";

  String api = "https://kbw.senpai.one/tmp.json";
  String teacherApi = "https://kbw.senpai.one/api/teacher.php?teacher=";

  String licenceApi =
      "https://raw.githubusercontent.com/Kirari04/flutter_stundenplan/master/LICENSE";

  static Color getCourseColor(String course) {
    switch (course.toUpperCase()) {
      case "D":
        return const Color(0xFFD9042B);
      case "F":
        return const Color(0xFF0476D9);
      case "G":
        return const Color(0xFFA6036D);
      case "WR":
        return const Color(0xFFF2B705);
      case "TUU":
        return const Color(0xFFE08424);
      case "M":
        return const Color(0xFF0E17E0);
      case "E":
        return const Color(0xFF5FDE88);
      case "RW":
        return const Color(0xFFE093DC);
      case "S":
        return const Color(0xFF0DE0DC);
      default:
        return const Color.fromARGB(255, 143, 143, 143);
    }
  }
}
