import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/user_profile_service.dart';
import '../../domain/entities/user_profile.dart';
import 'auth_provider.dart';

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
  print('🚀 [currentUserProfileProvider] ===== PROVIDER TRIGGERED =====');
  print('🔍 [currentUserProfileProvider] Starting profile creation (Updated)');
  
  final user = ref.watch(authStateProvider);
  print('🔍 [currentUserProfileProvider] Auth user: ${user?.id} (${user?.email})');
  
  if (user == null) {
    print('❌ [currentUserProfileProvider] No authenticated user, returning null');
    return null;
  }
  
  print('🔍 [currentUserProfileProvider] Watching userProfileProvider...');
  
  try {
    // Add timeout and retry logic for better reliability
    final userProfileData = await ref.watch(userProfileProvider.future)
        .timeout(Duration(seconds: 10))
        .catchError((error) {
          print('⚠️ [currentUserProfileProvider] Error from userProfileProvider: $error');
          // Return minimal fallback data
          return {
            'user_id': user.id,
            'email': user.email,
          };
        });
        
    print('📊 [currentUserProfileProvider] Raw profile data: $userProfileData');
    print('📊 [currentUserProfileProvider] Profile data type: ${userProfileData.runtimeType}');
    
    if (userProfileData == null || userProfileData.isEmpty) {
      print('❌ [currentUserProfileProvider] Profile data is null or empty, creating minimal profile');
      // Return minimal profile instead of null
      return UserProfile(
        userId: user.id,
        email: user.email ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    
    // Log each field extraction
    final userId = userProfileData['user_id'] ?? user.id;
    final firstName = userProfileData['first_name'];
    final lastName = userProfileData['last_name'];
    final email = userProfileData['email'] ?? user.email ?? '';
    final phoneNumber = userProfileData['user_phone_number'];
    final profileImage = userProfileData['profile_image'];
    // Bank info will be fetched separately from users_bank_account table
    final bankName = null;  // userProfileData['bank_name'] - removed as it's not in users table
    final bankAccountNumber = null;  // userProfileData['bank_account_number'] - removed as it's not in users table
    final createdAtStr = userProfileData['created_at'];
    final updatedAtStr = userProfileData['updated_at'];
    
    print('🔍 [currentUserProfileProvider] Extracted fields:');
    print('   - userId: "$userId"');
    print('   - firstName: "$firstName" (type: ${firstName.runtimeType})');
    print('   - lastName: "$lastName" (type: ${lastName.runtimeType})');
    print('   - email: "$email"');
    print('   - phoneNumber: "$phoneNumber" (type: ${phoneNumber.runtimeType})');
    print('   - profileImage: "$profileImage" (type: ${profileImage.runtimeType})');
    print('   - bankName: "$bankName" (type: ${bankName.runtimeType})');
    print('   - bankAccountNumber: "$bankAccountNumber" (type: ${bankAccountNumber.runtimeType})');
    print('   - createdAt: "$createdAtStr"');
    print('   - updatedAt: "$updatedAtStr"');
    
    // Parse dates with error handling
    DateTime? createdAt;
    DateTime? updatedAt;
    
    try {
      createdAt = createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
      print('✅ [currentUserProfileProvider] Parsed createdAt: $createdAt');
    } catch (e) {
      print('⚠️ [currentUserProfileProvider] Error parsing createdAt "$createdAtStr": $e');
      createdAt = DateTime.now();
    }
    
    try {
      updatedAt = updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();
      print('✅ [currentUserProfileProvider] Parsed updatedAt: $updatedAt');
    } catch (e) {
      print('⚠️ [currentUserProfileProvider] Error parsing updatedAt "$updatedAtStr": $e');
      updatedAt = DateTime.now();
    }
    
    // Create UserProfile instance - using manual constructor since Supabase data has db column names
    print('🔧 [currentUserProfileProvider] Creating UserProfile instance...');
    print('🔧 [currentUserProfileProvider] Constructor parameters:');
    print('   - userId: "$userId"');
    print('   - firstName: "$firstName"'); 
    print('   - lastName: "$lastName"');
    print('   - email: "$email"');
    print('   - phoneNumber: "$phoneNumber"');
    print('   - profileImage: "$profileImage"');
    print('   - bankName: "$bankName"');
    print('   - bankAccountNumber: "$bankAccountNumber"');
    print('   - createdAt: $createdAt');
    print('   - updatedAt: $updatedAt');
    
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
    
    print('✅ [currentUserProfileProvider] Created UserProfile successfully');
    print('   - profile.firstName: "${profile.firstName}"');
    print('   - profile.lastName: "${profile.lastName}"');
    print('   - profile.email: "${profile.email}"');
    print('   - profile.phoneNumber: "${profile.phoneNumber}"');
    print('   - profile.profileImage: "${profile.profileImage}"');
    print('   - profile.bankName: "${profile.bankName}"');
    print('   - profile.bankAccountNumber: "${profile.bankAccountNumber}"');
    print('   - profile.fullName: "${profile.fullName}"');
    print('   - profile.initials: "${profile.initials}"');
    print('   - profile.hasProfileImage: ${profile.hasProfileImage}');
    
    return profile;
  } catch (e, stackTrace) {
    print('❌ [currentUserProfileProvider] Error creating profile: $e');
    print('❌ [currentUserProfileProvider] Error type: ${e.runtimeType}');
    print('❌ [currentUserProfileProvider] Stack trace: $stackTrace');
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
    
    final companyName = response['companies']['name'] ?? '';
    final stores = response['companies']['stores'] as List;
    final storeName = stores.isNotEmpty ? stores[0]['name'] ?? '' : '';
    final userRole = response['role'] ?? 'Employee';
    
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