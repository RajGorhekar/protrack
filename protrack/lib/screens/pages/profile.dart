import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:protrack/auth.dart';
import 'package:protrack/utils/colors.dart';
import 'package:protrack/utils/functions.dart';
import 'package:protrack/widgets/Infotext.dart';
import 'package:protrack/widgets/ticket.dart';
import 'package:protrack/widgets/wave.dart';
import 'package:protrack/widgets/userCircle.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:developer' as logger;

List my_events = [];

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  ScrollController _listController = ScrollController();
  AnimationController _controller;
  AnimationController _btncontroller;
  var user = FirebaseAuth.instance.currentUser;
  String clgname = "loading . . .";
  String number = "loading . . .";
  String bssid = "loading . . .";
  String location = "loading . . .";

  ByteData fontData;
  ByteData imageData1;

  Map links = {};
  bool loading = true;

  getdetails() async {
    // await signOutGoogle(context);
    setState(() {
      loading = true;
    });
    var ss = await Firestore.instance.collection('Users').doc(user.email).get();
    // Firestore.instance.collection('Users').doc('testemail').set(ss.data());

    print(ss.data());
    setState(() {
      clgname = ss.data()['collegeName'];
      number = ss.data()['number'];
      bssid = ss.data()['bssid'].toString();
      // location = "(${ss.data()['location'].latitude.toString()} , ${ss.data()['location'].longitiude.toString()})";
      location = ss.data()['location'].latitude.toString() +
          "," +
          ss.data()['location'].longitude.toString();
      loading = false;
    });
    logger.log(links.toString());
  }

  kvef() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("loggedIn", false);
    sharedPreferences.setBool("registered", false);
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    // kvef();
    getdetails();
    super.initState();
    _btncontroller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
      lowerBound: 0,
      upperBound: 0.5,
    )..addListener(() {
        setState(() {});
      });
    _controller = AnimationController(vsync: this);
    rootBundle
        .load('assets/fonts/Montserrat-SemiBold.ttf')
        .then((data) => setState(() => this.fontData = data));
    rootBundle
        .load('assets/images/protrack Invoice.jpg')
        .then((data) => setState(() => this.imageData1 = data));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    info(icon, subtitle) {
      return subtitle != ""
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(icon, size: 20, color: AppColors.iconColorInProfile),
                      SizedBox(width: 12),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(
                          subtitle,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Container();
    }

    button(data, children) {
      return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.fgGray,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 25,
                offset: Offset(7, 7), // changes position of shadow
              ),
            ]),
        child: Theme(
          data: Theme.of(context).copyWith(
              accentColor: AppColors.iconColorInProfile,
              unselectedWidgetColor: AppColors.iconColorInProfile),
          child: ExpansionTile(
            title: Text(data,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
            children: children,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: loading
          ? Container(
              child: Center(
              child: Text(
                'Loading . . . ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ))
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: size.height * 0.3,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                AppColors.gradientColorEnd,
                                AppColors.gradientColorStart
                              ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight)),
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 1500),
                          curve: Curves.easeOutQuad,
                          top: keyboardOpen ? -size.height / 3.7 : 0.0,
                          child: WaveWidget(
                              size: size,
                              yOffset: size.height / 4.5,
                              color: AppColors.bgGray),
                        ),
                        Container(
                          width: size.width,
                          margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.fgGray,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 25,
                                offset:
                                    Offset(7, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 0.2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                spreadRadius: 0,
                                                blurRadius: 25,
                                                offset: Offset(15,
                                                    15), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: UserCircle(
                                            url2: user.photoURL,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          Utils.capitalize(user.displayName),
                                          style: TextStyle(
                                              fontSize: 22,
                                              letterSpacing: 1.1,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          signOutGoogle(context);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: AppColors.onlineDotColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.2),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black54,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 2),
                                                  blurRadius:
                                                      6.0, // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.logout,
                                                  size: 12,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  ' logout',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  )),
                              Divider(color: Colors.white54),
                              info(Icons.mail_outline, user.email),
                              info(Icons.wifi_lock, bssid),
                              info(Icons.location_on, location),
                              number == "loading . . ."
                                  ? info(Icons.call, number)
                                  : info(Icons.call, number),
                              info(Icons.location_city, clgname),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      height: 0.5,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      color: Colors.white12),
                  SizedBox(height: 20),
                  Text("About Neebal :",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.iconColorInProfile,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('''
Right Technology.
For you.

Neebal was founded with the aim to help clients choose the ‘right technology’ always. Even if it needs to be built from scratch.

Today’s highly connected world is a melee of the best and latest technology. What’s the most suitable for your organisation from the many options available? We find the answer to this question by embracing the concepts of design thinking. We build future-ready solutions centered around the end user and their environmental conditions.

The exactness of our solutions is driven by our problem-solving attitude fostered by the commitment to devise the most apropos product. We focus on the problem open-mindedly and then deploy technological ammunition to deliver the devised solution. We understand the need to move fast in today’s scenario and our agile methods ensure that our clients are poised to respond to market conditions in shortest possible time.
''',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.iconColorInProfile,
                        )),
                  ),
                  Container(
                      height: 0.5,
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      color: Colors.white12),
                  SizedBox(height: 10),
                  button(
                    "About Us",
                    <Widget>[
                      Column(
                        children: [
                          Container(
                            height: 2,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              gradient: AppColors.fabGradient,
                            ),
                          ),
                          Container(
                              color: AppColors.fgGray,
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  "Work from Home Assistant and Productivity Tracker\n"
                                                      .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: "",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15)),
                                        ])),
                                  ])),
                          Container(
                            height: 2,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              gradient: AppColors.fabGradient,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.bug_report,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Report a bug",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                      letterSpacing: 0.5,
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  im(url, link) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(link)) {
          await launch(link);
        } else {
          print('Could not launch $link');
        }
      },
      child: Container(
          height: MediaQuery.of(context).size.width / 7,
          width: MediaQuery.of(context).size.width / 7,
          child: Image.asset(url)),
    );
  }
}
