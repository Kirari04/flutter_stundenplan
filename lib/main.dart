import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'data_seed.dart';
import 'api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  DataSeed data = DataSeed();
  Api? api;
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

  Future<http.Response> fetchApi() {
    return http.get(Uri.parse(data.api));
  }

  DateTime parseTime(String input, String date) => DateTime.parse(
      "${DateFormat("yyyy-MM-dd").format(DateTime.parse(date))} $input");
  String stingifyTime(DateTime input) => DateFormat("hh:mm").format(input);

  Widget iconTimex(DateTime start, DateTime end) {
    DateTime now = DateTime.now();
    if (now.isBefore(start)) {
      // wait
      return const Icon(
        Icons.timelapse_rounded,
        color: Colors.white,
      );
    } else if (now.isAfter(start) && now.isBefore(end)) {
      //pending
      return const Icon(
        Icons.pending_rounded,
        color: Colors.white,
      );
    } else if (now.isAfter(end)) {
      //fin
      return const Icon(
        Icons.done,
        color: Colors.white,
      );
    } else {
      return const Icon(
        Icons.error,
        color: Colors.white,
      );
    }
  }

  void setup() async {
    //get cache
    final prefs = await SharedPreferences.getInstance();
    final apiOldData = prefs.getString('apiData');
    setState(() {
      if (apiOldData != null) {
        api = Api.fromRawJson(apiOldData);
        listItems = listItemsBuild();
      }
    });

    //update cache
    setState(() {
      isLoading = true;
    });
    http.Response res = await fetchApi();
    if (res.statusCode == 200) {
      Api tmpApi = Api.fromRawJson(res.body);
      if (tmpApi.status == 1) {
        prefs.setString('apiData', res.body);
        if (apiOldData == null) {
          setState(() {
            api = tmpApi;
            listItems = listItemsBuild();
          });
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      // here run refresh etc
      setup();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '2I Stundenplan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          backgroundColor: Colors.black12,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
                backgroundColor: Colors.black,
                title: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          data.title,
                          style: const TextStyle(color: Colors.white),
                        )),
                    Expanded(
                        flex: 0,
                        child: Container(
                          child: (isLoading == true)
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const SizedBox.shrink(),
                        ))
                  ],
                )),
          ),
          body: Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              height: double.infinity,
              child: ((api.runtimeType != Api)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(children: listItems))),
        ));
  }

  List<Widget> listItemsBuild() {
    //reset vars
    isFirstLesson = {};
    lessonTimes = [];
    mapIndex = -1;

    return (api == null)
        ? []
        : api!.data.map((datum) {
            mapIndex++;
            /**
       * CALCULATIONS ON EACH ROW
       */
            bool showWeekDay =
                (isFirstLesson[datum.lessonDate.toString()] == null)
                    ? true
                    : false;
            bool isActiveDay = (DateFormat('yyyy-MM-dd')
                        .format(DateTime.now()) ==
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(datum.lessonDate.toString())))
                ? true
                : false;
            int currentTimestamp = parseTime(
                    datum.lessonStart.toString(), datum.lessonDate.toString())
                .microsecondsSinceEpoch;
            int endTimestamp = parseTime(
                    datum.lessonEnd.toString(), datum.lessonDate.toString())
                .microsecondsSinceEpoch;

            int currentPause = 0;
            bool showPauseBefore = ((mapIndex * 2) - 1 < 0 ||
                    lessonTimes.length <= (mapIndex * 2) - 1 ||
                    // check if dif between latest added... time & current ... time
                    // currentTimestamp - 6e+8 >
                    //     lessonTimes[(mapIndex * 2) - 1] ||
                    //check if is negativ (might bi parallel times)
                    currentTimestamp - lessonTimes[(mapIndex * 2) - 1] < 0)
                ? false
                : true;
            if (showPauseBefore) {
              currentPause =
                  ((currentTimestamp - lessonTimes[(mapIndex * 2) - 1]) /
                          60000000)
                      .round();
            }
            lessonTimes.add(currentTimestamp);
            lessonTimes.add(endTimestamp);
            isFirstLesson[datum.lessonDate.toString()] = true;
            int intWeekDay =
                DateTime.parse(datum.lessonDate.toString()).weekday;
            String weekDay = weekdays[intWeekDay].toString();

            ListTile listTile = ListTile(
              /**
                         * ROW ICON
                         */
              leading: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(59, 59, 59, 0.3),
                            blurRadius: 10,
                            spreadRadius: 5)
                      ],
                      color:
                          DataSeed.getCourseColor(datum.courseName.toString()),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0))),
                  height: 40,
                  width: 40,
                  child: Center(
                    child: ((datum.courseName != null)
                        ? Text(
                            datum.courseName.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )
                        : const Icon(
                            Icons.question_mark_rounded,
                            color: Colors.white,
                          )),
                  )),
              title: Row(children: [
                /**
                 * ROW TIME
                 */
                Expanded(
                    flex: 0,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Text(
                        datum.roomName.toString(),
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )),
                /**
                 * ROW TIME
                 */
                Expanded(
                    flex: 1,
                    child: Text(
                      "${stingifyTime(parseTime(datum.lessonStart.toString(), datum.lessonDate.toString()))} - ${stingifyTime(parseTime(datum.lessonEnd.toString(), datum.lessonDate.toString()))}",
                      style: const TextStyle(color: Colors.white),
                    )),
                /**
                 * ROW STATUS
                 */
                Expanded(
                    flex: 0,
                    child: Row(
                      children: [
                        iconTimex(
                            parseTime(datum.lessonStart.toString(),
                                datum.lessonDate.toString()),
                            parseTime(datum.lessonEnd.toString(),
                                datum.lessonDate.toString())),
                      ],
                    ))
              ]),
            );

            if (showWeekDay) {
              return Column(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Text(
                        weekDay,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: (isActiveDay == true)
                                ? Colors.green
                                : Colors.white),
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
}
