import 'package:myfinance_improved/core/utils/datetime_utils.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/profile_image_datasource.dart';
import '../datasources/user_profile_datasource.dart';
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
  Future<bool> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? dateOfBirth,
    String? profileImage,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (phoneNumber != null) updates['user_phone_number'] = phoneNumber;
      if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth;
      if (profileImage != null) updates['profile_image'] = profileImage;

      updates['updated_at'] = DateTimeUtils.nowUtc();

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

  @override
  Future<Map<String, dynamic>?> getUserBankAccount({
    required String userId,
    required String companyId,
  }) async {
    return await _userProfileDataSource.getUserBankAccount(
      userId: userId,
      companyId: companyId,
    );
  }

  @override
  Future<bool> saveUserBankAccount({
    required String userId,
    required String companyId,
    required String bankName,
    required String accountNumber,
    required String description,
  }) async {
    return await _userProfileDataSource.saveUserBankAccount(
      userId: userId,
      companyId: companyId,
      bankName: bankName,
      accountNumber: accountNumber,
      description: description,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getLanguages() async {
    return await _userProfileDataSource.getLanguages();
  }

  @override
  Future<String?> getUserLanguageId(String userId) async {
    return await _userProfileDataSource.getUserLanguageId(userId);
  }

  @override
  Future<String?> getLanguageCode(String languageId) async {
    return await _userProfileDataSource.getLanguageCode(languageId);
  }

  @override
  Future<bool> updateUserLanguage({
    required String userId,
    required String languageId,
  }) async {
    return await _userProfileDataSource.updateUserLanguage(
      userId: userId,
      languageId: languageId,
    );
  }
}
