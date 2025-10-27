import '../entities/user_profile.dart';
import '../entities/business_dashboard.dart';

abstract class UserProfileRepository {
  /// Get user profile by user ID
  Future<UserProfile?> getUserProfile(String userId);

  /// Get business dashboard data for user
  Future<BusinessDashboard?> getBusinessDashboard(String userId);

  /// Update user profile
  Future<bool> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bankName,
    String? bankAccountNumber,
    String? profileImage,
  });

  /// Upload profile image to storage
  Future<String> uploadProfileImage(String userId, String filePath);

  /// Remove profile image
  Future<void> removeProfileImage(String userId);
}
