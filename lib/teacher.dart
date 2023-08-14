// ignore_for_file: slash_for_doc_comments

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/api.dart';
import 'package:flutter_application_1/data_seed.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key, required this.teacherId, required this.title});

  final int teacherId;
  final String title;

  @override
  State<Teacher> createState() => _TeacherState(teacherId, title);
}

class _TeacherState extends State<Teacher> {
  final String title;
  final int teacherId;
  Api? api;
  bool isLoading = false;
  DataSeed data = DataSeed();
  Map<String, bool> isFirstLesson = {};
  Map<int, String> weekdays = {
    1: "Montag",
    2: "Dienstag",
    3: "Mittwoch",
    4: "Donnerstag",
    5: "Freitag",
    6: "Samstag",
    7: "Sonntag",
  };
  Timer? timer;
  List<int> lessonTimes = [];
  int mapIndex = -1;
  List<Widget> listItems = [];
  bool showFullName = false;

  _TeacherState(this.teacherId, this.title);

  Future<http.Response> fetchTeacherApi(int teacherId, String? school) {
    return http
        .get(Uri.parse("${data.teacherApi}$teacherId&school=${school!}"));
  }

  DateTime parseTime(String input, String date) => DateTime.parse(
      "${DateFormat("yyyy-MM-dd").format(DateTime.parse(date))} $input");
  String stingifyTime(DateTime input) => DateFormat("HH:mm").format(input);

  @override
  void initState() {
    super.initState();
    initStateFromCache();
    loadTeacher();
  }

  void initStateFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    var showFullNameCache = prefs.getBool('showFullName');
    showFullName = (showFullNameCache == null || showFullNameCache == false)
        ? false
        : true;
  }

  void loadTeacher() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final school = prefs.getString('school');
    final apiOldData = prefs.getString('apiDataTeacher$teacherId');
    if (apiOldData != null) {
      Api tmpCacheApi = Api.fromRawJson(apiOldData);
      api = tmpCacheApi;
      setState(() {
        listItems = listItemsBuild(tmpCacheApi);
      });
    }

    http.Response res = await fetchTeacherApi(teacherId, school);
    if (res.statusCode == 200) {
      Api tmpApi = Api.fromRawJson(res.body);
      if (tmpApi.status == 1) {
        prefs.setString('apiDataTeacher$teacherId', res.body);
        api = tmpApi;
        setState(() {
          listItems = listItemsBuild(tmpApi);
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  /**
   * CLICK EVENT HANDLERs
   */
  void openTeacher(int teacherId, String teacherFullName) async {
    Navigator.of(context).push(MaterialPageRoute(
      settings: RouteSettings(name: "/teacher/$teacherId"),
      builder: (_) {
        return Teacher(
          title: teacherFullName,
          teacherId: teacherId,
        );
      },
    ));
  }

  Widget iconTimex(DateTime start, DateTime end) {
    double size = 16;
    DateTime now = DateTime.now();
    if (now.isBefore(start)) {
      // wait
      return Icon(
        Icons.timelapse_rounded,
        color: Colors.white,
        size: size,
      );
    } else if (now.isAfter(start) && now.isBefore(end)) {
      //pending
      return Icon(
        Icons.pending_rounded,
        color: Colors.white,
        size: size,
      );
    } else if (now.isAfter(end)) {
      //fin
      return Icon(
        Icons.done,
        color: Colors.white,
        size: size,
      );
    } else {
      return Icon(
        Icons.error,
        color: Colors.white,
        size: size,
      );
    }
  }

  List<Widget> listItemsBuild(Api apiData) {
    //reset vars
    isFirstLesson = {};
    lessonTimes = [];
    mapIndex = -1;

    return apiData.data.map((datum) {
      mapIndex++;
      /**
       * CALCULATIONS ON EACH ROW
       */
      bool showWeekDay =
          (isFirstLesson[datum.lessonDate.toString()] == null) ? true : false;
      bool isActiveDay = (DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(datum.lessonDate.toString())))
          ? true
          : false;
      int currentTimestamp =
          parseTime(datum.lessonStart.toString(), datum.lessonDate.toString())
              .microsecondsSinceEpoch;
      int endTimestamp =
          parseTime(datum.lessonEnd.toString(), datum.lessonDate.toString())
              .microsecondsSinceEpoch;

      int currentPause = 0;
      bool showPauseBefore = ((mapIndex * 2) - 1 < 0 ||
              lessonTimes.length <= (mapIndex * 2) - 1 ||
              currentTimestamp - lessonTimes[(mapIndex * 2) - 1] < 0)
          ? false
          : true;
      if (showPauseBefore) {
        currentPause =
            ((currentTimestamp - lessonTimes[(mapIndex * 2) - 1]) / 60000000)
                .round();
      }
      lessonTimes.add(currentTimestamp);
      lessonTimes.add(endTimestamp);
      isFirstLesson[datum.lessonDate.toString()] = true;
      int intWeekDay = DateTime.parse(datum.lessonDate.toString()).weekday;
      String weekDay = weekdays[intWeekDay].toString();

      /**
       * TILE
       */
      ListTile listTile = ListTile(
        title: Flex(direction: Axis.horizontal, children: [
          Expanded(
              flex: 1,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  /**
                   * ROW ICON
                   */
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(59, 59, 59, 0.3),
                                blurRadius: 10,
                                spreadRadius: 5)
                          ],
                          color: DataSeed.getCourseColor(
                              datum.courseName.toString()),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0))),
                      height: 40,
                      width: showFullName ? 220 : 40,
                      child: Stack(clipBehavior: Clip.none, children: [
                        InkWell(
                          onTap: () => setState(() {
                            showFullName = (showFullName) ? false : true;
                            listItems = listItemsBuild(apiData);
                            SharedPreferences.getInstance().then((value) =>
                                value.setBool("showFullName", showFullName));
                          }),
                          child: Center(
                            child: ((datum.courseName != null)
                                ? Text(
                                    showFullName
                                        ? datum.subjectName.toString()
                                        : datum.courseName.toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                : ((datum.title != null)
                                    ? (showFullName
                                        ? Text(
                                            datum.title.toString(),
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          )
                                        : const Icon(
                                            Icons.more,
                                            color: Colors.red,
                                          ))
                                    : const Icon(
                                        Icons.question_mark_rounded,
                                        color: Colors.white,
                                      ))),
                          ),
                        ),
                        Positioned(
                            right: -10,
                            bottom: -10,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(999))),
                              padding: const EdgeInsets.all(5),
                              child: datum.timetableEntryTypeShort == "cancel"
                                  ? const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                      size: 15,
                                    )
                                  : iconTimex(
                                      parseTime(datum.lessonStart.toString(),
                                          datum.lessonDate.toString()),
                                      parseTime(datum.lessonEnd.toString(),
                                          datum.lessonDate.toString())),
                            )),
                      ])),
                  /**
                   * ROW TIME
                   */
                  Container(
                    height: 40,
                    padding: const EdgeInsets.all(14),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            datum.roomName.toString(),
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        /**
                         * ROW TIME
                         */
                        Text(
                          "${stingifyTime(parseTime(datum.lessonStart.toString(), datum.lessonDate.toString()))} - ${stingifyTime(parseTime(datum.lessonEnd.toString(), datum.lessonDate.toString()))}",
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                        )
                      ],
                    ),
                  )
                ],
              )),
          /**
           * ROW Functions
           */
          Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(left: 10),
              child: Wrap(
                direction: Axis.vertical,
                spacing: 10,
                children: [
                  ...datum.teacherId!
                      .where((teacherTmpId) => (teacherTmpId != teacherId))
                      .map((teacherId) {
                    String teachersFullName = datum
                        .teacherFullName![datum.teacherId!.indexOf(teacherId)]!;
                    String initials = teachersFullName
                        .split(" ")
                        .map((e) => e[0])
                        .join("")
                        .toUpperCase();
                    return ElevatedButton(
                        onPressed: () {
                          openTeacher(teacherId!, teachersFullName);
                        },
                        child: Row(
                          children: [
                            Text(initials),
                            const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                            )
                          ],
                        ));
                  }),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 2, bottom: 2),
                    child: Row(
                      children: [
                        Text(
                          datum.className.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        const Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )
                ],
              )),
        ]),
      );

      /**
       * ADDITIONAL INFOS
       */
      if (showWeekDay) {
        return Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text(
                  weekDay,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color:
                          (isActiveDay == true) ? Colors.green : Colors.white),
                )),
            listTile
          ],
        );
      }

      if (showPauseBefore) {
        return Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                width: double.infinity,
                child: Text(
                  "$currentPause min Pause",
                  style: const TextStyle(color: Colors.white),
                )),
            listTile
          ],
        );
      }

      return listTile;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 54, 94, 99),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
              backgroundColor: Colors.black,
              title: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        title,
                        style: const TextStyle(color: Colors.white),
                      )),
                ],
              )),
        ),
        body: Stack(children: [
          Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              height: double.infinity,
              child: Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView(children: listItems))),
          Positioned(
              top: 10,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: (isLoading)
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink(),
                ),
              ))
        ]));
  }
}
