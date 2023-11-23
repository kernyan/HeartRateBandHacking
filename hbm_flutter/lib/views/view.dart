import 'package:flutter/material.dart';
import 'package:hbm_flutter/services/blue.dart';
import 'package:hbm_flutter/services/notification_manager.dart';
import 'package:hbm_flutter/logic/utils.dart';

class HeartRateView extends StatefulWidget {
  @override
  _HeartRateViewState createState() => _HeartRateViewState();
}

class _HeartRateViewState extends State<HeartRateView> {
  BtHandler? btHandler;
  String zone = "Zone 1";
  int heartRate = 0;
  NotificationManager notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();
    notificationManager.initialize();
  }

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
              backgroundColor: _getZoneColor(zone),
              child: Text(zone, style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: 10),
            Text(
              "$heartRate bpm",
              style: TextStyle(fontSize: 25, color: Colors.black),
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

      notificationManager.showNotificationWithStats(
          'Heart Rate Monitor',
          'Current HR: $heartRate bpm, Zone: $zone'
      );
    });
  }

  Color _getZoneColor(String zone) {
    switch (zone) {
      case "Zone 1":
        return Colors.green;
      case "Zone 2":
        return Colors.lightGreen;
      case "Zone 3":
        return Colors.yellow;
      case "Zone 4":
        return Colors.orange;
      case "Zone 5":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}