import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase is temporarily disabled
  bool firebaseEnabled = false;

  if (!firebaseEnabled) {
    // Push notifications disabled - Firebase not available
  }

  // Initialize Supabase (always required)
  try {
    await Supabase.initialize(
      url: 'https://atkekzwgukdvucqntryo.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    );
  } catch (e, stackTrace) {
    // Continue running the app even if Supabase fails
  }

  runApp(
    const ProviderScope(
      child: MyFinanceApp(),
    ),
  );
}
