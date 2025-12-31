// lib/app/providers/auth_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth State Provider
///
/// Provides authentication state for the app.
/// Listens to Supabase auth state changes.
///
/// **State Includes**:
/// - Current authenticated user (User?)
/// - Authentication status (isAuthenticated)
/// - User ID (currentUserId)
///
/// **Usage**:
/// ```dart
/// // Watch auth state
/// final authState = ref.watch(authStateProvider);
///
/// // Check if authenticated
/// final isAuth = ref.watch(isAuthenticatedProvider);
///
/// // Get current user
/// final user = ref.watch(currentUserProvider);
/// ```
///
/// **Lifecycle**: App-wide (persists throughout app lifetime)
///
/// **Dependencies**: Supabase Auth Stream

/// Current auth state (user)
///
/// This provider listens to Supabase auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final supabase = Supabase.instance.client;

  return supabase.auth.onAuthStateChange.map((data) {
    final user = data.session?.user;
    return user;
  });
});

/// Check if user is authenticated
///
/// Derived from authStateProvider
/// IMPORTANT: During loading, check existing session to prevent premature redirect
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) => user != null,
    // During loading, check if there's an existing session
    // This prevents redirect to login while checking stored session
    loading: () {
      try {
        final session = Supabase.instance.client.auth.currentSession;
        return session != null;
      } catch (_) {
        return false;
      }
    },
    error: (_, __) => false,
  );
});

/// Get current user
///
/// Derived from authStateProvider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Get current user ID
///
/// Derived from currentUserProvider
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});
