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
          if (phoneNumber != null) 'phone_number': phoneNumber,
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

// Provider for current user profile
final currentUserProfileProvider = FutureProvider.autoDispose<UserProfile?>((ref) async {
  final user = ref.watch(authStateProvider);
  if (user == null) return null;
  
  final userProfileData = await ref.watch(userProfileProvider.future);
  if (userProfileData == null) return null;
  
  // Convert the Map to UserProfile
  return UserProfile(
    userId: userProfileData['user_id'] ?? user.id,
    firstName: userProfileData['first_name'],
    lastName: userProfileData['last_name'],
    email: userProfileData['email'] ?? user.email ?? '',
    phoneNumber: userProfileData['phone_number'],
    profileImage: userProfileData['profile_image'],
    bankName: userProfileData['bank_name'],
    bankAccountNumber: userProfileData['bank_account_number'],
    createdAt: userProfileData['created_at'] != null 
        ? DateTime.parse(userProfileData['created_at']) 
        : DateTime.now(),
    updatedAt: userProfileData['updated_at'] != null 
        ? DateTime.parse(userProfileData['updated_at']) 
        : DateTime.now(),
  );
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
final businessDashboardDataProvider = FutureProvider.autoDispose<BusinessDashboardData?>((ref) async {
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