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

  static const String VERSION = '1.08';
  bool showNewVersion = false;
  String msg = '';

  Future<http.Response> fetchVersion() {
    return http.get(Uri.parse(
        "https://raw.githubusercontent.com/Kirari04/flutter_stundenplan/master/VERSION.txt"));
  }

  Future<void> checkVersion() async {
    http.Response res = await fetchVersion();
    if (res.statusCode == 200) {
      if (res.body != VERSION) {
        setState(() {
          msg = " - Your: $VERSION vs Newest: ${res.body}";
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
              child: Text(
                "New Version Available! $msg",
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              onTap: () {
                launchUrl(
                    Uri.parse(
                        'https://github.com/Kirari04/flutter_stundenplan/releases'),
                    mode: LaunchMode.externalApplication);
              },
            ),
          )
        : const SizedBox.shrink();
  }
}
