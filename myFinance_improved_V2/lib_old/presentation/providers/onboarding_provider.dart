import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider to track if user needs onboarding
final needsOnboardingProvider = FutureProvider<bool>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  
  if (user == null) {
    return false; // Not authenticated, no onboarding needed
  }
  
  try {
    // Check if user has completed company setup
    final userProfile = await supabase
        .from('users')
        .select('company_id')
        .eq('user_id', user.id)
        .maybeSingle();
    
    if (userProfile == null) {
      return true; // No profile exists, needs onboarding
    }
    
    // If user has no company_id, they need to create or join a company
    return userProfile['company_id'] == null;
    
  } catch (e) {
    // If there's an error, assume they need onboarding to be safe
    return true;
  }
});

// Provider to check if user has completed onboarding
final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  final needsOnboardingAsync = ref.watch(needsOnboardingProvider);
  
  return needsOnboardingAsync.when(
    data: (needsOnboarding) => !needsOnboarding,
    loading: () => false, // During loading, assume not completed
    error: (_, __) => false, // On error, assume not completed
  );
});

// Notifier for onboarding state changes
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false);
  
  void completeOnboarding() {
    state = true;
  }
  
  void resetOnboarding() {
    state = false;
  }
}

final onboardingNotifierProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});