import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Current User ID Provider
///
/// Provides the authenticated user's ID from Supabase auth state.
/// Returns null if user is not authenticated.
///
/// This provider encapsulates the Supabase dependency for getting
/// current user ID, preventing direct Supabase access in pages.
///
/// Usage:
/// ```dart
/// final userId = ref.watch(currentUserIdProvider);
/// if (userId == null) {
///   // User not authenticated
/// }
/// ```
final currentUserIdProvider = Provider<String?>((ref) {
  return Supabase.instance.client.auth.currentUser?.id;
});
