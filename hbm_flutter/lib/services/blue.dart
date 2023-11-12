import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';

class BtHandler {
  final String mac;
  BluetoothDevice? device;
  StreamController<int> valueController = StreamController<int>();
  late FlutterBlue flutterBlue;
  late BluetoothCharacteristic characteristic;

  BtHandler(this.mac) {
    flutterBlue = FlutterBlue.instance;
  }

  Stream<int> startHbMon() async* {
    // Scan for devices
    print('Scan starting');
    flutterBlue.scan().listen((scanResult) async {
      print('Discovered Device: ${scanResult.device.name} [${scanResult.device.id.id}]');

      if (scanResult.device.id.id == mac) {
        print('Found Target Device: ${scanResult.device.name}');
        // Stop scanning
        flutterBlue.stopScan();

        // Connect to the device
        device = scanResult.device;
        await device!.connect().then((_) {
          print('Connected to ${device!.name}');
        }).catchError((error) {
          print('Connection Error: $error');
        });

        // Discover services
        List<BluetoothService> services = await device!.discoverServices();
        print('Discovered ${services.length} services');

        bool isNotificationSet = false;
        for (BluetoothService service in services) {
          print('Service UUID: ${service.uuid.toString()}');

          for (BluetoothCharacteristic c in service.characteristics) {
            print('Characteristic UUID: ${c.uuid.toString()}');

            if (c.uuid.toString() == '00002a37-0000-1000-8000-00805f9b34fb' &&
                !isNotificationSet) {
              await c.setNotifyValue(true).then((_) {
                print('Notification set for UUID: ${c.uuid.toString()}');
                isNotificationSet = true;
              }).catchError((error) {
                print('Error setting notification: $error');
              });

              c.value.listen((value) {
                if (value.isNotEmpty) {
                  int dataValue = value.last;
                  valueController.add(dataValue);
                  print('Heart Rate Data: $dataValue');
                }
              });
            }
          }
        }
      }
    });

    yield* valueController.stream;
  }
}
