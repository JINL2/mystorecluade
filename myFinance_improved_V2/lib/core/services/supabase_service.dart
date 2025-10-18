import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Wrapper service for Supabase client
class SupabaseService {
  /// Get the Supabase client instance
  SupabaseClient get client => Supabase.instance.client;
  
  /// Get the current user
  User? get currentUser => client.auth.currentUser;
  
  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;
}