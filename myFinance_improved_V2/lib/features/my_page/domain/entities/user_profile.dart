import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// Pure domain entity for user profile
/// JSON serialization is handled by UserProfileModel in data layer
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    required String email,
    String? phoneNumber,
    String? dateOfBirth,
    String? profileImage,
    String? bankName,
    String? bankAccountNumber,
    @Default(false) bool isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,

    // Additional fields from relationships
    String? companyName,
    String? storeName,
    String? roleName,

    // Subscription info
    @Default('Free') String subscriptionPlan,
    @Default('active') String subscriptionStatus,
    DateTime? subscriptionExpiresAt,
  }) = _UserProfile;

  const UserProfile._();

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    return '$first $last'.trim().isEmpty ? email : '$first $last'.trim();
  }

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    } else if (firstName != null) {
      return firstName![0].toUpperCase();
    } else {
      return email[0].toUpperCase();
    }
  }

  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;

  bool get isSubscriptionActive => subscriptionStatus == 'active';

  String get displayRole => roleName ?? 'User';

  String get displayCompany => companyName ?? 'No Company';

  String get displayStore => storeName ?? 'No Store Assigned';
}
