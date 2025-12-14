import '../entities/business_dashboard.dart';
import '../entities/user_profile.dart';

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
    String? dateOfBirth,
    String? profileImage,
  });

  /// Upload profile image to storage
  Future<String> uploadProfileImage(String userId, String filePath);

  /// Remove profile image
  Future<void> removeProfileImage(String userId);

  /// Get user's bank account info
  Future<Map<String, dynamic>?> getUserBankAccount({
    required String userId,
    required String companyId,
  });

  /// Save user's bank account
  Future<bool> saveUserBankAccount({
    required String userId,
    required String companyId,
    required String bankName,
    required String accountNumber,
    required String description,
  });

  /// Get available languages
  Future<List<Map<String, dynamic>>> getLanguages();

  /// Get user's current language ID
  Future<String?> getUserLanguageId(String userId);

  /// Get language code by ID
  Future<String?> getLanguageCode(String languageId);

  /// Update user's language preference
  Future<bool> updateUserLanguage({
    required String userId,
    required String languageId,
  });
}
