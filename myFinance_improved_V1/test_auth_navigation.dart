import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance/presentation/app/main_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('Auth navigation test', (WidgetTester tester) async {
    // Initialize Supabase for testing
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );

    // Build our app and trigger a frame
    await tester.pumpWidget(
      const ProviderScope(
        child: MainApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify we're on the login page
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Sign in securely'), findsOneWidget);

    // Find and tap the "Create account" button
    final createAccountButton = find.text('Create account');
    expect(createAccountButton, findsOneWidget);
    
    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();

    // Verify we're on the signup page
    expect(find.text('Join Storebase'), findsOneWidget);
    expect(find.text('Business Information'), findsOneWidget);

    // Find and tap the "Sign in" link
    final signInLink = find.text('Sign in');
    expect(signInLink, findsOneWidget);
    
    await tester.tap(signInLink);
    await tester.pumpAndSettle();

    // Verify we're back on the login page
    expect(find.text('Welcome back!'), findsOneWidget);
  });
}