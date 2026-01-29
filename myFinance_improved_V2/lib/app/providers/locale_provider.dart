import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/my_page/domain/repositories/user_profile_repository.dart';
import '../../features/my_page/presentation/providers/user_profile_providers.dart';
import 'auth_providers.dart';

/// Locale state notifier
class LocaleNotifier extends StateNotifier<Locale> {
  final UserProfileRepository? _repository;

  LocaleNotifier({UserProfileRepository? repository})
      : _repository = repository,
        super(const Locale('en')) {
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

  /// Load locale from database via repository
  Future<void> loadLocaleFromDatabase(String userId) async {
    if (_repository == null) return;

    try {
      // Fetch user profile (includes language info)
      final userProfile = await _repository!.getUserProfile(userId);

      if (userProfile != null && userProfile.languageCode != null) {
        final languageCode = userProfile.languageCode!;
        if (_locales.containsKey(languageCode)) {
          await setLocale(languageCode);
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
  final repository = ref.watch(userProfileRepositoryProvider);
  final notifier = LocaleNotifier(repository: repository);

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
