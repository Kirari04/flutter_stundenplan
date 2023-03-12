import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bbw.dart';
import 'package:flutter_application_1/data_seed.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/license.dart';
import 'package:flutter_application_1/versionChecker.dart';

import 'login.dart';

class LocalRouter extends StatefulWidget {
  const LocalRouter({super.key});

  @override
  State<LocalRouter> createState() => _LocalRouterState();
}

class LocalRouterItem {
  LocalRouterItem({
    required this.loc,
    required this.name,
    required this.obj,
    required this.icon,
  });

  String loc;
  String name;
  Widget obj;
  IconData icon;
}

class _LocalRouterState extends State<LocalRouter> {
  int index = 0;

  List<LocalRouterItem> localRouter = [
    LocalRouterItem(
        loc: '/',
        name: 'Home',
        obj: const HomePage(),
        icon: Icons.home_rounded),
    LocalRouterItem(
        loc: '/bbw', name: 'BBW', obj: const BBWPage(), icon: Icons.computer),
    LocalRouterItem(
        loc: '/login', name: 'Login', obj: const Login(), icon: Icons.login),
    LocalRouterItem(
        loc: '/licence',
        name: 'Licence',
        obj: const Licence(),
        icon: Icons.copyright_rounded),
  ];
  bool kisweb = false;
  bool isLoading = false;
  bool globalLoading = false;
  DataSeed data = DataSeed();

  void setDesktopWindowSize() {
    DesktopWindow.setWindowSize(const Size(500, 1000));
    DesktopWindow.setMinWindowSize(const Size(400, 400));
  }

  @override
  void initState() {
    super.initState();

    try {
      if (Platform.isWindows) {
        setDesktopWindowSize();
      }
    } catch (e) {
      kisweb = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A080F),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
            backgroundColor: Colors.black,
            title: Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
      ),
      body: Stack(
          alignment: Alignment.topLeft,
          clipBehavior: Clip.hardEdge,
          children: [
            ...localRouter.map((e) {
              bool selEl = (e.loc == localRouter.elementAt(index).loc);
              return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: selEl ? 0 : MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    opacity: selEl ? 1 : 0,
                    child: e.obj,
                  ));
            }).toList(),
            const Positioned(
              top: 0,
              left: 0,
              child: VersionChecker(),
            ),
          ]),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black54,
        ),
        child: BottomNavigationBar(
            backgroundColor: Colors.grey,
            currentIndex: index,
            // unselectedItemColor: Colors.white,
            // selectedItemColor: Colors.white,
            onTap: (newIndex) {
              setState(() {
                index = newIndex;
              });
            },
            items: localRouter
                .map((item) => BottomNavigationBarItem(
                    icon: Icon(
                      item.icon,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    label: item.name))
                .toList()),
      ),
    );
  }
}
