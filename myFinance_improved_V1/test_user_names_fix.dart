// Test script to verify user names fix
// Run this in Dart to test the user profile service

import 'lib/data/services/user_profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Initialize Supabase (you'll need your project URL and anon key)
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  final userProfileService = UserProfileService();
  
  // Test 1: Get current user profile
  print('Testing user profile retrieval...');
  
  final currentUser = Supabase.instance.client.auth.currentUser;
  if (currentUser != null) {
    final profile = await userProfileService.getUserProfile(currentUser.id);
    print('Current user profile: $profile');
    
    // Test 2: Fix user profile if needed
    if (profile != null && (profile['first_name'] == null || profile['last_name'] == null)) {
      print('Fixing user profile...');
      
      final metadata = currentUser.userMetadata;
      final firstName = metadata?['first_name'] ?? 'John';
      final lastName = metadata?['last_name'] ?? 'Doe';
      
      final fixed = await userProfileService.fixUserProfile(
        currentUser.id, 
        firstName, 
        lastName
      );
      
      print('Profile fix result: $fixed');
      
      // Verify fix
      final updatedProfile = await userProfileService.getUserProfile(currentUser.id);
      print('Updated profile: $updatedProfile');
    }
  } else {
    print('No user logged in');
  }
  
  // Test 3: Fix all users with null names
  print('Fixing all users with null names...');
  final fixedCount = await userProfileService.fixAllUsersWithNullNames();
  print('Fixed $fixedCount users');
}