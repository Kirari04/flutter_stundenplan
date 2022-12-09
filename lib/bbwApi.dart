// To parse this JSON data, do
//
//     final api = apiFromJson(jsonString);

import 'dart:convert';

class BBWApi {
  BBWApi({
    required this.data,
  });

  List<BBWLesson> data;

  factory BBWApi.fromRawJson(String str) => BBWApi.fromJson(json.decode(str));

  factory BBWApi.fromJson(Map<String, dynamic> json) => BBWApi(
        data: List<BBWLesson>.from(
            json["data"].map((x) => BBWLesson.fromJson(x))),
      );
}

class BBWLesson {
  BBWLesson(
      {this.className,
      this.modul,
      this.teacher,
      this.room,
      this.start,
      this.end});

  String? className;
  String? modul;
  String? teacher;
  String? room;
  String? start;
  String? end;

  factory BBWLesson.fromRawJson(String str) =>
      BBWLesson.fromJson(json.decode(str));

  factory BBWLesson.fromJson(Map<String, dynamic> json) => BBWLesson(
        className: json["class"],
        modul: json["modul"],
        teacher: json["teacher"],
        room: json["room"],
        start: json["start"],
        end: json["end"],
      );
}
