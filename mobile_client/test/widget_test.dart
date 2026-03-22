import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// THE FIX: Using a relative path instead of a package name
import '../lib/main.dart'; 

void main() {
  testWidgets('GeoPulse navigation screen loads test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GeoPulseApp());

    // Verify that our GeoPulse welcome text is present.
    expect(find.text('Tap anywhere to start routing with GeoPulse.'), findsOneWidget);

    // Verify that the initial icon is the waves icon (updated to match your main.dart)
    expect(find.byIcon(Icons.waves), findsOneWidget);
  });
}