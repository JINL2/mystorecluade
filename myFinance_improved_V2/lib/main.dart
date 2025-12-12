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
import 'features/attendance/data/providers/attendance_data_providers.dart'
    as attendance_data;
import 'features/attendance/domain/providers/attendance_repository_provider.dart'
    as attendance_domain;
import 'features/journal_input/data/repositories/repository_providers.dart'
    as journal_data;
import 'features/journal_input/domain/providers/repository_providers.dart'
    as journal_domain;
import 'features/store_shift/data/repositories/repository_providers.dart'
    as store_shift_data;
import 'features/store_shift/domain/providers/repository_provider.dart'
    as store_shift_domain;

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

    runApp(
      ProviderScope(
        overrides: [
          // Override domain layer provider with data layer implementation
          // Attendance feature
          attendance_domain.attendanceRepositoryProvider
              .overrideWithProvider(attendance_data.attendanceRepositoryProviderImpl),
          // Journal Input feature
          journal_domain.journalEntryRepositoryProvider
              .overrideWithProvider(journal_data.journalEntryRepositoryProvider),
          // Store Shift feature
          store_shift_domain.storeShiftRepositoryProvider
              .overrideWithProvider(store_shift_data.storeShiftRepositoryImplProvider),
        ],
        child: const MyFinanceApp(),
      ),
    );
  });
}
