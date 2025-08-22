import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_state_provider.dart';

/// Simple onboarding provider that doesn't depend on database schema
/// This works immediately without requiring database changes
class SimpleOnboardingNotifier extends StateNotifier<bool> {
  SimpleOnboardingNotifier() : super(false);
  
  DateTime? _onboardingCompletedAt;
  
  /// Mark that user has just completed signup and needs onboarding
  void markNeedsOnboarding() {
    debugPrint('[SimpleOnboardingNotifier] Marking user as needing onboarding');
    state = true;
    _onboardingCompletedAt = null;
  }
  
  /// Mark that user has completed onboarding
  void markOnboardingComplete() {
    debugPrint('[SimpleOnboardingNotifier] Marking onboarding as complete');
    state = false;
    _onboardingCompletedAt = DateTime.now();
  }
  
  /// Check if onboarding was recently completed (within last 5 seconds)
  bool wasRecentlyCompleted() {
    if (_onboardingCompletedAt == null) return false;
    final difference = DateTime.now().difference(_onboardingCompletedAt!);
    return difference.inSeconds < 5;
  }
  
  /// Reset onboarding state
  void reset() {
    debugPrint('[SimpleOnboardingNotifier] Resetting onboarding state');
    state = false;
    _onboardingCompletedAt = null;
  }
}

/// Provider for simple onboarding state
final simpleOnboardingProvider = StateNotifierProvider<SimpleOnboardingNotifier, bool>((ref) {
  return SimpleOnboardingNotifier();
});

/// Provider to check if onboarding was recently completed
final onboardingRecentlyCompletedProvider = Provider<bool>((ref) {
  final notifier = ref.watch(simpleOnboardingProvider.notifier);
  return notifier.wasRecentlyCompleted();
});

/// Check if current user has companies (async check)
final userHasCompaniesProvider = FutureProvider<bool>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  
  if (user == null) return false;
  
  try {
    // Check if user has any companies
    final response = await supabase
        .from('user_companies')
        .select('company_id')
        .eq('user_id', user.id)
        .limit(1);
    
    final hasCompanies = response != null && (response as List).isNotEmpty;
    debugPrint('[userHasCompaniesProvider] User has companies: $hasCompanies');
    return hasCompanies;
  } catch (e) {
    debugPrint('[userHasCompaniesProvider] Error checking companies: $e');
    return false;
  }
});

/// Check if current user is newly created and needs onboarding
final isNewUserProvider = Provider<bool>((ref) {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  
  if (user == null) return false;
  
  // First check the simple onboarding state - this is the primary indicator
  final needsOnboarding = ref.watch(simpleOnboardingProvider);
  if (needsOnboarding) {
    debugPrint('[isNewUserProvider] User needs onboarding (state flag set)');
    return true;
  }
  
  // If onboarding is marked complete, user is not new anymore
  // This prevents the redirect loop after business creation
  return false;
});