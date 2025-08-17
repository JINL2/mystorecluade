import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    required String email,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    
    // Additional fields from relationships
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'role_name') String? roleName,
    
    // Subscription info (can be extended later)
    @JsonKey(name: 'subscription_plan') @Default('Free') String subscriptionPlan,
    @JsonKey(name: 'subscription_status') @Default('active') String subscriptionStatus,
    @JsonKey(name: 'subscription_expires_at') DateTime? subscriptionExpiresAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
      
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