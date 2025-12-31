// lib/app/providers/app_state_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_state.dart';
import 'app_state_notifier.dart';

/// App State Provider
///
/// Provides global app state using the Freezed AppState class
/// and AppStateNotifier for state management.
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// =====================================================
// USER DISPLAY DATA PROVIDERS
// These providers watch AppState and provide user display data
// =====================================================

/// Provider for user display data (name, profile image)
/// This is the SINGLE SOURCE OF TRUTH for UI components
final userDisplayDataProvider = Provider<Map<String, dynamic>>((ref) {
  final appState = ref.watch(appStateProvider);
  final userData = appState.user;

  // Return user display data from AppState
  if (userData.isNotEmpty) {
    return {
      'profile_image': userData['profile_image'] ?? '',
      'user_first_name': userData['user_first_name'] ?? '',
      'user_last_name': userData['user_last_name'] ?? '',
      'user_email': userData['user_email'] ?? '',
      'user_id': userData['user_id'] ?? '',
      // Include full userData for compatibility
      ...userData,
    };
  }

  // Return empty map if no user data
  return {};
});

