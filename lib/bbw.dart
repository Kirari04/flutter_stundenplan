// ignore_for_file: slash_for_doc_comments

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data_seed.dart';
import 'package:flutter_application_1/bbwApi.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BBWPage extends StatefulWidget {
  const BBWPage({super.key});

  @override
  State<BBWPage> createState() => _BBWPageState();
}

class _BBWPageState extends State<BBWPage> {
  bool isLoading = false;
  bool globalLoading = false;
  DataSeed data = DataSeed();
  BBWApi? api;
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
  Set<String> classNames = <String>{};
  int mapIndex = -1;
  List<Widget> listItems = [];
  bool showFullName = false;
  String dropdownValue = "";

  Future<http.Response> fetchApi() {
    return http.get(Uri.parse(data.bbwApi));
  }

  DateTime parseTime(String input, String date) => DateTime.parse(
      "${DateFormat("yyyy-MM-dd").format(DateTime.parse(date))} $input");
  String stingifyTime(DateTime input) => DateFormat("HH:mm").format(input);

  /**
   * SHOWS DIFFRENT ICONS BASED ON TIME
   */
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

  /**
   * SYNC JOBS
   */
  void setup() async {
    //get cache
    final prefs = await SharedPreferences.getInstance();
    final apiOldData = prefs.getString('bbwApiData');
    setState(() {
      if (apiOldData != null) {
        api = BBWApi.fromRawJson(apiOldData);
        // add classnames
        classNames = <String>{"Show all"};
        for (var el in api!.data) {
          classNames.add(el.className.toString());
        }
        if (dropdownValue == "") {
          final oldDropDownVal = prefs.getString('dropDownVal');
          if (classNames.contains(oldDropDownVal)) {
            dropdownValue = oldDropDownVal.toString();
          } else {
            dropdownValue = classNames.first;
          }
        }
        //order by time
        api!.data.sort((a, b) {
          List<String> aStart = a.start!.split(":");
          List<String> bStart = b.start!.split(":");
          int aMin = int.parse(aStart[0]) * 60 + int.parse(aStart[1]);
          int bMin = int.parse(bStart[0]) * 60 + int.parse(bStart[1]);
          return aMin.compareTo(bMin);
        });
        filterList();
        listItems = listItemsBuild(api!);
      }
    });

    //update cache
    setState(() {
      isLoading = true;
    });
    try {
      http.Response res = await fetchApi();
      if (res.statusCode == 200) {
        BBWApi tmpApi = BBWApi.fromRawJson(res.body);
        if (tmpApi.data.isNotEmpty) {
          prefs.setString('bbwApiData', res.body);
          if (apiOldData == null) {
            setState(() {
              api = tmpApi;
              listItems = listItemsBuild(api!);
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void initStateFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    var showFullNameCache = prefs.getBool('showFullName');
    showFullName = (showFullNameCache == null || showFullNameCache == false)
        ? false
        : true;
  }

  @override
  void initState() {
    super.initState();
    initStateFromCache();
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

  void filterList() {
    if (dropdownValue != "Show all") {
      api!.data = api!.data
          .where((element) => element.className == dropdownValue)
          .toList();
    }
  }

  /**
   * CLICK EVENT HANDLERs
   */

  void selectClass(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('dropDownVal', value);
    setState(() {
      dropdownValue = value;
    });
    setup();
  }

  /**
   * FUNCTIONAL COMPONENT THAT CONVERTS API DATA TO WIDGETS
   */
  List<Widget> listItemsBuild(BBWApi apiData) {
    //reset vars
    isFirstLesson = {};
    lessonTimes = [];
    mapIndex = -1;

    return apiData.data.map((datum) {
      mapIndex++;
      /**
       * CALCULATIONS ON EACH ROW
       */

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
                          color:
                              DataSeed.getCourseColor(datum.modul.toString()),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0))),
                      height: 40,
                      width: showFullName ? 320 : 60,
                      child: Stack(clipBehavior: Clip.none, children: [
                        InkWell(
                          onTap: () => setState(() {
                            showFullName = (showFullName) ? false : true;
                            listItems = listItemsBuild(apiData);
                            SharedPreferences.getInstance().then((value) =>
                                value.setBool("showFullName", showFullName));
                          }),
                          child: Center(
                            child: ((datum.modul != null)
                                ? Wrap(
                                    children: [
                                      Text(
                                        showFullName
                                            ? "${(RegExp(r'^[0-9]{1,4}$').hasMatch(datum.modul.toString()) ? 'Modul' : '')} ${datum.modul} bei "
                                            : datum.modul.toString(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        showFullName
                                            ? datum.teacher.toString()
                                            : '',
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 229, 206, 255)),
                                      )
                                    ],
                                  )
                                : const Icon(
                                    Icons.question_mark_rounded,
                                    color: Colors.white,
                                  )),
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
                              // child: iconTimex(
                              //     parseTime(datum.start.toString(),
                              //         datum.lessonDate.toString()),
                              //     parseTime(datum.lessonEnd.toString(),
                              //         datum.lessonDate.toString())),
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
                            datum.room.toString(),
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            datum.className.toString(),
                            style: const TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        /**
                         * ROW TIME
                         */
                        Text(
                          "${datum.start} - ${datum.end}",
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
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

      return listTile;
    }).toList();
  }

  /**
   * PAGE
   */
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            height: double.infinity,
            child: ((api.runtimeType != BBWApi || listItems.isEmpty)
                ? Center(
                    child: const Text(
                      "Momentan sind keine Daten online",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : ListView(children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: const Text(
                        "BBW Stundenplan aller Klassen.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: const Text(
                        "Dieser Stundenplan zeigt die Zimmerbelegung aller Klassen des aktuellen Tages.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          selectClass(value!);
                        },
                        items: classNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    ...listItems
                  ]))),
        Positioned(
            top: 10,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: (isLoading || globalLoading)
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
              ),
            ))
      ],
    );
  }
}
