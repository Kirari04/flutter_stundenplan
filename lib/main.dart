import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/license.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  List<Map<String, dynamic>> router = [
    {'loc': '/', 'name': 'Home', 'obj': const HomePage()},
    {'loc': '/licence', 'name': 'Copyright', 'obj': const Licence()}
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '2I Stundenplan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: router[index]['obj']);
  }
}
