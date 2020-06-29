// DartPad用からリファクタリング
import 'package:chinchiro/screens/chinchiro_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          size: 50,
        ),
      ),
      home: ChinchiroScreen(),
    );
  }
}
