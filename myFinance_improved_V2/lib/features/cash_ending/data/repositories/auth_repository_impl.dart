// lib/features/cash_ending/data/repositories/auth_repository_impl.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

/// Repository Implementation for Authentication (Data Layer)
///
/// Implements the domain repository interface.
/// Uses Supabase for authentication.
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  String? getCurrentUserId() {
    try {
      return _supabaseClient.auth.currentUser?.id;
    } catch (e) {
      // Return null if there's any error getting user ID
      return null;
    }
  }

  @override
  bool isAuthenticated() {
    try {
      final session = _supabaseClient.auth.currentSession;
      return session != null;
    } catch (e) {
      return false;
    }
  }
}
