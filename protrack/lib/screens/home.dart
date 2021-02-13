import 'dart:math';
import 'package:flutter/material.dart';
import 'package:protrack/screens/pages/dashboard.dart';
import 'package:protrack/screens/pages/profile.dart';
import 'package:protrack/screens/pages/first.dart';
import 'package:protrack/utils/colors.dart';

class Home extends StatefulWidget {
  String category;
  Home({this.category});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  GlobalKey _icon1Key, _icon2Key, _icon3Key;
  Animation<double> _animIndicator, _animIcon;
  AnimationController _animCont;

  double _lastTabIconPosition = 0.0,
      _newtabIconPosition = 0.0,
      _indicatorSize = 35,
      _textSize = 10.0;

  bool _isReverse = false;

  GlobalKey _animKey;
  double _indicatorYOffset = 0.0;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    _icon1Key = GlobalKey();
    _icon2Key = GlobalKey();
    _icon3Key = GlobalKey();

    _animCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550));
    _animIndicator = Tween(begin: 0.0, end: 0.0).animate(_animCont);
    _animIcon = Tween(begin: 0.0, end: pi / 180 * 360).animate(_animCont);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _lastTabIconPosition = _getTabIconPosition(_icon1Key, isStart: true);
        _animIndicator =
            Tween(begin: _lastTabIconPosition, end: 0.0).animate(_animCont);
      });
    });
  }

  double _getTabIconPosition(GlobalKey key, {bool isStart = false}) {
    var renderObject = key.currentContext.findRenderObject() as RenderBox;

    if (isStart) _indicatorYOffset = -_textSize / 2 - 2;

    return renderObject.localToGlobal(Offset.zero).dx +
        renderObject.size.width / 2 -
        _indicatorSize / 2;
  }

  @override
  void dispose() {
    _animCont.dispose();
    super.dispose();
  }

  Widget _getTabIcon(
      GlobalKey iconKey, IconData icon, String title, int pageIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animIcon,
          builder: (_, __) {
            return Transform.rotate(
              angle: iconKey == _animKey ? _animIcon.value : 0.0,
              child: Transform.scale(
                scale: iconKey == _animKey
                    ? min(sin(_animIcon.value / 2), 0.6) + 1
                    : 1,
                child: IconButton(
                  key: iconKey,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    if (!_animCont.isAnimating) {
                      setState(() {
                        this.pageIndex = pageIndex;
                        if (pageController.hasClients) {
                          pageController.jumpToPage(
                            pageIndex,
                            // duration: Duration(milliseconds: 400),
                            // curve: Curves.easeInOut,
                          );
                        }
                        print(this.pageIndex);
                      });
                      _animKey = iconKey;
                      _newtabIconPosition = _getTabIconPosition(iconKey);
                      _animCont.reset();
                      _isReverse = _newtabIconPosition < _lastTabIconPosition;
                      _animIndicator = Tween(
                              begin: _lastTabIconPosition,
                              end: _newtabIconPosition)
                          .animate(CurvedAnimation(
                              curve: Curves.easeOutBack, parent: _animCont));
                      _animCont.forward();
                      _lastTabIconPosition = _newtabIconPosition;
                    }
                  },
                  icon: ShaderMask(
                    child: Icon(
                      icon,
                      size: this.pageIndex == pageIndex
                          ? _indicatorSize * 0.9
                          : _indicatorSize * 0.7,
                      color: Colors.white,
                    ),
                    shaderCallback: (bounds) => RadialGradient(
                            radius: 1,
                            center: Alignment.bottomCenter,
                            tileMode: TileMode.mirror,
                            colors: [Colors.cyan, Colors.deepPurple])
                        .createShader(bounds),
                  ),
                ),
              ),
            );
          },
        ),
        this.pageIndex == pageIndex
            ? Text(
                title,
                style: TextStyle(
                    fontSize: _textSize, color: Colors.white.withOpacity(0.5)),
              )
            : SizedBox(height: 0)
      ],
    );
  }

  bool _isEliptical() {
    return _animCont.value > 0.0 && _animCont.value < 0.9;
  }

  onPagechanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    print('pageController jumped');
    if (pageController.hasClients) {
      pageController.jumpToPage(
        pageIndex,
        // duration: Duration(milliseconds: 400),
        // curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.bgGray,
          body: PageView(
            children: [
              Dashboard(),
              First(),
              Profile()
            ],
            controller: pageController,
            onPageChanged: onPagechanged,
            physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Container(
            height: 68,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _getTabIcon(_icon1Key, Icons.event, "Home", 0),
                          _getTabIcon(_icon2Key, Icons.dashboard, "Dashboard", 1),
                          _getTabIcon(
                              _icon3Key, Icons.people ,"Profile", 2),
                        ],
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}