import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class VersionChecker extends StatefulWidget {
  const VersionChecker({super.key});
  @override
  State<VersionChecker> createState() => _VersionCheckerState();
}

class _VersionCheckerState extends State<VersionChecker> {
  _VersionCheckerState();

  static const String VERSION = '1.06';
  bool showNewVersion = false;

  Future<http.Response> fetchVersion() {
    return http.get(Uri.parse(
        "https://raw.githubusercontent.com/Kirari04/flutter_stundenplan/master/VERSION.txt"));
  }

  Future<void> checkVersion() async {
    http.Response res = await fetchVersion();
    if (res.statusCode == 200) {
      if (res.body != VERSION) {
        setState(() {
          showNewVersion = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return showNewVersion
        ? Container(
            padding: const EdgeInsets.all(10),
            child: InkWell(
                child: const Text(
                  "New Version Available!",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://docs.flutter.io/flutter/services/UrlLauncher-class.html'));
                }),
          )
        : const SizedBox.shrink();
  }
}
