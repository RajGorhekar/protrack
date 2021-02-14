import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protrack/utils/colors.dart';
import 'dart:developer';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<charts.Series<Task, String>> _seriesPieData;
  Map<String, double> pie_info = {};
  bool loading = true;

  List whiteList = [
    'Visual Studio Code',
    'Eclipse',
    'Adobe XD',
    'WPS Office',
    'Word',
    'Powerpoint',
    'Adobe Acrobat Reader DC (32-bit)',
    'Windows PowerShell',
    'Android Studio',
    'Code::Blocks 17.12',
    'Sublime Text (UNREGISTERED)',
    'Postman',
    'Excel',
    'Zoom Cloud Meetings',
    'airmeet.com',
    'meet.google.com',
    'mail.google.com',
    'console.firebase.google.com',
    'firebase.google.com',
  ];

  List blackList = [
    'μTorrent 3.5.5',
    'mxplayer.in',
    'hatchful.shopify.com',
    'primevideo.com',
    'instagram.com',
    'facebook.com',
    'netflix.com',
    'flipkart.com',
    'myntra.com',
    'ajio.com',
    'olacabs.com',
    'uber.com',
    'facebook.com',
    'amazon.in',
  ];

  int white_secs = 0;
  int black_secs = 0;

  _generateData() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    log(date.toString().substring(0, 11));
    var doc = await Firestore.instance
        .collection(FirebaseAuth.instance.currentUser.email)
        .doc('activity')
        .get();

    var data = doc.data()['Date'];
    List todays_data =
        data[date.toString().substring(0, 11).trim()]['activities'];
    log(todays_data.toString());
    Map<String, double> pie = {};

    int total_secs = 0;
    todays_data.forEach((element) {
      int secs = 0;
      element['time_entries'].forEach((ele) {
        // log(ele.toString());
        secs = secs +
            60 * 60 * ele['hours'] +
            60 * ele['minutes'] +
            ele['seconds'];
      });
      total_secs += secs;
    });

    todays_data.forEach((element) {
      int secs = 0;
      element['time_entries'].forEach((ele) {
        secs = secs +
            60 * 60 * ele['hours'] +
            60 * ele['minutes'] +
            ele['seconds'];
      });
      log(secs.toString());
      pie[element['name'] == "" ? 'Others' : element['name']] = double.parse(
          ((secs / total_secs.truncateToDouble()) * 100).toStringAsFixed(2));
    });
    log(pie.toString());

    int ws = 0, bs = 0;
    todays_data.forEach((element) {
      int secs = 0;
      element['time_entries'].forEach((ele) {
        secs = secs +
            60 * 60 * ele['hours'] +
            60 * ele['minutes'] +
            ele['seconds'];
      });
      if (whiteList.contains(element['name'])) {
        ws += secs;
      } else {
        bs += secs;
      }
    });
    setState(() {
      pie_info = pie;
      white_secs = ws;
      black_secs = bs;
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
      piedata.add(new Task(key, value, clrs[ctr]));
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

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<LinearSales, int>> _createSampleDataLine() {
      // final data = [
      //   new LinearSales(0, 5),
      //   new LinearSales(1, 25),
      //   new LinearSales(2, 100),
      //   new LinearSales(3, 75),
      // ];

      int cn = 0;
      final data = pie_info.keys
          .map(
            (e) => new LinearSales(cn += 1, pie_info[e].round()),
          )
          .toList();

      return [
        new charts.Series<LinearSales, int>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
        )
      ];
    }

    List<charts.Series<OrdinalSales, String>> _createSampleDataBar() {
      final data = [
        new OrdinalSales('', 0),
        new OrdinalSales('Whitelist', white_secs),
        new OrdinalSales('BlackList', black_secs),
        new OrdinalSales(' ', 0),
      ];

      return [
        new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
        )
      ];
    }

    int cn = 0;
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      appBar: AppBar(
        backgroundColor: AppColors.bgGray,
        elevation: 10,
        centerTitle: false,
        title: Text(
          'Track your Productivity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: loading
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
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You were\nProductive',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        // "${(white_secs / (white_secs + black_secs)) * 100} %",
                        "${double.parse(((white_secs / (white_secs + black_secs)) * 100).toStringAsFixed(2))} %",
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: []),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                color: AppColors.bgGray,
                                height: 250,
                                child: charts.BarChart(
                                  _createSampleDataBar(),
                                  animate: true,
                                  animationDuration: Duration(seconds: 2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 2,
                    color: Colors.white.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  ),
                  Container(
                    height: 480,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(
                                '\nTime spent on daily tasks',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                '\nFrom your Desktop\n\n',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.2),
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Expanded(
                                child: charts.PieChart(_seriesPieData,
                                    animate: true,
                                    animationDuration:
                                        Duration(milliseconds: 3500),
                                    behaviors: [
                                      new charts.DatumLegend(
                                        outsideJustification: charts
                                            .OutsideJustification.endDrawArea,
                                        horizontalFirst: false,
                                        desiredMaxRows:
                                            (pie_info.length / 2).toInt(),
                                        cellPadding: new EdgeInsets.only(
                                            right: 4.0, bottom: 10.0, left: 4),
                                        entryTextStyle: charts.TextStyleSpec(
                                            color: charts.MaterialPalette.white,
                                            fontFamily: 'Georgia',
                                            fontSize: 11),
                                      )
                                    ],
                                    defaultRenderer:
                                        new charts.ArcRendererConfig(
                                            arcWidth: 100,
                                            arcRendererDecorators: [
                                          new charts.ArcLabelDecorator(
                                              labelPosition: charts
                                                  .ArcLabelPosition.inside)
                                        ])),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 2,
                    color: Colors.white.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: pie_info.keys
                                        .map(
                                          (e) => Text(
                                            '${cn += 1} - ${e == "" ? 'Others' : e}\n',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                        .toList()),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                color: AppColors.bgGray,
                                height: 250,
                                child: charts.LineChart(_createSampleDataLine(),
                                    animate: true,
                                    animationDuration:
                                        Duration(milliseconds: 5000),
                                    defaultRenderer:
                                        new charts.LineRendererConfig(
                                            includePoints: true)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${white_secs},${black_secs}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
