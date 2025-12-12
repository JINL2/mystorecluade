import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

class UserProfileService {
  final _supabase = Supabase.instance.client;
  
  void _log(String message) {
    developer.log(message, name: 'UserProfileService');
  }
  
  void _logError(String message, dynamic error, [StackTrace? stackTrace]) {
    developer.log(message, name: 'UserProfileService', error: error, stackTrace: stackTrace);
  }
  
  /// Update user profile with provided fields
  Future<bool> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      _log('Updating user profile for userId: $userId');
      _log('Update data: $updates');
      
      final result = await _supabase
          .from('users')
          .update(updates)
          .eq('user_id', userId)
          .select();
          
      _log('Update result: $result');
      _log('SUCCESS: Updated user profile');
      return true;
    } catch (e) {
      _logError('Error updating user profile', e);
      return false;
    }
  }

  /// Fix user profile by populating first_name and last_name with comprehensive debugging
  Future<bool> fixUserProfile(String userId, String firstName, String lastName) async {
    _log('Starting fixUserProfile for userId: $userId, firstName: $firstName, lastName: $lastName');
    
    try {
      // Check current user authentication status
      final currentUser = _supabase.auth.currentUser;
      _log('Current auth user: ${currentUser?.id} (${currentUser?.email})');
      
      // Verify connection to Supabase
      _log('Supabase client status: ${_supabase.auth.currentSession != null ? "authenticated" : "not authenticated"}');
      
      // First check if user exists in our users table
      _log('Checking if user exists in users table...');
      final existingUser = await _supabase
          .from('users')
          .select('user_id, first_name, last_name, email, created_at')
          .eq('user_id', userId)
          .maybeSingle();

      _log('Existing user query result: $existingUser');

      if (existingUser == null) {
        // User doesn't exist in users table, create it
        _log('User does not exist, creating new profile...');
        
        final insertData = {
          'user_id': userId,
          'first_name': firstName,
          'last_name': lastName,
          'email': currentUser?.email ?? '',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        _log('Insert data: $insertData');
        
        final insertResult = await _supabase.from('users').insert(insertData).select();
        _log('Insert operation result: $insertResult');
        
        _log('SUCCESS: Created user profile for: $userId');
        return true;
        
      } else if (existingUser['first_name'] == null || 
                 existingUser['last_name'] == null ||
                 existingUser['first_name'] == '' ||
                 existingUser['last_name'] == '') {
        // User exists but has null/empty names, update them
        _log('User exists but names are null/empty, updating...');
        _log('Current names: first_name="${existingUser['first_name']}", last_name="${existingUser['last_name']}"');
        
        final updateData = {
          'first_name': firstName,
          'last_name': lastName,
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        _log('Update data: $updateData');
        
        final updateResult = await _supabase
            .from('users')
            .update(updateData)
            .eq('user_id', userId)
            .select();
            
        _log('Update operation result: $updateResult');
        _log('SUCCESS: Updated user profile for: $userId');
        return true;
        
      } else {
        _log('User profile already has names: first_name="${existingUser['first_name']}", last_name="${existingUser['last_name']}"');
        return false;
      }
    } catch (e, stackTrace) {
      _logError('FAILED to fix user profile', e, stackTrace);
      
      // Try to get more specific error information
      if (e is PostgrestException) {
        _logError('PostgrestException details', {
          'code': e.code,
          'message': e.message,
          'details': e.details,
          'hint': e.hint,
        });
      }
      
      return false;
    }
  }

  /// Get user profile with names
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final profile = await _supabase
          .from('users')
          .select('user_id, first_name, last_name, email, created_at, updated_at')
          .eq('user_id', userId)
          .maybeSingle();
      
      return profile;
    } catch (e) {
      return null;
    }
  }

  /// Create user profile if it doesn't exist with comprehensive debugging
  Future<bool> ensureUserProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    _log('Starting ensureUserProfile for userId: $userId, firstName: $firstName, lastName: $lastName, email: $email');
    
    try {
      _log('Getting existing profile...');
      final existingProfile = await getUserProfile(userId);
      _log('Existing profile result: $existingProfile');
      
      if (existingProfile == null) {
        // Create new profile
        _log('No existing profile found, creating new one...');
        
        final insertData = {
          'user_id': userId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        _log('Insert data for new profile: $insertData');
        
        final result = await _supabase.from('users').insert(insertData).select();
        _log('Insert result: $result');
        
        _log('SUCCESS: Created new user profile');
        return true;
        
      } else if (existingProfile['first_name'] == null || 
                 existingProfile['last_name'] == null ||
                 existingProfile['first_name'] == '' ||
                 existingProfile['last_name'] == '') {
        // Update existing profile with missing names
        _log('Existing profile has null/empty names, updating...');
        _log('Current profile: first_name="${existingProfile['first_name']}", last_name="${existingProfile['last_name']}"');
        
        final updateData = {
          'first_name': firstName,
          'last_name': lastName,
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        _log('Update data: $updateData');
        
        final result = await _supabase
            .from('users')
            .update(updateData)
            .eq('user_id', userId)
            .select();
            
        _log('Update result: $result');
        _log('SUCCESS: Updated existing profile with names');
        return true;
      }
      
      _log('Profile already exists with names, no action needed');
      return false; // Profile already exists with names
    } catch (e, stackTrace) {
      _logError('FAILED to ensure user profile', e, stackTrace);
      
      // Additional error details for PostgrestException
      if (e is PostgrestException) {
        _logError('PostgrestException details', {
          'code': e.code,
          'message': e.message,
          'details': e.details,
          'hint': e.hint,
        });
      }
      
      return false;
    }
  }

  /// Fix all users that have null names by extracting from auth metadata
  Future<int> fixAllUsersWithNullNames() async {
    try {
      int fixedCount = 0;
      
      // Get all users with null names
      final usersWithNullNames = await _supabase
          .from('users')
          .select('user_id, first_name, last_name, email')
          .or('first_name.is.null,last_name.is.null');
      
      for (final userRecord in usersWithNullNames) {
        final userId = userRecord['user_id'] as String;
        
        // Get auth user metadata
        final authUser = await _supabase.auth.admin.getUserById(userId);
        final metadata = authUser.user?.userMetadata;
        
        if (metadata != null) {
          final firstName = metadata['first_name'] as String? ?? 'User';
          final lastName = metadata['last_name'] as String? ?? 'Name';
          
          final wasFixed = await fixUserProfile(userId, firstName, lastName);
          if (wasFixed) fixedCount++;
        }
      }
      
      return fixedCount;
    } catch (e) {
      return 0;
    }
  }
}