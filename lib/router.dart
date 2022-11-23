import 'package:flutter/material.dart';
import 'package:flutter_application_1/bbw.dart';
import 'package:flutter_application_1/data_seed.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/license.dart';

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
        loc: '/licence',
        name: 'Licence',
        obj: const Licence(),
        icon: Icons.copyright_rounded),
  ];
  bool isLoading = false;
  bool globalLoading = false;
  DataSeed data = DataSeed();

  void openLicence() async {
    setState(() {
      globalLoading = true;
    });
    Navigator.of(context).push(MaterialPageRoute(
      settings: const RouteSettings(name: '/licence'),
      builder: (_) {
        return const Licence();
      },
    ));
    setState(() {
      globalLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
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
            }).toList()
          ]),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          currentIndex: index,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          onTap: (newIndex) {
            setState(() {
              index = newIndex;
            });
          },
          items: localRouter
              .map((item) => BottomNavigationBarItem(
                  icon: Icon(
                    item.icon,
                    color: Colors.white,
                  ),
                  label: item.name))
              .toList()),
    );
  }
}
