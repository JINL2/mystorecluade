import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/monitoring/sentry_config.dart';
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

  // ✅ Initialize Sentry with error tracking
  await SentryConfig.init(() async {
    // Firebase is temporarily disabled
    bool firebaseEnabled = false;

    if (!firebaseEnabled) {
      // Push notifications disabled - Firebase not available
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

    runApp(
      ProviderScope(
        overrides: [
          // Override domain layer provider with data layer implementation
          journal_domain.journalEntryRepositoryProvider.overrideWith(
            (ref) => ref.watch(journal_data.journalEntryRepositoryProvider),
          ),
          // Store Shift: Override domain provider with data layer implementation
          store_shift_domain.storeShiftRepositoryProvider.overrideWith(
            (ref) => ref.watch(store_shift_data.storeShiftRepositoryImplProvider),
          ),
        ],
        child: const MyFinanceApp(),
      ),
    );
  });
}
