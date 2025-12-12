import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_providers.dart';

/// Locale state notifier
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  static const String _localeKey = 'app_locale';

  /// Language code to Locale mapping
  static const Map<String, Locale> _locales = {
    'ko': Locale('ko'),
    'en': Locale('en'),
    'vi': Locale('vi'),
  };

  /// Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null && _locales.containsKey(languageCode)) {
        state = _locales[languageCode]!;
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }
  }

  /// Load locale from Supabase user profile
  Future<void> loadLocaleFromDatabase(String userId) async {
    try {
      // Fetch user's language preference from database
      final userResponse = await Supabase.instance.client
          .from('users')
          .select('user_language')
          .eq('user_id', userId)
          .maybeSingle();

      if (userResponse != null && userResponse['user_language'] != null) {
        final userLanguageId = userResponse['user_language'] as String;

        // Fetch language details
        final languageResponse = await Supabase.instance.client
            .from('languages')
            .select('language_code')
            .eq('language_id', userLanguageId)
            .maybeSingle();

        if (languageResponse != null) {
          final languageCode = languageResponse['language_code'] as String;

          if (_locales.containsKey(languageCode)) {
            await setLocale(languageCode);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading locale from database: $e');
    }
  }

  /// Change app locale
  Future<void> setLocale(String languageCode) async {
    if (!_locales.containsKey(languageCode)) {
      debugPrint('Unsupported language code: $languageCode');
      return;
    }

    // Update state
    state = _locales[languageCode]!;

    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  /// Get current language code
  String get currentLanguageCode {
    return state.languageCode;
  }
}

/// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final notifier = LocaleNotifier();

  // Load locale from database when user is authenticated
  ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
    next.whenData((user) {
      if (user != null) {
        notifier.loadLocaleFromDatabase(user.id);
      }
    });
  });

  return notifier;
});
