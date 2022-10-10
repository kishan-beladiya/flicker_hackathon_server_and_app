import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_it/utils/constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SharedPreferences _prefs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Dio dio = Dio();

  _getAuthToken() async {
    try{
      _showProgressBar(context, 'Please Wait');
      var params =  {
        "username": "${usernameController.text}",
        "password": "${passwordController.text}"
      };

      Response response = await dio.post(
        ConstantVariables.login,
        data: jsonEncode(params),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );


      await _prefs.setString(Constants.authToken, response.data['token']);
      await _prefs.setString(Constants.username, response.data['username']);
      await _prefs.setString(Constants.phone, response.data['phone'].toString());
      await _prefs.setString(Constants.email, response.data['email']);
      await _prefs.setString(Constants.fullName, response.data['full_name']);
      await _prefs.setBool(Constants.isAdmin, response.data['admin']);
      await _prefs.setBool(Constants.isActive, response.data['active']);

      Phoenix.rebirth(context);
    }catch(e){
      Navigator.pop(context);
      print(e);
      Fluttertoast.showToast(msg: 'Error occurred, Please Try again');
    }
  }


  _getData() async {
    _prefs = await SharedPreferences.getInstance();
    setState((){});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'TrackIt - Flipr Hackathon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 24),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Log-In',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'UserName',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  'Forgot Password',
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      if (usernameController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        _getAuthToken();
                      } else {
                        Fluttertoast.showToast(
                            msg: 'InValid username or password');
                      }
                    },
                  )),
              Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Create One',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {},
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


  _showProgressBar(BuildContext context, String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SpinKitDoubleBounce(
                  duration: Duration(seconds: 2),
                  color: Colors.blueAccent,
                  size: 48,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: Text(
                    '$title',
                    style: TextStyle(
                        fontSize: 18, color: Colors.blueAccent),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
