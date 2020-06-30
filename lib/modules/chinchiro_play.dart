import 'dart:math' show Random;

import 'package:chinchiro/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ChinchiroPlay extends StatefulWidget {
  ChinchiroPlay({Key key, this.numberDices = 1}) : super(key: key);

  final int numberDices;

  @override
  _ChinchiroPlayState createState() => _ChinchiroPlayState();
}

class _ChinchiroPlayState extends State<ChinchiroPlay>
    with TickerProviderStateMixin {
  // 0:dice = 0 = fake = motion
  var _diceIcons = <Widget>[
    Icon(Icons.help),
    Icon(
      Icons.looks_one,
      color: Colors.red,
      size: 50.0,
    ),
    Icon(Icons.looks_two),
    Icon(Icons.looks_3),
    Icon(Icons.looks_4),
    Icon(Icons.looks_5),
    Icon(Icons.looks_6),
  ];
  final _dices = <Icon>[];

  // For chinchiro
  List<int> _chinchiroResultList = [];
  int _chinchiroResultNumber;
  String _chinchiroResult = "チンチロの結果";

  // For Animation
  AnimationController _animationController;
  double _containerPaddingLeft;
  double _animationValue;
  double _translateX;
  double _translateY;
  double _rotate;
  double _scale;
  bool show;
  bool _diceRollNow;
  Color _color;

  @override
  void initState() {
    super.initState();
    _initDices();
    // For Animation
    _initAnimationValue();
    _initAnimation();
  }

  // For Animation
  void _initAnimationValue() {
    _containerPaddingLeft = 20.0;
    _translateX = 0;
    _translateY = 0;
    _rotate = 0;
    _scale = 1;
    _diceRollNow = false;
    _color = Colors.lightBlue;
  }

  // For Animation
  void _initAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
          _color = Colors.green;
        } else if (_animationValue >= 0.4 && _animationValue <= 0.5) {
          _translateX = 80.0;
          _rotate = -20.0;
          _scale = 0.1;
        } else if (_animationValue >= 0.5 && _animationValue <= 0.8) {
          _translateY = -20.0;
        } else if (_animationValue >= 0.81) {
          _containerPaddingLeft = 20.0;
          _diceRollNow = true;

          // Add
          //sleep(Duration(seconds: 1));
          _diceRollNow = false;
          _initAnimationValue();
          _initAnimation();
          // Dice Roll
          _diceRoll();
        }
      });
    });
  }

  void _initDices() {
    setState(() {
      for (var i = 0; i < widget.numberDices; i++) {
        _dices.add(_diceIcons[0]);
      }
    });
  }

  void _createDices() {
    setState(() {
      _chinchiroResultList = [];
      for (var i = 0; i < widget.numberDices; i++) {
        int dice = Random().nextInt(6) + 1;
        _dices.add(_diceIcons[dice]);
        _chinchiroResultList.add(dice);
      }
      _chinchiroResultList.sort();
    });
  }

  Widget _buildDiceWidgets(List<Widget> dices) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) => dices[index],
      itemCount: dices.length,
    );
  }

  void _diceRoll() {
    setState(() {
      _dices.removeRange(0, _dices.length);
      _createDices();
      _chinchiroResultCheck();
    });
  }

  void _chinchiroResultCheck() {
    _chinchiroResultNumber = _chinchiroResultList[0] * 100 +
        _chinchiroResultList[1] * 10 +
        _chinchiroResultList[2];
    _chinchiroResult = kChinchiroResults[_chinchiroResultNumber];
  }

  void _notifyDiceRoll() {
//    // 1: icon
//    setState(() {
//      _dices.removeRange(0, _dices.length);
//      _initDices();
//    });
//    sleep(Duration(seconds: 1));

    // 2: vibration
    Vibration.vibrate(pattern: [50, 100, 50, 200]);
  }

  @override
  Widget build(BuildContext context) {
    var gridView = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildDiceWidgets(_dices),
    );

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: gridView,
            ),
            const SizedBox(height: 24.0),
            Text("$_chinchiroResult"),
            Padding(
                padding: EdgeInsets.all(0.0),
                child: Center(
                    child: GestureDetector(
                        onTap: () {
                          _animationController.forward();
                          _notifyDiceRoll();
                        },
                        child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: _color,
                              borderRadius: BorderRadius.circular(100.0),
                              boxShadow: [
                                BoxShadow(
                                  color: _color,
                                  blurRadius: 21,
                                  spreadRadius: -15,
                                  offset: Offset(
                                    0.0,
                                    20.0,
                                  ),
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(
                                left: _containerPaddingLeft,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                (!_diceRollNow)
                                    ? AnimatedContainer(
                                        duration: Duration(milliseconds: 400),
                                        child: Icon(Icons.send),
                                        curve: Curves.fastOutSlowIn,
                                        transform: Matrix4.translationValues(
                                            _translateX, _translateY, 0)
                                          ..rotateZ(_rotate)
                                          ..scale(_scale),
                                      )
                                    : Container(),
                                AnimatedSize(
                                  vsync: this,
                                  duration: Duration(milliseconds: 600),
                                  child: show
                                      ? SizedBox(width: 10.0)
                                      : Container(),
                                ),
                                AnimatedSize(
                                  vsync: this,
                                  duration: Duration(milliseconds: 200),
                                  child: show ? Text("Dice Roll") : Container(),
                                ),
                                AnimatedSize(
                                  vsync: this,
                                  duration: Duration(milliseconds: 200),
                                  child: _diceRollNow
                                      ? Icon(Icons.done)
                                      : Container(),
                                ),
                                AnimatedSize(
                                  vsync: this,
                                  alignment: Alignment.topLeft,
                                  duration: Duration(milliseconds: 600),
                                  child: _diceRollNow
                                      ? SizedBox(width: 10.0)
                                      : Container(),
                                ),
                                AnimatedSize(
                                  vsync: this,
                                  duration: Duration(milliseconds: 200),
                                  child:
                                      _diceRollNow ? Text("Done") : Container(),
                                ),
                              ],
                            ))))),
          ],
        ),
      ),
    );
  }
}
