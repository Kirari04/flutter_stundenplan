// To parse this JSON data, do
//
//     final api = apiFromJson(jsonString);

import 'dart:convert';

class Api {
  Api({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory Api.fromRawJson(String str) => Api.fromJson(json.decode(str));

  factory Api.fromJson(Map<String, dynamic> json) => Api(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    required this.id,
    required this.timetableElementId,
    this.holidayId,
    this.blockId,
    this.blockTeacherId,
    this.blockClassId,
    this.blockRoomId,
    this.modId,
    this.periodId,
    this.start,
    this.end,
    this.lessonDate,
    this.lessonStart,
    this.lessonEnd,
    this.lessonDuration,
    this.nbrOfModifiedLessons,
    this.connectedId,
    this.isAllDay,
    this.timetableEntryTypeId,
    this.timetableEntryType,
    this.timetableEntryTypeLong,
    this.timetableEntryTypeShort,
    this.messageId,
    this.message,
    this.output,
    this.title,
    this.halfClassLesson,
    this.courseId,
    this.courseName,
    this.course,
    this.courseLong,
    this.isExamLesson,
    this.isCheckedLesson,
    this.lessonAbsenceCount,
    this.subjectId,
    this.subjectName,
    this.timegridId,
    this.classId,
    this.className,
    this.profileId,
    this.teamId,
    this.teacherId,
    this.teacherAcronym,
    this.teacherFullName,
    this.teacherLastname,
    this.teacherFirstname,
    this.connectedTeacherId,
    this.connectedTeacherFullName,
    this.student,
    this.studentId,
    this.studentFullName,
    this.studentLastname,
    this.studentFirstname,
    this.roomId,
    this.roomName,
    this.locationDescription,
    this.resourceId,
    this.timetableClassBookId,
    this.hasHomework,
    this.hasHomeworkFiles,
    this.hasExam,
    this.hasExamFiles,
    this.privileges,
    this.resource,
    this.reservedResources,
    this.totalStock,
    this.school,
    this.relatedId,
  });

  int? id;
  int? timetableElementId;
  int? holidayId;
  List<int>? blockId;
  List<int?>? blockTeacherId;
  List<int?>? blockClassId;
  List<int?>? blockRoomId;
  int? modId;
  int? periodId;
  String? start;
  String? end;
  DateTime? lessonDate;
  String? lessonStart;
  String? lessonEnd;
  String? lessonDuration;
  String? nbrOfModifiedLessons;
  int? connectedId;
  int? isAllDay;
  int? timetableEntryTypeId;
  String? timetableEntryType;
  String? timetableEntryTypeLong;
  String? timetableEntryTypeShort;
  int? messageId;
  String? message;
  String? output;
  String? title;
  int? halfClassLesson;
  int? courseId;
  String? courseName;
  String? course;
  String? courseLong;
  bool? isExamLesson;
  bool? isCheckedLesson;
  int? lessonAbsenceCount;
  int? subjectId;
  String? subjectName;
  int? timegridId;
  List<int?>? classId;
  String? className;
  String? profileId;
  String? teamId;
  List<int?>? teacherId;
  String? teacherAcronym;
  List<String?>? teacherFullName;
  String? teacherLastname;
  String? teacherFirstname;
  List<int?>? connectedTeacherId;
  List<String?>? connectedTeacherFullName;
  List<Student?>? student;
  List<int?>? studentId;
  String? studentFullName;
  String? studentLastname;
  String? studentFirstname;
  List<int?>? roomId;
  String? roomName;
  String? locationDescription;
  List<int?>? resourceId;
  int? timetableClassBookId;
  bool? hasHomework;
  bool? hasHomeworkFiles;
  bool? hasExam;
  bool? hasExamFiles;
  List<String?>? privileges;
  String? resource;
  int? reservedResources;
  int? totalStock;
  String? school;
  List<String?>? relatedId;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        timetableElementId: json["timetableElementId"],
        holidayId: json["holidayId"],
        blockId: json["blockId"] == null
            ? null
            : List<int>.from(json["blockId"].map((x) => x)),
        blockTeacherId: json["blockTeacherId"] == null
            ? null
            : List<int>.from(json["blockTeacherId"].map((x) => x)),
        blockClassId: json["blockClassId"] == null
            ? null
            : List<int>.from(json["blockClassId"].map((x) => x)),
        blockRoomId: json["blockRoomId"] == null
            ? null
            : List<int>.from(json["blockRoomId"].map((x) => x)),
        modId: json["modId"],
        periodId: json["periodId"],
        start: json["start"],
        end: json["end"],
        lessonDate: json["lessonDate"] == null
            ? null
            : DateTime.parse(json["lessonDate"]),
        lessonStart: json["lessonStart"],
        lessonEnd: json["lessonEnd"],
        lessonDuration: json["lessonDuration"],
        nbrOfModifiedLessons: json["nbrOfModifiedLessons"],
        connectedId: json["connectedId"],
        isAllDay: json["isAllDay"],
        timetableEntryTypeId: json["timetableEntryTypeId"],
        timetableEntryType: json["timetableEntryType"],
        timetableEntryTypeLong: json["timetableEntryTypeLong"],
        timetableEntryTypeShort: json["timetableEntryTypeShort"],
        messageId: json["messageId"],
        message: json["message"],
        output: json["output"],
        title: json["title"],
        halfClassLesson: json["halfClassLesson"],
        courseId: json["courseId"],
        courseName: json["courseName"],
        course: json["course"],
        courseLong: json["courseLong"],
        isExamLesson: json["isExamLesson"],
        isCheckedLesson: json["isCheckedLesson"],
        lessonAbsenceCount: json["lessonAbsenceCount"],
        subjectId: json["subjectId"],
        subjectName: json["subjectName"],
        timegridId: json["timegridId"],
        classId: json["classId"] == null
            ? null
            : List<int>.from(json["classId"].map((x) => x)),
        className: json["className"],
        profileId: json["profileId"],
        teamId: json["teamId"],
        teacherId: json["teacherId"] == null
            ? null
            : List<int>.from(json["teacherId"].map((x) => x)),
        teacherAcronym: json["teacherAcronym"],
        teacherFullName: json["teacherFullName"] == null
            ? null
            : List<String>.from(json["teacherFullName"].map((x) => x)),
        teacherLastname: json["teacherLastname"],
        teacherFirstname: json["teacherFirstname"],
        connectedTeacherId: json["connectedTeacherId"] == null
            ? null
            : List<int>.from(json["connectedTeacherId"].map((x) => x)),
        connectedTeacherFullName: json["connectedTeacherFullName"] == null
            ? null
            : List<String>.from(json["connectedTeacherFullName"].map((x) => x)),
        student: json["student"] == null
            ? null
            : List<Student>.from(
                json["student"].map((x) => Student.fromJson(x))),
        studentId: json["studentId"] == null
            ? null
            : List<int>.from(json["studentId"].map((x) => x)),
        studentFullName: json["studentFullName"],
        studentLastname: json["studentLastname"],
        studentFirstname: json["studentFirstname"],
        roomId: json["roomId"] == null
            ? null
            : List<int>.from(json["roomId"].map((x) => x)),
        roomName: json["roomName"],
        locationDescription: json["locationDescription"],
        resourceId: json["resourceId"] == null
            ? null
            : List<int>.from(json["resourceId"].map((x) => x)),
        timetableClassBookId: json["timetableClassBookId"],
        hasHomework: json["hasHomework"],
        hasHomeworkFiles: json["hasHomeworkFiles"],
        hasExam: json["hasExam"],
        hasExamFiles: json["hasExamFiles"],
        privileges: json["privileges"] == null
            ? null
            : List<String>.from(json["privileges"].map((x) => x)),
        resource: json["resource"],
        reservedResources: json["reservedResources"],
        totalStock: json["totalStock"],
        school: json["school"],
        relatedId: json["relatedId"] == null
            ? null
            : List<String>.from(json["relatedId"].map((x) => x)),
      );
}

class Student {
  Student({
    required this.studentId,
    this.studentName,
  });

  int studentId;
  String? studentName;

  factory Student.fromRawJson(String str) => Student.fromJson(json.decode(str));

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        studentId: json["studentId"],
        studentName: json["studentName"],
      );
}
