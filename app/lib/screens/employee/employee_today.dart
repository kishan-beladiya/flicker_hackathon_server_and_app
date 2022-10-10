import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_it/utils/constants.dart';

class EmployeeToday extends StatefulWidget {
  const EmployeeToday({Key? key}) : super(key: key);

  @override
  State<EmployeeToday> createState() => _EmployeeTodayState();
}

class _EmployeeTodayState extends State<EmployeeToday> {

  double workPercent=0;
  double meetingPercent=0;
  double breakPercent=0;
  int touchedIndex = -1;
  bool isFetched=false;
  String authToken = "";
  bool isActive = false;
  bool isAdmin = false;
  String username = "";
  late SharedPreferences _prefs;
  Dio dio = Dio();
  Map<String,dynamic> todayData = {};

  _fetchData() async {
    _showProgressBar(context, 'Please Wait');

    Response response = await dio.get(
      ConstantVariables.todayTask+"/$username",
      options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          }
      ),
    );

    print(response.data);
    todayData = response.data;
    workPercent = ((todayData['work'].length/(todayData['work'].length + todayData['meeting'].length + todayData['break'].length))*100);
    meetingPercent = ((todayData['meeting'].length/(todayData['work'].length + todayData['meeting'].length + todayData['break'].length))*100);
    breakPercent = ((todayData['break'].length/(todayData['work'].length + todayData['meeting'].length + todayData['break'].length))*100);

    setState((){});
    Navigator.pop(context);
  }

  _getData() async {
    _prefs = await SharedPreferences.getInstance();
    username = _prefs.getString(Constants.username) ?? "";
    authToken = _prefs.getString(Constants.authToken) ?? "";
    isActive = _prefs.getBool(Constants.isActive) ?? true;
    isAdmin = _prefs.getBool(Constants.isAdmin) ?? false;

    await Future.delayed(Duration(milliseconds: 300));
    _fetchData();
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: PieChart(
            PieChartData(
                pieTouchData: PieTouchData(touchCallback:
                    (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse
                        .touchedSection!.touchedSectionIndex;
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 30,
                sections: showingSections()),
          ),
        ),
        Divider(height: 8),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pieData('Work','${workPercent.toStringAsFixed(2)}%'),
              pieData('Meeting','${meetingPercent.toStringAsFixed(2)}%'),
              pieData('Break','${breakPercent.toStringAsFixed(2)}%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget pieData(String type, String percentage){
    return ListTile(
      leading: Icon(Icons.data_usage, color: Colors.blueAccent),
      title: Text('$type'),
      trailing: Text('$percentage'),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: workPercent,
            title: 'W\n${workPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: meetingPercent,
            title: 'M\n${meetingPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: breakPercent,
            title: 'B\n${breakPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
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


class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
