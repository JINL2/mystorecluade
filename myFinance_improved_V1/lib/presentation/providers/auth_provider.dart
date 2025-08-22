import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/user_profile_service.dart';
import 'session_manager_provider.dart';
import 'app_state_provider.dart';

// Auth state notifier
class AuthStateNotifier extends StateNotifier<User?> {
  final _userProfileService = UserProfileService();
  
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
      
      // After successful login, check if user profile needs fixing
      if (response.user != null) {
        _fixUserProfileIfNeeded(response.user!);
      }
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
      
      // Ensure user profile is created/updated in our custom users table
      // This handles both new users and existing users with null names
      try {
        await _userProfileService.ensureUserProfile(
          userId: response.user!.id,
          firstName: firstName,
          lastName: lastName,
          email: email,
        );
      } catch (profileError) {
        // If profile creation fails, log error but continue
        print('Warning: Failed to ensure user profile: $profileError');
      }
      
      
      // Don't set state - user needs to verify email if confirmation is enabled
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
  
  /// Fix user profile by extracting names from auth metadata
  Future<void> _fixUserProfileIfNeeded(User user) async {
    try {
      // Get user metadata
      final metadata = user.userMetadata;
      if (metadata == null) return;
      
      // Extract names from metadata
      final firstName = metadata['first_name'] as String? ?? 
                       metadata['full_name']?.toString().split(' ').first ?? 'User';
      
      final fullName = metadata['full_name']?.toString() ?? '';
      final nameParts = fullName.split(' ');
      final lastName = metadata['last_name'] as String? ??
                      (nameParts.length > 1 
                        ? nameParts.skip(1).join(' ')
                        : 'Name');
      
      // Fix the user profile
      await _userProfileService.fixUserProfile(user.id, firstName, lastName);
    } catch (e) {
      print('Error fixing user profile on login: $e');
    }
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

// Computed provider for user profile
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(authStateProvider);
  if (user == null) return null;
  
  try {
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    
    return response;
  } catch (e) {
    return null;
  }
});