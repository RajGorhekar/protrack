import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:protrack/auth.dart';
import 'package:protrack/screens/home.dart';
import 'package:protrack/screens/swipe.dart';
import 'package:protrack/utils/colors.dart';
import 'package:protrack/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.bgGray, // navigation bar color
        // statusBarColor: AppColors.bgGray, // status bar color
        statusBarColor: Colors.transparent // status bar color
        ));
    return MaterialApp(
      title: 'protrack 2021',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var bgImageUrl = 'assets/images/splash2.gif';
  var logoImageUrl = 'assets/images/protrack Front.png';
  var googleImageUrl = 'assets/images/GoogleLogo.png';
  int animationDuration = 1500;
  bool _visible = false;
  bool loading = false;
  bool logged = false;
  TextEditingController branch;
  TextEditingController number;
  TextEditingController collegeName;
  bool registered = false;
  FirebaseAuth auth;
  String loggedUser;

  navigatorPage() {
    setState(() {
      _visible = true;
    });
  }

  startTimer() {
    var duration = Duration(milliseconds: 1500);
    return Timer(duration, navigatorPage);
  }

  getAuthDetails() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      setState(() {
        if (sharedPreferences.getBool("loggedIn") == null ||
            !sharedPreferences.getBool("loggedIn")) {
          sharedPreferences.setBool("loggedIn", false);
          logged = false;
        } else {
          logged = true;
        }

        if (sharedPreferences.getBool("registered") == null ||
            !sharedPreferences.getBool("registered")) {
          sharedPreferences.setBool("registered", false);
          registered = false;
        } else {
          registered = true;
        }
      });
      if (logged) {
        navigateToHome(auth.currentUser, decider: 0);
      }
    } catch (e) {
      print(e);
    }
  }

  navigateToHome(currentUser, {int decider = 0}) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return decider == 0 ? Home(category: "Cultural") : SwipeScreen();
          },
          transitionDuration: Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation =
                CurvedAnimation(curve: Curves.elasticInOut, parent: animation);
            return Align(
                child: SlideTransition(
              position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                  .animate(animation),
              child: child,
            ));
          }),
      (route) => false,
    );
  }

  addUser(currentUser) async {
    setState(() {
      loading = true;
    });
    Map events = {};
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .set({
      "uid": currentUser.uid,
      "name": currentUser.displayName,
      "collegeName": collegeName.text,
      "branch": branch.text,
      "number": number.text,
      "emailID": currentUser.email,
      'Events': events
    }).whenComplete(() async {
      setState(() {
        loading = false;
        registered = true;
      });

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool("registered", true);

      navigateToHome(currentUser, decider: 1);
    });
  }

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    startTimer();
    getAuthDetails();
    // vbjfs();
    branch = TextEditingController();
    number = TextEditingController();
    collegeName = TextEditingController();
  }

  Future takeDetails(currentUser) {
    navigateToHome(currentUser, decider: 1);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (registered) {
      navigateToHome(0);
    }
    // else {
    //   takeDetails(details[0]);
    // }

    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(bgImageUrl), fit: BoxFit.fitHeight)),
            ),
            !logged
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: animationDuration),
                      child: Container(
                        height: 45,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 40),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: InkWell(
                          onTap: _visible
                              ? () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  await Future.delayed(
                                      Duration(milliseconds: 50));
                                  signInWithGoogle().then(
                                    ([List details]) async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      // if (details[1]) {
                                      //   print("new user");
                                      //   setState(() {
                                      //     loggedUser = details[0].email;
                                      //     logged = true;
                                      //   });
                                      //   takeDetails(details[0]);
                                      // } else {
                                      //   print("not a new user");
                                      //   var query = await FirebaseFirestore
                                      //       .instance
                                      //       .collection("Users")
                                      //       .doc(details[0].email);

                                      //   query.get().then((value) {
                                      //     if (value.exists) {
                                      //       print("Already registered");
                                      //       sharedPreferences.setBool(
                                      //           "registered", true);
                                      //       navigateToHome(details[0],
                                      //           decider: 1);
                                      //     } else {
                                      //       print("not registered");
                                      //       setState(() {
                                      //         registered = false;
                                      //         logged = true;
                                      //       });
                                      //       takeDetails(details[0]);
                                      //     }
                                      //   });
                                      // }
                                      navigateToHome(details[0], decider: 1);
                                    },
                                  ).catchError((e) {
                                    print(e.toString());
                                  });
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              : () {},
                          child: AnimatedContainer(
                              width: !loading ? size.width * 0.85 : 150,
                              duration: Duration(milliseconds: 500),
                              child: !loading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(googleImageUrl, height: 45),
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    'Sign in With Google',
                                                    style: TextStyle(
                                                        color: Colors.blue[600],
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 1.2,
                                                        fontSize: 16))))
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child:
                                                CupertinoActivityIndicator()),
                                        Expanded(
                                            child: Center(
                                                child: Text('Loading ...',
                                                    style: TextStyle(
                                                        color: AppColors.fgGray,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 1.2,
                                                        fontSize: 16))))
                                      ],
                                    )),
                        ),
                      ),
                    ),
                  )
                : !registered
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: InkWell(
                              onTap: () {
                                takeDetails(auth.currentUser);
                              },
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 45,
                                child: Center(
                                  child: Text(
                                    "Fill Details to go ahead",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
          ],
        ));
  }
}
