// Test script to verify user names fix
// Run this in Dart to test the user profile service

import '../lib/data/services/user_profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Initialize Supabase (you'll need your project URL and anon key)
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  final userProfileService = UserProfileService();
  
  // Test 1: Get current user profile
  final currentUser = Supabase.instance.client.auth.currentUser;
  if (currentUser != null) {
    final profile = await userProfileService.getUserProfile(currentUser.id);
    
    // Test 2: Fix user profile if needed
    if (profile != null && (profile['first_name'] == null || profile['last_name'] == null)) {
      final metadata = currentUser.userMetadata;
      final firstName = metadata?['first_name'] ?? 'John';
      final lastName = metadata?['last_name'] ?? 'Doe';
      
      final fixed = await userProfileService.fixUserProfile(
        currentUser.id, 
        firstName, 
        lastName
      );
      
      // Verify fix
      final updatedProfile = await userProfileService.getUserProfile(currentUser.id);
    }
  }
  
  // Test 3: Fix all users with null names
  final fixedCount = await userProfileService.fixAllUsersWithNullNames();
}