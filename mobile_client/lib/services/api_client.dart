import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // THE FIX: Updated to your exact laptop Wi-Fi IPv4 address
final String baseUrl = "http://10.41.118.20:5000";  Future<Map<String, dynamic>?> sendSensorData({
    required List<Map<String, dynamic>> bleData,
    required Map<String, dynamic> imuData,
    required double currentYaw,
    required String destination,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/navigate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ble_data': bleData,
          'imu_data': imuData,
          'current_yaw': currentYaw,
          'destination': destination,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("GeoPulse API Error: Server returned ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("GeoPulse API Connection Failed: Is the laptop server running?");
      return null;
    }
  }
}