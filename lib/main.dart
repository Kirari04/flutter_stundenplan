import 'package:flutter/material.dart';
import 'package:flutter_application_1/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '2I Stundenplan',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
              subtitle1: TextStyle(color: Colors.white),
            ),
            scrollbarTheme: ScrollbarThemeData().copyWith(
              thumbColor: MaterialStateProperty.all(Colors.white),
            )),
        home: const LocalRouter());
  }
}
