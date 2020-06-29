import 'package:chinchiro/modules/chinchiro_play.dart';
import 'package:flutter/material.dart';

class ChinchiroScreen extends StatefulWidget {
  ChinchiroScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChinchiroScreenState createState() => _ChinchiroScreenState();
}

class _ChinchiroScreenState extends State<ChinchiroScreen> {
  final _sets = <ChinchiroPlay>[];
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
      _sets.add(ChinchiroPlay(numberDices: _numberDices));
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
