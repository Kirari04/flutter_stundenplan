import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data_seed.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  _LoginState();
  bool isLoading = false;
  String? title;
  String? username = "";
  String? password = "";
  String? errorMessage;

  DataSeed data = DataSeed();

  Future<http.Response> fetchLoginApi() {
    return http.post(Uri.parse(data.api),
        headers: <String, String>{},
        body: <String, String>{
          'username': username.toString(),
          'password': password.toString()
        });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      //by default show cached
      setState(() {
        username = prefs.getString('username');
        password = prefs.getString('password');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(color: Colors.grey),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("Current Username: ${username.toString()}"),
              TextFormField(
                initialValue: username,
                onChanged: (value) {
                  username = value.toString();
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
              TextFormField(
                initialValue: password,
                onChanged: (value) {
                  password = value.toString();
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your Password',
                ),
              ),
              errorMessage != null
                  ? Text(
                      errorMessage.toString(),
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          fetchLoginApi().then((http.Response res) {
                            setState(() {
                              isLoading = false;
                            });
                            if (res.statusCode == 200) {
                              setState(() {
                                errorMessage = null;
                              });
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.setString(
                                    'username', username.toString());
                                prefs.setString(
                                    'password', password.toString());
                              });
                            } else {
                              setState(() {
                                errorMessage = res.body;
                              });
                            }
                          });
                        },
                        child: const Text(
                          "Speichern",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
