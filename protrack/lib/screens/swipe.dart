import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:protrack/utils/functions.dart';
import 'dart:math';
import 'home.dart';

class SwipeScreen extends StatefulWidget {
  static final style = TextStyle(
      fontSize: 30,
      fontFamily: "Billy",
      fontWeight: FontWeight.w600,
      color: Colors.white);

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  int page = 0;
  LiquidController liquidController;
  UpdateType updateType;
  double height, width;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  navigate(cat) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return Home(category: cat);
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
            ),
          );
        },
      ),
      (route) => false,
    );
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe(
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            ignoreUserGestureWhileAnimating: true,
            enableLoop: true,
            fullTransitionValue: 500,
            enableSlideIcon: true,
            positionSlideIcon: 0.5,
            pages: <Widget>[
              cultural(),
              technical(),
              pronite(),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(3, _buildDot),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    print(lpage);
    setState(() {
      page = lpage;
    });
  }

  Widget cultural() {
    return InkWell(
      onTap: () {
        print("Cultural");
        navigate("Cultural");
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xffED00CC),
              Color(0xff3F2669),
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: width,
              child: Image.asset(
                'assets/images/Event Images_1-01.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Our product will help you track the attendance keeping in mind the geo fence as well as Wifi address.",
                style: SwipeScreen.style,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget technical() {
    return InkWell(
      onTap: () {
        print("Technical");
        navigate("Technical");
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff3F2669),
            Color(0xff3700AF),
          ],
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              width: width,
              child: Image.asset(
                'assets/images/808.gif',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Our Dashboard will showcase the employee how productive he/she  is and will be able to track his/her activities.",
                style: SwipeScreen.style,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pronite() {
    return InkWell(
      onTap: () {
        print("Pronites");
        navigate("Pronites");
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff00CDEF), Color(0xffED00CC)],
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: width,
              child: Image.asset(
                'assets/images/Event Images_1-04.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "The system will make it easy for the employees by sorting out the whitelisted and blacklisted websites.",
                style: SwipeScreen.style,
              ),
            )
          ],
        ),
      ),
    );
  }

}
