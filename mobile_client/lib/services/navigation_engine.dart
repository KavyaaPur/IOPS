import 'dart:async';
import 'ble_scanner.dart';
import 'api_client.dart';

class NavigationEngine {
  final BleScannerService _scanner = BleScannerService();
  final ApiClient _apiClient = ApiClient();
  
  Timer? _navigationLoop;
  bool _isNavigating = false;

  Future<void> startGeoPulseNavigation(String destinationNode, Function(Map<String, dynamic>) onDataReceived) async {
    if (_isNavigating) return;
    _isNavigating = true;

    print("--- [GeoPulse Engine: Starting] ---");
    await _scanner.startScanning();

    _navigationLoop = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      final blePayload = _scanner.getFormattedBlePayload();
      final mockImuData = {"step_detected": true, "accel_z": 9.8};
      const double mockYaw = 90.0; 

      if (blePayload.isNotEmpty) {
         final response = await _apiClient.sendSensorData(
           bleData: blePayload,
           imuData: mockImuData,
           currentYaw: mockYaw,
           destination: destinationNode,
         );

         if (response != null) {
            onDataReceived(response);
         }
      } else {
         onDataReceived({
           "instruction": "Searching for environment...",
           "x": 0.0, "y": 0.0, "distance": 0.0, "latency_ms": 0, "mode": "Scanning Area..."
         });
      }
    });
  }

  void stopNavigation() {
    _isNavigating = false;
    _navigationLoop?.cancel();
    _scanner.stopScanning();
    print("--- [GeoPulse Engine: Stopped] ---");
  }
}