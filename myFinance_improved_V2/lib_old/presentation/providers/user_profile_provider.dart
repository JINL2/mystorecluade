import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/user_profile_service.dart';
import '../../domain/entities/user_profile.dart';
import 'auth_provider.dart';
import 'app_state_provider.dart';

// Provider for UserProfileService
final userProfileServiceProvider = StateNotifierProvider<UserProfileServiceNotifier, AsyncValue<void>>((ref) {
  return UserProfileServiceNotifier();
});

// StateNotifier for UserProfileService operations
class UserProfileServiceNotifier extends StateNotifier<AsyncValue<void>> {
  final _service = UserProfileService();
  
  UserProfileServiceNotifier() : super(const AsyncValue.data(null));
  
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bankName,
    String? bankAccountNumber,
    String? profileImage,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      await _service.updateUserProfile(
        userId: userId,
        updates: {
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (phoneNumber != null) 'user_phone_number': phoneNumber,
          if (bankName != null) 'bank_name': bankName,
          if (bankAccountNumber != null) 'bank_account_number': bankAccountNumber,
          if (profileImage != null) 'profile_image': profileImage,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Provider for current user profile with enhanced debugging
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(authStateProvider);
  
  if (user == null) {
    return null;
  }
  
  try {
    // IMPORTANT: Check app state FIRST for user data (it has the latest local updates)
    final appState = ref.watch(appStateProvider);
    
    // Try to get user data from app state first
    dynamic userProfileData;
    
    // Check if app state has user data
    if (appState.user != null && appState.user is Map && (appState.user as Map).isNotEmpty) {
      final appUserData = appState.user as Map;
      userProfileData = {
        'user_id': appUserData['user_id'] ?? user.id,
        'first_name': appUserData['user_first_name'],  // Note: app state uses user_first_name
        'last_name': appUserData['user_last_name'],    // Note: app state uses user_last_name
        'email': appUserData['user_email'] ?? user.email,
        'user_phone_number': appUserData['user_phone_number'],
        'profile_image': appUserData['profile_image'],
        'created_at': appUserData['created_at'],
        'updated_at': appUserData['updated_at'],
      };
    } else {
      // Fallback to database fetch
      userProfileData = await ref.watch(userProfileProvider.future)
          .timeout(Duration(seconds: 10))
          .catchError((error) {
            // Return minimal fallback data
            return {
              'user_id': user.id,
              'email': user.email,
            };
          });
    }
          
    if (userProfileData == null || (userProfileData is Map && userProfileData.isEmpty)) {
      // Return minimal profile instead of null
      return UserProfile(
        userId: user.id,
        email: user.email ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    
    // Log each field extraction
    final userId = userProfileData['user_id']?.toString() ?? user.id;
    final firstName = userProfileData['first_name']?.toString();
    final lastName = userProfileData['last_name']?.toString();
    final email = userProfileData['email']?.toString() ?? user.email ?? '';
    final phoneNumber = userProfileData['user_phone_number']?.toString();
    final profileImage = userProfileData['profile_image']?.toString();
    // Bank info will be fetched separately from users_bank_account table
    final String? bankName = null;  // userProfileData['bank_name'] - removed as it's not in users table
    final String? bankAccountNumber = null;  // userProfileData['bank_account_number'] - removed as it's not in users table
    final createdAtStr = userProfileData['created_at']?.toString();
    final updatedAtStr = userProfileData['updated_at']?.toString();
    
    // Extract fields from user profile data
    
    // Parse dates with error handling
    DateTime? createdAt;
    DateTime? updatedAt;
    
    try {
      createdAt = createdAtStr != null && createdAtStr.isNotEmpty 
          ? DateTime.parse(createdAtStr) 
          : DateTime.now();
    } catch (e) {
      createdAt = DateTime.now();
    }
    
    try {
      updatedAt = updatedAtStr != null && updatedAtStr.isNotEmpty 
          ? DateTime.parse(updatedAtStr) 
          : DateTime.now();
    } catch (e) {
      updatedAt = DateTime.now();
    }
    
    // Create UserProfile instance
    
    final profile = UserProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
      bankName: bankName,
      bankAccountNumber: bankAccountNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
    
    return profile;
  } catch (e, stackTrace) {
    return null;
  }
});

// Business Dashboard Data class
class BusinessDashboardData {
  final String companyName;
  final String storeName;
  final String userRole;
  final int totalEmployees;
  final double monthlyRevenue;
  final int activeShifts;

  BusinessDashboardData({
    required this.companyName,
    required this.storeName,
    required this.userRole,
    required this.totalEmployees,
    required this.monthlyRevenue,
    required this.activeShifts,
  });
}

// Provider for business dashboard data
final businessDashboardDataProvider = FutureProvider<BusinessDashboardData?>((ref) async {
  final user = ref.watch(authStateProvider);
  if (user == null) return null;
  
  try {
    final supabase = Supabase.instance.client;
    
    // Get user's company and store information
    final response = await supabase
        .from('user_companies')
        .select('''
          role,
          companies!inner(
            name,
            stores!inner(
              name
            )
          )
        ''')
        .eq('user_id', user.id)
        .single();
    
    final companyName = (response['companies']['name'] ?? '').toString();
    final stores = response['companies']['stores'] as List;
    final storeName = stores.isNotEmpty ? (stores[0]['name'] ?? '').toString() : '';
    final userRole = (response['role'] ?? 'Employee').toString();
    
    // For now, return mock data for other fields
    // In a real implementation, you would fetch actual data
    return BusinessDashboardData(
      companyName: companyName,
      storeName: storeName,
      userRole: userRole,
      totalEmployees: 0,
      monthlyRevenue: 0.0,
      activeShifts: 0,
    );
  } catch (e) {
    // Return default data on error
    return BusinessDashboardData(
      companyName: '',
      storeName: '',
      userRole: 'Employee',
      totalEmployees: 0,
      monthlyRevenue: 0.0,
      activeShifts: 0,
    );
  }
});