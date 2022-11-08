import 'package:flutter/material.dart';

class Teacher extends StatefulWidget {
  Teacher({super.key, required this.title, required this.list});

  String title;
  List<Widget> list;

  @override
  State<Teacher> createState() => _TeacherState(title, list);
}

class _TeacherState extends State<Teacher> {
  String title;
  List<Widget> list;
  bool isLoading = false;

  _TeacherState(this.title, this.list);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 54, 94, 99),
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
                  child: ListView(children: list))),
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
