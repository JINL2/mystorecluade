import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  /// Get user profile via RPC (includes bank accounts, language, available languages)
  Future<UserProfile?> getUserProfile(String userId);

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

  /// Save user's bank account
  Future<bool> saveUserBankAccount({
    required String userId,
    required String companyId,
    required String bankName,
    required String accountNumber,
    required String description,
  });

  /// Update user's language preference
  Future<bool> updateUserLanguage({
    required String userId,
    required String languageId,
  });
}
