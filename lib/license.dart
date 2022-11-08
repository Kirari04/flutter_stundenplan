import 'package:flutter/material.dart';

class Licence extends StatefulWidget {
  Licence({super.key, required this.title, required this.text});

  String title;
  String text;

  @override
  State<Licence> createState() => _LicenceState(title, text);
}

class _LicenceState extends State<Licence> {
  String title;
  String text;

  _LicenceState(this.title, this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      body: Container(
          alignment: Alignment.topLeft,
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                  child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              )),
            ),
          )),
    );
  }
}
