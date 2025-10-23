import '../../domain/entities/user_profile.dart';

class UserProfileModel {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phoneNumber;
  final String? profileImage;
  final String? bankName;
  final String? bankAccountNumber;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? companyName;
  final String? storeName;
  final String? roleName;
  final String subscriptionPlan;
  final String subscriptionStatus;
  final DateTime? subscriptionExpiresAt;

  const UserProfileModel({
    required this.userId,
    this.firstName,
    this.lastName,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    this.bankName,
    this.bankAccountNumber,
    this.isDeleted = false,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.companyName,
    this.storeName,
    this.roleName,
    this.subscriptionPlan = 'Free',
    this.subscriptionStatus = 'active',
    this.subscriptionExpiresAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['user_id']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      email: json['email']?.toString() ?? '',
      phoneNumber: json['user_phone_number']?.toString(),
      profileImage: json['profile_image']?.toString(),
      bankName: json['bank_name']?.toString(),
      bankAccountNumber: json['bank_account_number']?.toString(),
      isDeleted: json['is_deleted'] as bool? ?? false,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : null,
      companyName: json['company_name']?.toString(),
      storeName: json['store_name']?.toString(),
      roleName: json['role_name']?.toString(),
      subscriptionPlan: json['subscription_plan']?.toString() ?? 'Free',
      subscriptionStatus: json['subscription_status']?.toString() ?? 'active',
      subscriptionExpiresAt: json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'user_phone_number': phoneNumber,
      'profile_image': profileImage,
      'bank_name': bankName,
      'bank_account_number': bankAccountNumber,
      'is_deleted': isDeleted,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'company_name': companyName,
      'store_name': storeName,
      'role_name': roleName,
      'subscription_plan': subscriptionPlan,
      'subscription_status': subscriptionStatus,
      'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
      bankName: bankName,
      bankAccountNumber: bankAccountNumber,
      isDeleted: isDeleted,
      deletedAt: deletedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      companyName: companyName,
      storeName: storeName,
      roleName: roleName,
      subscriptionPlan: subscriptionPlan,
      subscriptionStatus: subscriptionStatus,
      subscriptionExpiresAt: subscriptionExpiresAt,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profileImage: entity.profileImage,
      bankName: entity.bankName,
      bankAccountNumber: entity.bankAccountNumber,
      isDeleted: entity.isDeleted,
      deletedAt: entity.deletedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      companyName: entity.companyName,
      storeName: entity.storeName,
      roleName: entity.roleName,
      subscriptionPlan: entity.subscriptionPlan,
      subscriptionStatus: entity.subscriptionStatus,
      subscriptionExpiresAt: entity.subscriptionExpiresAt,
    );
  }
}
