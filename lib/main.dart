import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('191263 Bojan Sekuloski'),
      ),
      body: Container(
        color: Colors.blue[900],
      ),
    ));
  }
}
