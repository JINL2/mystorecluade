// lib/features/auth/presentation/providers/auth_state_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth State Provider
///
/// Provides authentication state for the app.
/// Listens to Supabase auth state changes.

/// Current auth state (user)
///
/// This provider listens to Supabase auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  print('[Auth Debug] 🔧 authStateProvider initialized');
  final supabase = Supabase.instance.client;

  print('[Auth Debug] 📡 Current session: ${supabase.auth.currentSession?.user?.id ?? 'null'}');

  return supabase.auth.onAuthStateChange.map((data) {
    final user = data.session?.user;
    print('[Auth Debug] 🔄 Auth state changed: ${user?.id ?? 'null'}');
    print('[Auth Debug] 📧 User email: ${user?.email ?? 'null'}');
    return user;
  });
});

/// Check if user is authenticated
///
/// Derived from authStateProvider
final isAuthenticatedProvider = Provider<bool>((ref) {
  print('[Auth Debug] 🔍 isAuthenticatedProvider called');
  final authState = ref.watch(authStateProvider);

  final result = authState.when(
    data: (user) {
      print('[Auth Debug] ✅ Auth state is Data, user: ${user?.id ?? 'null'}');
      return user != null;
    },
    loading: () {
      print('[Auth Debug] ⏳ Auth state is Loading');
      return false;
    },
    error: (error, stack) {
      print('[Auth Debug] ❌ Auth state is Error: $error');
      return false;
    },
  );

  print('[Auth Debug] 🎯 isAuthenticated result: $result');
  return result;
});

/// Get current user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Get current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});
