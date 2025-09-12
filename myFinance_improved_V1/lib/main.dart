import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:logger/logger.dart';
import 'core/notifications/config/firebase_options.dart';
import 'presentation/app/app.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Background message received:
  // Message ID: ${message.messageId}
  // Title: ${message.notification?.title}
  // Body: ${message.notification?.body}
  // Data: ${message.data}
  
  // Handle background message here
  // Note: You can't update UI directly from here
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // final logger = Logger();
  
  // Skip Firebase initialization completely if configuration is not ready
  // This prevents crashes when Firebase is not properly configured
  bool firebaseEnabled = false;
  
  try {
    // Check if Firebase can be initialized
    if (Firebase.apps.isEmpty) {
      // Checking Firebase availability...
      
      // Try to check if valid Firebase configuration exists
      // This will throw if configuration is invalid or missing
      try {
        final options = DefaultFirebaseOptions.currentPlatform;
        
        // Check for placeholder values that indicate unconfigured Firebase
        if (!options.apiKey.contains('YOUR_') && 
            options.apiKey.isNotEmpty &&
            !options.appId.contains('YOUR_') &&
            options.appId.isNotEmpty) {
          
          // Configuration looks valid, try to initialize
          await Firebase.initializeApp(options: options);
          firebaseEnabled = true;
          // Firebase initialized successfully
          
          // CRITICAL: Configure iOS to NOT show notifications when app is in foreground
          // This prevents the annoying notification banner from appearing
          await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: false,  // Don't show the notification banner
            badge: true,   // Still update the badge counter
            sound: false,  // Don't play sound
          );
          
          // Set up background message handler
          FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
        } else {
          // Firebase not configured - using placeholder values
          // Run "flutterfire configure" to set up Firebase
        }
      } on UnsupportedError catch (e) {
        // This happens when DefaultFirebaseOptions throws for unconfigured platform
        // Firebase not configured for this platform
        // Run "flutterfire configure" to set up Firebase
      } catch (e) {
        // Any other error accessing configuration
        // Firebase configuration error: ${e.toString()}
      }
    } else {
      firebaseEnabled = true;
      // Firebase already initialized
    }
  } catch (e) {
    // Firebase initialization skipped: ${e.toString()}
  }
  
  if (!firebaseEnabled) {
    // Push notifications disabled - Firebase not available
  }
  
  // Initialize Supabase (always required)
  try {
    // Initializing Supabase...
    await Supabase.initialize(
      url: 'https://atkekzwgukdvucqntryo.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    );
    // Supabase initialized
  } catch (e, stackTrace) {
    // Failed to initialize Supabase: $e
    // Continue running the app even if Supabase fails
  }
  
  runApp(
    const ProviderScope(
      child: MyFinanceApp(),
    ),
  );
}