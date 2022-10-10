import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_it/screens/admin/admin.dart';
import 'package:track_it/screens/blocked_user.dart';
import 'package:track_it/screens/employee/employee.dart';
import 'package:track_it/screens/login.dart';
import 'package:track_it/utils/constants.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckLogin(),
    );
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {

  bool isFetched=false;
  String authToken = "";
  bool isActive = false;
  bool isAdmin = false;
  late SharedPreferences _prefs;

  _getData() async {
    _prefs = await SharedPreferences.getInstance();
     authToken = _prefs.getString(Constants.authToken) ?? "";
     isActive = _prefs.getBool(Constants.isActive) ?? true;
     isAdmin = _prefs.getBool(Constants.isAdmin) ?? false;

    isFetched=true;
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

    if(isFetched==false){
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Please Wait...'),
              SizedBox(height: 8),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    if(authToken.isEmpty){
      return Login();
    }else if(isActive==false) {
      return BlockedUser();
    } else if(isAdmin==false){
      return Employee();
    }else{
      return Admin();
    }
  }
}
