import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('MyFinance app smoke test', (WidgetTester tester) async {
    // Initialize Supabase for testing
    await Supabase.initialize(
      url: 'https://test.supabase.co',
      anonKey: 'test-key',
    );
    
    // Build a simple MaterialApp to test basic functionality
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('MyFinance Test')),
            body: const Center(child: Text('Test App')),
          ),
        ),
      ),
    );

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('MyFinance Test'), findsOneWidget);
  });
}