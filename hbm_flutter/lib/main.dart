import 'package:flutter/material.dart';
import 'package:hbm_flutter/views/view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeartRateMonitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HeartRateView(),
    );
  }
}
