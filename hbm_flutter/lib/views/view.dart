import 'package:flutter/material.dart';
import 'package:hbm_flutter/services/blue.dart';
import 'package:hbm_flutter/logic/utils.dart';

class HeartRateView extends StatefulWidget {
  @override
  _HeartRateViewState createState() => _HeartRateViewState();
}

class _HeartRateViewState extends State<HeartRateView> {
  BtHandler? btHandler;
  String zone = "Zone 1";
  int heartRate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Heart Rate Monitor"),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth_connected),
            onPressed: connectToDevice,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              child: Text(zone, style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: 10),
            Text(
              "$heartRate bpm",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void connectToDevice() async {
    btHandler = BtHandler("FE:3F:08:A0:0F:C7");
    btHandler!.startHbMon().listen((rate) {
      setState(() {
        heartRate = rate;
        zone = rateToZone(rate);
      });
    });
  }
}