// DartPad用からリファクタリング
import 'dart:math' show Random;

import 'package:flutter/material.dart';

// #########################################################################
// ##### Start:main.dart#####
// import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          size: 50,
        ),
      ),
      home: DiceRoute(),
    );
  }
}
// ##### Finish:main.dart#####
// #########################################################################

// #########################################################################
// ##### Start:DiceRoute.dart#####
//import 'package:flutter/material.dart';
//import 'dart:math' show Random;
class DiceRoute extends StatefulWidget {
  DiceRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DiceRouteState createState() => _DiceRouteState();
}

class _DiceRouteState extends State<DiceRoute> {
  final _sets = <Dice>[];
  int _numberDices = 3;

  Widget _buildSetWidgets(List<Widget> dices) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) => dices[index],
      itemCount: dices.length,
    );
  }

  void _createSets() {
    setState(() {
      _sets.add(Dice(numberDices: _numberDices));
    });
  }

  void _removeSets() {
    setState(() {
      _sets.removeAt(_sets.length - 1); //配列の最後尾を削除したい
    });
  }

  void _changeNumberDices(int number) {
    setState(() {
      _numberDices += number;
    });
  }

  @override
  void initState() {
    super.initState();
    _createSets();
    _createSets();
  }

  @override
  Widget build(BuildContext context) {
    final gridView = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildSetWidgets(_sets),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("チンチロリン"),
      ),
      body: gridView,
      persistentFooterButtons: <Widget>[
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("人数：$_sets"),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _createSets,
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: _removeSets,
              ),
              Text("ダイス個数：$_numberDices"),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _changeNumberDices(1),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => _changeNumberDices(-1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// ##### Finish:DiceRoute.dart#####
// #########################################################################

// #########################################################################
// ##### Start:Dice.dart#####
//import 'package:flutter/material.dart';
class Dice extends StatefulWidget {
  Dice({Key key, this.numberDices = 1}) : super(key: key);

  final int numberDices;

  @override
  _DiceState createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  var _randomizer = Random(); // can get a seed as a parameter
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

  // For chinchillo
  List<int> _chinchilloResultList = [];
  int _chinchilloResultNumber;
  String _chinchilloResult = "チンチロの結果";
//   （強）
// アラシ : 3つのサイコロすべてがゾロ目
// シゴロ : サイコロの目が(4, 5, 6)
// ロッポウ : 3つ中2つのサイコロがゾロ目、ゾロ目でないサイコロが6の目（例：5, 5, 6）
// ゴケ : 3つ中2つのサイコロがゾロ目、ゾロ目でないサイコロが5の目
// ヨツヤ : 3つ中2つのサイコロがゾロ目、ゾロ目でないサイコロが4の目
// サンタ : 3つ中2つのサイコロがゾロ目、ゾロ目でないサイコロが3の目
// ニゾウ : 3つ中2つのサイコロがゾロ目、ゾロ目でないサイコロが2の目
// ピン : 3つ中2つのサイコロがゾロ目、ゾロ目でないサイコロが1の目
// 目なし : 3つの目それぞれ値が違ったとき
// ヒフミ : サイコロの目が(1, 2, 3)
// （弱）
  static Map _mapResults = {
    111: 'ピンゾロアラシ',
    112: 'ニゾウ',
    113: 'サンタ',
    114: 'ヨツヤ',
    115: 'ゴケ',
    116: 'ロッポウ',
    122: 'ピン',
    123: 'ヒフミ',
    124: '目無し',
    125: '目無し',
    126: '目無し',
    133: 'ピン',
    134: '目無し',
    135: '目無し',
    136: '目無し',
    144: 'ピン',
    145: '目無し',
    146: '目無し',
    155: 'ピン',
    156: '目無し',
    166: 'ピン',
    222: 'アラシ',
    223: 'サンタ',
    224: 'ヨツヤ',
    225: 'ゴケ',
    226: 'ロッポウ',
    233: 'ニゾウ',
    234: '目無し',
    235: '目無し',
    236: '目無し',
    244: 'ニゾウ',
    245: '目無し',
    246: '目無し',
    255: 'ニゾウ',
    256: '目無し',
    266: 'ニゾウ',
    333: 'アラシ',
    334: 'ヨツヤ',
    335: 'ゴケ',
    336: 'ロッポウ',
    344: 'サンタ',
    345: '目無し',
    346: '目無し',
    355: 'サンタ',
    356: '目無し',
    366: 'サンタ',
    444: 'アラシ',
    445: 'ゴケ',
    446: 'ロッポウ',
    455: 'ヨツヤ',
    456: 'シゴロ',
    466: 'ヨツヤ',
    555: 'アラシ',
    556: 'ロッポウ',
    566: 'ゴケ',
    666: 'アラシ',
  };

  @override
  void initState() {
    super.initState();
    _createDices();
  }

  void _createDices() {
    setState(() {
      _chinchilloResultList = [];
      for (var i = 0; i < widget.numberDices; i++) {
        int dice = _randomizer.nextInt(6);
        _dices.add(_diceIcons[dice]);
        _chinchilloResultList.add(dice + 1);
      }
      _chinchilloResultList.sort();
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
      _chinchilloResultCheck();
    });
  }

  void _chinchilloResultCheck() {
    _chinchilloResultNumber = _chinchilloResultList[0] * 100 +
        _chinchilloResultList[1] * 10 +
        _chinchilloResultList[2];
    _chinchilloResult = _mapResults[_chinchilloResultNumber];
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
            Text("$_chinchilloResult"),
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
// ##### Finish:Dice.dart#####
// #########################################################################
