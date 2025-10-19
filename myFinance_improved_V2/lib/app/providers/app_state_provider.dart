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

/// Provider specifically for user profile image URL
final userProfileImageProvider = Provider<String>((ref) {
  final displayData = ref.watch(userDisplayDataProvider);
  return displayData['profile_image'] ?? '';
});

/// Provider specifically for user first name
final userFirstNameProvider = Provider<String>((ref) {
  final displayData = ref.watch(userDisplayDataProvider);
  return displayData['user_first_name'] ?? 'User';
});

/// Provider specifically for user full name
final userFullNameProvider = Provider<String>((ref) {
  final displayData = ref.watch(userDisplayDataProvider);
  final firstName = displayData['user_first_name'] ?? '';
  final lastName = displayData['user_last_name'] ?? '';

  if (firstName.isEmpty && lastName.isEmpty) {
    return 'User';
  }
  return '$firstName $lastName'.trim();
});

/// Provider for user initials (for avatar fallback)
final userInitialsProvider = Provider<String>((ref) {
  final displayData = ref.watch(userDisplayDataProvider);
  final firstName = displayData['user_first_name'] ?? '';

  if (firstName.isNotEmpty) {
    return firstName[0].toUpperCase();
  }
  return 'U';
});
