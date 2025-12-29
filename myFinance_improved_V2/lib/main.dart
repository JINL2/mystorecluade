import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'core/monitoring/sentry_config.dart';
import 'core/services/revenuecat_service.dart';
import 'core/notifications/config/firebase_options.dart';
import 'core/notifications/services/badge_service.dart';
// Features now use @riverpod for DI - no override needed
// DI is handled in presentation/providers/di_providers.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // 📱 앱 버전 정보 출력 (디버그 모드에서만)
  if (kDebugMode) {
    final packageInfo = await PackageInfo.fromPlatform();
    debugPrint('═══════════════════════════════════════════');
    debugPrint('📱 MyFinance App Started');
    debugPrint('   Version: ${packageInfo.version}');
    debugPrint('   Build Number: ${packageInfo.buildNumber}');
    debugPrint('   Package: ${packageInfo.packageName}');
    debugPrint('═══════════════════════════════════════════');
  }

  // ✅ Initialize Sentry with error tracking
  await SentryConfig.init(() async {
    // 🔥 Initialize Firebase
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        debugPrint('🔥 Firebase initialized successfully');
      }
    } catch (e, stackTrace) {
      await SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Firebase initialization failed',
      );
      if (kDebugMode) {
        debugPrint('❌ Firebase initialization failed: $e');
      }
      // Continue running the app even if Firebase fails
    }

    // Initialize Supabase (always required)
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception('SUPABASE_URL or SUPABASE_ANON_KEY not found in .env file');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
    } catch (e, stackTrace) {
      // ✅ Log Supabase initialization failure to Sentry
      await SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Supabase initialization failed',
      );
      // Continue running the app even if Supabase fails
    }

    // Initialize RevenueCat for in-app purchases
    try {
      await RevenueCatService().initialize();
    } catch (e, stackTrace) {
      await SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'RevenueCat initialization failed',
      );
      // Continue running the app even if RevenueCat fails
    }

    // Initialize Badge Service for app icon badge
    try {
      await BadgeService().initialize();
    } catch (e, stackTrace) {
      await SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Badge Service initialization failed',
      );
      // Continue running the app even if Badge Service fails
    }

    runApp(
      const ProviderScope(
        // ✅ No overrides needed - @riverpod handles DI
        // Repository providers are defined in presentation/providers/di_providers.dart
        child: MyFinanceApp(),
      ),
    );
  });
}
