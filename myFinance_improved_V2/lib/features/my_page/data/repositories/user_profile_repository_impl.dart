import '../../domain/entities/business_dashboard.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/profile_image_datasource.dart';
import '../datasources/user_profile_datasource.dart';
import '../models/business_dashboard_model.dart';
import '../models/user_profile_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource _userProfileDataSource;
  final ProfileImageDataSource _profileImageDataSource;

  UserProfileRepositoryImpl({
    UserProfileDataSource? userProfileDataSource,
    ProfileImageDataSource? profileImageDataSource,
  })  : _userProfileDataSource = userProfileDataSource ?? UserProfileDataSource(),
        _profileImageDataSource = profileImageDataSource ?? ProfileImageDataSource();

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final data = await _userProfileDataSource.getUserProfile(userId);
      if (data == null) return null;

      final model = UserProfileModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<BusinessDashboard?> getBusinessDashboard(String userId) async {
    try {
      final data = await _userProfileDataSource.getBusinessDashboard(userId);
      if (data == null) return null;

      final model = BusinessDashboardModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      // Return default on error
      return const BusinessDashboard(
        companyName: '',
        storeName: '',
        userRole: 'Employee',
        totalEmployees: 0,
        monthlyRevenue: 0.0,
        activeShifts: 0,
      );
    }
  }

  @override
  Future<bool> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bankName,
    String? bankAccountNumber,
    String? profileImage,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (phoneNumber != null) updates['user_phone_number'] = phoneNumber;
      if (bankName != null) updates['bank_name'] = bankName;
      if (bankAccountNumber != null) updates['bank_account_number'] = bankAccountNumber;
      if (profileImage != null) updates['profile_image'] = profileImage;

      updates['updated_at'] = DateTime.now().toIso8601String();

      return await _userProfileDataSource.updateUserProfile(
        userId: userId,
        updates: updates,
      );
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(String userId, String filePath) async {
    try {
      final publicUrl = await _profileImageDataSource.uploadProfileImage(userId, filePath);

      // Update user profile with new image URL
      await updateUserProfile(userId: userId, profileImage: publicUrl);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  @override
  Future<void> removeProfileImage(String userId) async {
    try {
      await _profileImageDataSource.removeProfileImage(userId);

      // Update user profile to remove image URL
      await updateUserProfile(userId: userId, profileImage: '');
    } catch (e) {
      throw Exception('Failed to remove profile image: $e');
    }
  }
}
