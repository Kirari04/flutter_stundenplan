import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data_seed.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Licence extends StatefulWidget {
  const Licence({super.key});
  @override
  State<Licence> createState() => _LicenceState();
}

class _LicenceState extends State<Licence> {
  _LicenceState();
  String? title;
  String? text;

  DataSeed data = DataSeed();

  Future<http.Response> fetchLicenceApi() {
    return http.get(Uri.parse(data.licenceApi));
  }

  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      //by default show cached
      setState(() {
        text = prefs.getString('licence');
      });
    });

    //update licence
    fetchLicenceApi().then((http.Response res) {
      if (res.statusCode == 200) {
        setState(() {
          text = res.body;
        });
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('licence', text.toString());
        });
      }
    });
  }

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
                      text.toString().split("\n")[0].toUpperCase().trim(),
                      style: const TextStyle(color: Colors.white),
                    )),
              ],
            )),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(
                child: Text(
              text.toString().trim(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            )),
          ),
        ),
      ),
    );
  }
}
