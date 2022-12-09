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

  @override
  void initState() {
    super.initState();
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
    return Container(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            text.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
