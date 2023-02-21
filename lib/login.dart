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
  bool isAuth = false;
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

        if (username != "" &&
            password != "" &&
            username != null &&
            password != null) {
          isAuth = true;
        }
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              (!isAuth)
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Login to you intranet.tam.ch Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextFormField(
                          initialValue: username,
                          onChanged: (value) {
                            username = value.toString();
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                            )),
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Enter your username',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TextField(
                            onChanged: (value) {
                              password = value.toString();
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.grey,
                                )),
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: 'Enter your Password',
                                focusColor: Colors.white),
                          ),
                        ),
                        errorMessage != null
                            ? Text(
                                errorMessage.toString(),
                                style: const TextStyle(color: Colors.red),
                              )
                            : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: Column(
                            children: const [
                              Text(
                                textAlign: TextAlign.center,
                                "This application is not associated with intranet.tam.ch!",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Your login details will be sent to kbw.senpai.one so that this website can log in to your account and load the timetable data. Your login data is not stored on the server. Your timetable data is temporarily cached on the server. Your login data is stored locally on this device until you log out.",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      errorMessage = null;
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
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          prefs.setString(
                                              'username', username.toString());
                                          prefs.setString(
                                              'password', password.toString());
                                          setState(() {
                                            isAuth = true;
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          errorMessage = "Error: ${res.body}";
                                          isAuth = false;
                                        });
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "Anmelden",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        )
                      ],
                    )
                  : Center(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.red),
                        ),
                        onPressed: () {
                          setState(() {
                            username = null;
                            password = null;
                            isAuth = false;
                          });
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setString('username', "");
                            prefs.setString('password', "");
                          });
                        },
                        child: const Text(
                          "Abmelden",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
