import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic setup smoke test', (WidgetTester tester) async {
    // A simple test to ensure the test environment is healthy
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Test'))));
    expect(find.text('Test'), findsOneWidget);
  });
}
