import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_it/screens/employee/employee_today.dart';
import 'package:track_it/screens/employee/employee_week.dart';
import 'package:track_it/screens/employee/employee_yesterday.dart';
import 'package:track_it/screens/settings.dart';
import 'package:track_it/utils/constants.dart';

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  bool isFetched = false;
  String authToken = "";
  bool isActive = false;
  bool isAdmin = false;
  String username = "";
  late SharedPreferences _prefs;


  _addTask(){

  }


  _getData() async {
    _prefs = await SharedPreferences.getInstance();
    username = _prefs.getString(Constants.username) ?? "";
    authToken = _prefs.getString(Constants.authToken) ?? "";
    isActive = _prefs.getBool(Constants.isActive) ?? true;
    isAdmin = _prefs.getBool(Constants.isAdmin) ?? false;

    isFetched = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (isFetched == false) {
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

    return DefaultTabController(
      length: 4,
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text('$username'),
            actions: [
              // IconButton(
              //     onPressed: () async {
              //       await _prefs.clear();
              //       Phoenix.rebirth(context);
              //     },
              //     icon: Icon(Icons.add)),
            ],
            bottom: TabBar(
              isScrollable: false,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  // icon: Icon(Icons.today),
                  text: 'Today',
                ),
                Tab(
                  // icon: Icon(Icons.yesterd),
                  text: 'Yesterday',
                ),
                Tab(
                  // icon: Icon(Icons.download),
                  text: 'Week',
                ),
                Tab(
                  // icon: Icon(Icons.add_circle),
                  text: 'Settings',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              EmployeeToday(),
              EmployeeYesterday(),
              EmployeeWeek(),
              Settings(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(
                            obscureText: true,
                            controller: null,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Task Description',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(
                            obscureText: true,
                            controller: null,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Duration',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(
                            obscureText: true,
                            controller: null,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Date',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.add_circle_outline_rounded),
          ),
        ),
      ),
    );
  }
}
