import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_tts/flutter_tts.dart';
import 'services/navigation_engine.dart';

void main() {
  runApp(const GeoPulseApp());
}

class GeoPulseApp extends StatelessWidget {
  const GeoPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoPulse Positioning',
      theme: ThemeData(
        brightness: Brightness.dark,
        // Deep Anime Night Sky background
        scaffoldBackgroundColor: const Color(0xFF0B001A), 
      ),
      home: const NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final NavigationEngine _engine = NavigationEngine();
  final FlutterTts _tts = FlutterTts();
  
  bool _isNavigating = false;
  DateTime? _lastSpokenTime;
  
  // State tracker to prevent vibration spam!
  String _lastInstruction = ""; 

  String _displayInstruction = "TAP TO SYNC NEO-PULSE.";
  double _currentX = 0.0;
  double _currentY = 0.0;
  double _distance = 0.0;
  int _latency = 0;
  String _mode = "SYSTEM STANDBY";

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5); 
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.2); // Slightly higher pitch for an "anime AI" voice
  }

  void _handleEngineUpdate(Map<String, dynamic> data) async {
    final now = DateTime.now();
    final instruction = data['instruction'] ?? "Calculating...";

    if (mounted) {
      setState(() {
        _displayInstruction = instruction;
        _currentX = (data['x'] ?? 0.0).toDouble();
        _currentY = (data['y'] ?? 0.0).toDouble();
        _distance = (data['distance'] ?? 0.0).toDouble();
        if (data['latency_ms'] != null) _latency = (data['latency_ms']).toInt();
        _mode = data['mode'] ?? "NEO-FUSION ACTIVE";

        // --- FIXED HAPTIC FEEDBACK ---
        // Only vibrate if the instruction actually changed!
        if (instruction != _lastInstruction && instruction != "Searching for environment...") {
          _lastInstruction = instruction; // Update tracker
          
          if (instruction.contains("arrived")) {
            HapticFeedback.heavyImpact(); // Strong bump
            Future.delayed(const Duration(milliseconds: 200), () => HapticFeedback.heavyImpact()); // Double bump!
          } else if (instruction.contains("left") || instruction.contains("right")) {
            HapticFeedback.vibrate(); // Standard solid vibration for turns
          } else if (instruction.contains("straight")) {
            HapticFeedback.lightImpact(); // Soft tick for going straight
          }
        }
      });
    }

    // TTS Voice Logic (speaks every 3 seconds)
    if (_lastSpokenTime == null || now.difference(_lastSpokenTime!).inSeconds >= 3) {
      _lastSpokenTime = now;
      if (instruction != "Searching for environment...") {
        await _tts.speak(instruction);
      }
    }
  }

  void _toggleNavigation() async {
    if (_isNavigating) {
      _engine.stopNavigation();
      await _tts.speak("System disconnected.");
      setState(() {
        _isNavigating = false;
        _displayInstruction = "LINK SEVERED.\nTAP TO RECONNECT.";
        _mode = "SYSTEM STANDBY";
        _lastInstruction = ""; // reset tracker
      });
    } else {
      setState(() {
        _isNavigating = true;
        _displayInstruction = "INITIALIZING QUANTUM LINK...";
        _mode = "ESTABLISHING NETWORK...";
      });
      await _tts.speak("Link established. Commencing navigation.");
      await _engine.startGeoPulseNavigation("Exit", _handleEngineUpdate);
    }
  }

  @override
  void dispose() {
    _engine.stopNavigation();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double mapSize = 320.0; 
    const double scale = mapSize / 5.0; 

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: _toggleNavigation,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top HUD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B0B3B), // Deep anime purple
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isNavigating ? Colors.pinkAccent : Colors.grey.withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: _isNavigating ? [
                      BoxShadow(color: Colors.pinkAccent.withOpacity(0.4), blurRadius: 15, spreadRadius: 2)
                    ] : [],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "E V A - NAVIGATOR",
                        style: TextStyle(
                          color: Colors.pinkAccent, 
                          fontSize: 20, 
                          fontWeight: FontWeight.w900, 
                          fontStyle: FontStyle.italic,
                          letterSpacing: 4
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("STATUS: $_mode", style: const TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("X: ${_currentX.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                          Text("Y: ${_currentY.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                          Text("DIST: ${_distance.toStringAsFixed(2)}m", style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("PING: $_latency ms", style: const TextStyle(color: Colors.yellowAccent, fontSize: 12, fontFamily: 'monospace')),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Anime Radar Grid
                Opacity(
                  opacity: _isNavigating ? 1.0 : 0.2, 
                  child: Container(
                    width: mapSize,
                    height: mapSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFF050012),
                      border: Border.all(color: Colors.pinkAccent, width: 3),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.pinkAccent.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)
                      ]
                    ),
                    child: Stack(
                      children: [
                        CustomPaint(painter: GridPainter(), size: const Size(mapSize, mapSize)),
                        // Node Icon
                        Positioned(
                          bottom: 5 * scale - 24, 
                          left: 2.5 * scale - 12, 
                          child: const Icon(Icons.wifi_tethering, color: Colors.cyanAccent, size: 24)
                        ),
                        // Target Exit Flag
                        Positioned(
                          bottom: 0, // 0 in standard coords = bottom 
                          left: 5 * scale - 28, 
                          child: const Icon(Icons.location_on, color: Colors.greenAccent, size: 32)
                        ),
                        // The User (Glowing Anime Star)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 400), 
                          curve: Curves.easeOutCirc,
                          bottom: (_currentY * scale).clamp(0.0, mapSize - 20.0), 
                          left: (_currentX * scale).clamp(0.0, mapSize - 20.0),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.cyanAccent, blurRadius: 15, spreadRadius: 4),
                                BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Instruction Text
                Text(
                  _displayInstruction.toUpperCase(),
                  style: TextStyle(
                    color: _displayInstruction.contains("arrived") ? Colors.greenAccent : Colors.cyanAccent, 
                    fontSize: 26, 
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                    shadows: [
                      Shadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 10)
                    ]
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Neon Pink Radar Grid
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pinkAccent.withOpacity(0.2)
      ..strokeWidth = 1.5;
    for (double i = 0; i < size.width; i += size.width / 5) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}