import 'dart:math' show Random;

import 'package:chinchiro/utilities/constants.dart';
import 'package:flutter/material.dart';

class ChinchiroPlay extends StatefulWidget {
  ChinchiroPlay({Key key, this.numberDices = 1}) : super(key: key);

  final int numberDices;

  @override
  _ChinchiroPlayState createState() => _ChinchiroPlayState();
}

class _ChinchiroPlayState extends State<ChinchiroPlay> {
  var _diceIcons = <Widget>[
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

  @override
  void initState() {
    super.initState();
    _createDices();
  }

  void _createDices() {
    setState(() {
      _chinchiroResultList = [];
      for (var i = 0; i < widget.numberDices; i++) {
        int dice = Random().nextInt(6);
        _dices.add(_diceIcons[dice]);
        _chinchiroResultList.add(dice + 1);
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _diceRoll,
        tooltip: 'Increment',
        child: Icon(Icons.update),
      ),
    );
  }
}
