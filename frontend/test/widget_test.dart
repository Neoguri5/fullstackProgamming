import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('Dummy test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Movie List'), findsOneWidget);
  });
}
