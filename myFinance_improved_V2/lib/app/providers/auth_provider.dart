import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth state notifier
class AuthStateNotifier extends StateNotifier<User?> {
  
  AuthStateNotifier() : super(null) {
    // Initialize with current user
    state = Supabase.instance.client.auth.currentUser;
    
    // Listen to auth state changes
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        final newUser = data.session?.user;
        state = newUser;
      },
    );
  }
  
  late final _subscription;
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign in failed');
      }
      
      state = response.user;
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }
  
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'full_name': '$firstName $lastName', // Keep for backward compatibility
        },
      );
      
      
      // Supabase signup can succeed even with email confirmation enabled
      // The user just won't be fully authenticated until they confirm
      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      // Don't set state - user needs to verify email if confirmation is enabled
      // User profile will be created automatically by app_state when they log in
    } catch (e) {
      
      // Parse the error message for better user feedback
      String errorMessage = e.toString().toLowerCase();
      
      if (errorMessage.contains('user already registered') || 
          errorMessage.contains('email already')) {
        throw Exception('An account with this email already exists');
      } else if (errorMessage.contains('invalid email') || 
                 errorMessage.contains('email')) {
        throw Exception('Please enter a valid email address');
      } else if (errorMessage.contains('password') && 
                 errorMessage.contains('6')) {
        throw Exception('Password must be at least 6 characters');
      } else if (errorMessage.contains('signup is disabled')) {
        throw Exception('Account registration is currently disabled');
      } else {
        throw Exception('Sign up failed: ${e.toString().replaceAll('Exception: ', '')}');
      }
    }
  }
  
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    state = null;
  }

  Future<void> resetPassword(String email) async {
    try {
      
      // Use a simple web redirect or remove redirectTo entirely
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        // Remove custom redirect to avoid configuration issues
      );
      
    } catch (e) {
      
      // Parse the error message for better user feedback
      String errorMessage = e.toString().toLowerCase();
      
      if (errorMessage.contains('invalid email') || 
          errorMessage.contains('email')) {
        throw Exception('Please enter a valid email address');
      } else if (errorMessage.contains('user not found') || 
                 errorMessage.contains('not found')) {
        throw Exception('No account found with this email address');
      } else if (errorMessage.contains('too many requests')) {
        throw Exception('Too many requests. Please wait before trying again.');
      } else {
        throw Exception('Password reset failed: ${e.toString().replaceAll('Exception: ', '')}');
      }
    }
  }
}

// Auth state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>((ref) {
  return AuthStateNotifier();
});

// Computed provider for auth status
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider);
  return user != null;
});

// Computed provider for user profile with enhanced debugging
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(authStateProvider);
  
  if (user == null) {
    return null;
  }
  
  try {
    
    final response = await Supabase.instance.client
        .from('users')
        .select('user_id, first_name, last_name, email, user_phone_number, profile_image, created_at, updated_at')
        .eq('user_id', user.id)
        .maybeSingle();
    
    
    if (response != null) {
    } else {
    }
    
    // If no user found in users table, create a minimal profile
    if (response == null) {
      try {
        final insertData = {
          'user_id': user.id,
          'email': user.email,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        final insertResponse = await Supabase.instance.client
            .from('users')
            .insert(insertData)
            .select()
            .single();
            
        return insertResponse;
      } catch (insertError) {
        if (insertError is PostgrestException) {
        }
        
        // Return minimal data if insert fails
        final minimalData = {
          'user_id': user.id,
          'email': user.email,
        };
        return minimalData;
      }
    }
    
    return response;
  } catch (e, stackTrace) {
    
    if (e is PostgrestException) {
    }
    
    // Return minimal data on error
    final errorFallbackData = {
      'user_id': user.id,
      'email': user.email,
    };
    return errorFallbackData;
  }
});