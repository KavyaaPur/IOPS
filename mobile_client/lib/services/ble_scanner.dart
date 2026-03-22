import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleScannerService {
  final Map<String, int> _latestBeaconData = {};
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  Future<void> startScanning() async {
    if (await FlutterBluePlus.isSupported == false) return;

    await FlutterBluePlus.startScan(continuousUpdates: true);

    _scanSubscription = FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult r in results) {
        String advName = r.advertisementData.advName;
        String platformName = r.device.platformName;
        String deviceName = advName.isNotEmpty ? advName : platformName;
        deviceName = deviceName.trim();

        // If it sees our Node, save its signal strength!
        if (deviceName.toUpperCase().contains("NODE_")) {
          _latestBeaconData[deviceName] = r.rssi;
        }
      }
    });
  }

  void stopScanning() {
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
  }

  List<Map<String, dynamic>> getFormattedBlePayload() {
    List<Map<String, dynamic>> payload = [];
    
    Map<String, Map<String, double>> anchorCoordinates = {
      "Node_A": {"x": 0.0, "y": 0.0},
      "Node_B": {"x": 5.0, "y": 0.0},
      "Node_C": {"x": 2.5, "y": 5.0},
    };

    _latestBeaconData.forEach((nodeName, rssiValue) {
      if (anchorCoordinates.containsKey(nodeName)) {
        payload.add({
          "id": nodeName,
          "x": anchorCoordinates[nodeName]!["x"],
          "y": anchorCoordinates[nodeName]!["y"],
          "rssi": rssiValue,
        });
      }
    });

    return payload;
  }
}