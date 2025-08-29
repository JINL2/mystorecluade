import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_provider.dart';
import 'session_manager_provider.dart';
import 'app_state_provider.dart';
import '../pages/homepage/providers/homepage_providers.dart';

/// Enhanced authentication service that integrates with session management
class EnhancedAuthService {
  const EnhancedAuthService(this.ref);
  
  final Ref ref;

  /// Enhanced sign-in with session tracking
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Use the existing auth provider for authentication
      await ref.read(authStateProvider.notifier).signIn(
        email: email,
        password: password,
      );
      
      // Record the login event for session management
      await ref.read(sessionManagerProvider.notifier).recordLogin();
      
      
    } catch (e) {
      rethrow;
    }
  }

  /// Enhanced sign-up with session tracking
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Use the existing auth provider for signup
      await ref.read(authStateProvider.notifier).signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      // Record the signup event (treated as login for session management)
      await ref.read(sessionManagerProvider.notifier).recordLogin();
      
      
    } catch (e) {
      rethrow;
    }
  }

  /// Enhanced sign-out with COMPLETE data clearing
  Future<void> signOut() async {
    try {
      print('[EnhancedAuth] Starting signOut process...');
      
      // 1. Clear session state first
      print('[EnhancedAuth] Clearing session state...');
      await ref.read(sessionManagerProvider.notifier).clearSession();
      
      // 2. Clear ALL app state data (user, companies, features, selections)
      print('[EnhancedAuth] Clearing app state data...');
      await ref.read(appStateProvider.notifier).clearData();
      
      // 3. Invalidate all cached providers to ensure no stale data remains
      print('[EnhancedAuth] Invalidating cached providers...');
      try {
        ref.invalidate(userCompaniesProvider);
      } catch (e) {
        print('[EnhancedAuth] Error invalidating userCompaniesProvider: $e');
      }
      
      try {
        ref.invalidate(categoriesWithFeaturesProvider);
      } catch (e) {
        print('[EnhancedAuth] Error invalidating categoriesWithFeaturesProvider: $e');
      }
      
      // 4. Sign out from Supabase (this should be last to avoid UnauthorizedException)
      print('[EnhancedAuth] Signing out from Supabase...');
      await ref.read(authStateProvider.notifier).signOut();
      
      print('[EnhancedAuth] SignOut completed successfully');
      
    } catch (e) {
      print('[EnhancedAuth] Error during signOut: $e');
      // Don't rethrow - complete the logout even if there are errors
      // The router will handle the redirect
    }
  }

  /// Check if user should see onboarding vs main app
  bool shouldShowOnboarding() {
    final userData = ref.read(appStateProvider).user;
    final companies = userData['companies'] as List<dynamic>? ?? [];
    return companies.isEmpty;
  }

  /// Force refresh user data (for pull-to-refresh)
  Future<void> forceRefreshData() async {
    try {
      // Expire cache to force fresh data
      await ref.read(sessionManagerProvider.notifier).expireCache();
      
      // Invalidate providers to trigger refresh
      ref.invalidate(userCompaniesProvider);
      ref.invalidate(categoriesWithFeaturesProvider);
      
      
    } catch (e) {
      rethrow;
    }
  }

  /// Get authentication and session status for debugging
  Map<String, dynamic> getAuthStatus() {
    final user = ref.read(authStateProvider);
    final sessionManager = ref.read(sessionManagerProvider.notifier);
    final appState = ref.read(appStateProvider);
    
    return {
      'isAuthenticated': user != null,
      'userId': user?.id,
      'userEmail': user?.email,
      'hasCompanies': (appState.user['companies'] as List?)?.isNotEmpty ?? false,
      'companyCount': (appState.user['companies'] as List?)?.length ?? 0,
      'selectedCompanyId': appState.companyChoosen,
      'cacheStatus': sessionManager.getCacheStatus(),
    };
  }
}

/// Provider for enhanced authentication service
final enhancedAuthProvider = Provider<EnhancedAuthService>((ref) {
  return EnhancedAuthService(ref);
});

/// Convenience providers for common auth checks
final shouldShowOnboardingProvider = Provider<bool>((ref) {
  final authService = ref.watch(enhancedAuthProvider);
  return authService.shouldShowOnboarding();
});

final authStatusProvider = Provider<Map<String, dynamic>>((ref) {
  final authService = ref.watch(enhancedAuthProvider);
  return authService.getAuthStatus();
});

// This provider integrates with homepage providers for intelligent data fetching