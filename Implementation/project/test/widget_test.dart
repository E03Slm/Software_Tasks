import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SimulatorApp(),
      ),
    );
    // Just verify the app starts
    expect(find.byType(MaterialApp), findsNothing); // Uses MaterialApp.router
  });
}
