import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data_seed.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: InkWell(
                  child: const Text(
                    "Source: https://github.com/Kirari04/flutter_stundenplan",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    launchUrl(
                        Uri.parse(
                            'https://github.com/Kirari04/flutter_stundenplan'),
                        mode: LaunchMode.externalApplication);
                  },
                ),
              ),
              MarkdownBody(
                  data: text.toString(),
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    a: const TextStyle(color: Colors.blue),
                    p: const TextStyle(color: Colors.white),
                    h1Align: WrapAlignment.center,
                    h1: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.normal,
                    ),
                    h2Align: WrapAlignment.center,
                    h2: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.bold,
                    ),
                    h3Align: WrapAlignment.center,
                    h3: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.bold,
                    ),
                    h4Align: WrapAlignment.center,
                    h4: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
