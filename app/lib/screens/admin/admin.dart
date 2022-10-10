import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  bool isFetched=false;
  String authToken = "";
  bool isActive = false;
  bool isAdmin = false;
  String username = "";
  late SharedPreferences _prefs;

  _getData() async {
    _prefs = await SharedPreferences.getInstance();
    username = _prefs.getString(Constants.username) ?? "";
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

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('$username'),
          actions: [
            IconButton(onPressed: () async {await _prefs.clear();Phoenix.rebirth(context);}, icon: Icon(Icons.add)),
          ],
        ),
        body: Text('Admin'),
      ),
    );
  }
}
