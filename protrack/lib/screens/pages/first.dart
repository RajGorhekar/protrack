import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:protrack/utils/colors.dart';
import 'package:protrack/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:app_usage/app_usage.dart';
import 'package:charts_flutter/flutter.dart' as charts;

int status = 0;

class First extends StatefulWidget {
  First({Key key}) : super(key: key);

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  String str1 = "We are verifying your location with our whitelisted GeoFence";
  String str2 = "We are matching your BSSID with our whitelisted Mac Address";
  String str3 = "Updating Attendance";

  String btn_str = "Mark My Attendance";
  List<AppUsageInfo> _infos = [];
  Map<String, double> pie_info = {};
  bool loading = true;
  List<charts.Series<Task, String>> _seriesPieData;

  Widget circle(color) {
    return Container(
      margin: EdgeInsets.all(3),
      height: 4,
      width: 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  ele(col, {int id = 1}) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Column(children: [
              circle(col),
              circle(col),
              circle(col),
              Icon(Icons.verified, color: col, size: 20),
              circle(col),
              circle(col),
              circle(col),
            ]),
            SizedBox(width: 20),
            Icon(
              id == 1
                  ? Icons.location_on_outlined
                  : id == 3
                      ? Icons.verified_outlined
                      : Icons.wifi,
              size: MediaQuery.of(context).size.width * 0.12,
              color: Colors.white,
            ),
            // Icon(Icons.verified, color: Colors.black38, size: 50),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id == 1
                      ? 'Location'
                      : id == 3
                          ? "Attendance"
                          : "Wifi",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      letterSpacing: 1.2,
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  child: Text(
                    id == 1
                        ? str1
                        : id == 3
                            ? str3
                            : str2,
                    style: TextStyle(
                      letterSpacing: 1.2,
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  timeline(status) {
    return Container(
      child: status == 0
          ? Column(children: [
              ele(Colors.green[400].withOpacity(0.2), id: 1),
              ele(Colors.green[400].withOpacity(0.2), id: 2),
              ele(Colors.green[400].withOpacity(0.2), id: 3),
            ])
          : status == 1
              ? Column(children: [
                  ele(Colors.green[400], id: 1),
                  ele(Colors.green[400].withOpacity(0.2), id: 2),
                  ele(Colors.green[400].withOpacity(0.2), id: 3),
                ])
              : status == 2
                  ? Column(children: [
                      ele(Colors.green[400], id: 1),
                      ele(Colors.green[400], id: 2),
                      ele(Colors.green[400].withOpacity(0.2), id: 3),
                    ])
                  : Column(children: [
                      ele(Colors.green[400], id: 1),
                      ele(Colors.green[400], id: 2),
                      ele(Colors.green[400], id: 3),
                    ]),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    getUsageStats();
  }

  void getUsageStats() async {
    try {
      DateTime startDate = DateTime(2021, 02, 13, 09, 00);
      // DateTime d = new DateTime.now();
      // DateTime startDate = DateTime(d.year, d.month, d.day, 09, 00);
      DateTime endDate = new DateTime.now();
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos = infos;
      });

      Map<String, double> pie = {};
      Duration finalDur = Duration(seconds: 0);

      _infos.forEach((element) {
        if (Duration(seconds: 60 * 7) < element.usage) {
          finalDur += element.usage;
        }
      });

      _infos.forEach((element) {
        if (Duration(seconds: 60 * 7) < element.usage) {
          pie[element.appName] = double.parse(
              ((element.usage.inSeconds / finalDur.inSeconds) * 100)
                  .toStringAsFixed(2));
        }
      });

      log(pie.toString());

      setState(() {
        pie_info = pie;
      });

      List clrs = [
        Colors.deepPurple,
        Colors.deepPurpleAccent,
        Color(0xff3366cc),
        Colors.cyan,
        Color(0xff109618),
        Color(0xfffdbe19),
        Color(0xffff9900),
        Color(0xffdc3912),
        Colors.deepPurple,
        Colors.deepPurpleAccent,
        Color(0xff3366cc),
        Colors.cyan,
        Color(0xff109618),
        Color(0xfffdbe19),
        Color(0xffff9900),
        Color(0xffdc3912),
      ];

      List<Task> piedata = [];
      int ctr = 0;
      pie_info.forEach((key, value) {
        piedata.add(new Task("${key} : $value %", value, clrs[ctr]));
        ctr += 1;
      });

      _seriesPieData.add(
        charts.Series(
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskvalue,
          colorFn: (Task task, _) =>
              charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Air Pollution',
          data: piedata,
          labelAccessorFn: (Task row, _) => '${row.taskvalue}',
        ),
      );
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      setState(() {
        loading = false;
        status = sharedPreferences
                    .getString(date.toString().substring(0, 11).trim()) ==
                "Present"
            ? 3
            : 0;
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    showerror(err_str) {
      setState(() {
        status = 0;
        btn_str = "Mark My Attendance";
      });
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)), //this right here
              child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    children: [
                      SizedBox(height: 20),
                      Text('An Error Occured !\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(err_str,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(
                        width: 320.0,
                        child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "O K",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.cyan),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return loading
        ? Center(
            child: Text(
              'Loading . . .',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Header(
                    Icon(Icons.edit_attributes_outlined,
                        color: Colors.cyan, size: 35),
                    "TRACK YOUR ATTENDANCE",
                    "Updating Attendance"),
              ),
              SizedBox(height: 5),
              timeline(status % 4),
              SizedBox(height: 5),
              status == 3
                  ? Opacity(
                      opacity: 0.5,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(top: 8, bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff00538a),
                                    Color(0xff3bceff)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(3, 5),
                                    blurRadius: 6.0,
                                    spreadRadius: -2),
                              ],
                            ),
                            child: Text(
                              "Attendance Marked",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )),
                      ),
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            btn_str = "Marking . . .";
                          });
                          var doc = await Firestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser.email)
                              .get();
                          var cord = doc.data()['location'];
                          var curr_pos = await _determinePosition();
                          double distanceInMeters = Geolocator.distanceBetween(
                              cord.latitude,
                              cord.longitude,
                              curr_pos.latitude,
                              curr_pos.longitude);

                          // log(cord.latitude.toString());
                          // log(cord.longitude.toString());
                          // log(curr_pos.latitude.toString());
                          // log(curr_pos.longitude.toString());
                          log(distanceInMeters.toString());
                          if (distanceInMeters <= 600) {
                            setState(() {
                              status = 1;
                              str1 = "Location Verified";
                            });
                            String bssid = doc.data()['bssid'];
                            var wifiBSSID = await WifiInfo().getWifiBSSID();
                            String curr_bssid = wifiBSSID.toString();
                            if (bssid == curr_bssid) {
                              setState(() {
                                status = 2;
                                str2 = "WIFI Verified";
                              });
                              DateTime now = new DateTime.now();
                              DateTime date =
                                  new DateTime(now.year, now.month, now.day);
                              await Firestore.instance
                                  .collection(
                                      FirebaseAuth.instance.currentUser.email)
                                  .doc('attendance')
                                  .update({
                                date.toString().substring(0, 11).trim():
                                    "Present"
                              });
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString(
                                  date.toString().substring(0, 11).trim(),
                                  "Present");
                              setState(() {
                                status = 3;
                                str3 = "Atendance Updated";
                                btn_str = "Attendance Marked";
                              });
                            } else {
                              showerror(
                                  "You are not connected to correct network address\n");
                            }
                          } else {
                            showerror(
                                "You are not in our whitelisted GeoFence\n");
                          }
                        },
                        child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(top: 8, bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff00538a),
                                    Color(0xff3bceff)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(3, 5),
                                    blurRadius: 6.0,
                                    spreadRadius: -2),
                              ],
                            ),
                            child: Text(
                              btn_str,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )),
                      ),
                    ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: 1.5,
                color: Colors.white.withOpacity(0.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Header(
                    Icon(Icons.work_outline_sharp,
                        color: Colors.cyan, size: 35),
                    "Data from Your Phone",
                    "daily uasage stats"),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            '\nTime spent on daily tasks\n',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 400,
                            child: charts.PieChart(
                              _seriesPieData,
                              animate: true,
                              animationDuration: Duration(milliseconds: 1300),
                              behaviors: [
                                new charts.DatumLegend(
                                  outsideJustification:
                                      charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxRows: (pie_info.length / 2).toInt(),
                                  cellPadding: new EdgeInsets.only(
                                      right: 4.0, bottom: 10.0, left: 4),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color: charts.MaterialPalette.white,
                                      fontFamily: 'Georgia',
                                      fontSize: 11),
                                )
                              ],
                              defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.inside)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
