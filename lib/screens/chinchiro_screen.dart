import 'package:chinchiro/modules/chinchiro_play.dart';
import 'package:flutter/material.dart';

class ChinchiroScreen extends StatefulWidget {
  @override
  _ChinchiroScreenState createState() => _ChinchiroScreenState();
}

class _ChinchiroScreenState extends State<ChinchiroScreen> {
  final _chinchiroSets = <ChinchiroPlay>[];
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
      _chinchiroSets.add(ChinchiroPlay(numberDices: _numberDices));
    });
  }

  void _removeSets() {
    setState(() {
      if (_chinchiroSets.isNotEmpty) {
        _chinchiroSets.removeAt(_chinchiroSets.length - 1); //配列の最後尾を削除
      }
    });
  }

  void _changeNumberDices(int number) {
    setState(() {
      if ((_numberDices < 2) && number < 0) {
        return;
      }
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
      child: _buildSetWidgets(_chinchiroSets),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('チンチロリン'),
      ),
      body: gridView,
      persistentFooterButtons: <Widget>[
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('人数：${_chinchiroSets.length}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _createSets,
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: _removeSets,
              ),
              Text('ダイス個数：$_numberDices'),
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
