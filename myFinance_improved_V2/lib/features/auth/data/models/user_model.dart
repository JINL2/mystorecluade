// lib/features/auth/data/models/user_model.dart

import '../../domain/entities/user_entity.dart';
import '../../../../core/utils/datetime_utils.dart';

/// User Model
///
/// 📦 택배 상자 - JSON 직렬화 가능한 데이터 모델
///
/// 책임:
/// - JSON ↔ Dart 객체 변환
/// - Database 컬럼명 매핑 (user_id, first_name, last_name, etc.)
/// - Entity 변환
///
/// 이 모델은 Supabase users 테이블 JSON 구조에 대한 지식을 가지고 있습니다.
class UserModel {
  final String userId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? userPhoneNumber;
  final String? profileImage;
  final String? preferredTimezone;
  final String createdAt;
  final String? updatedAt;
  final bool isDeleted;
  final bool isEmailVerified;
  final String? lastLoginAt;

  const UserModel({
    required this.userId,
    required this.email,
    this.firstName,
    this.lastName,
    this.userPhoneNumber,
    this.profileImage,
    this.preferredTimezone,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.isEmailVerified = false,
    this.lastLoginAt,
  });

  /// Create from Supabase JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      userPhoneNumber: json['user_phone_number'] as String?,
      profileImage: json['profile_image'] as String?,
      preferredTimezone: json['preferred_timezone'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      lastLoginAt: json['last_login_at'] as String?,
    );
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'user_phone_number': userPhoneNumber,
      'profile_image': profileImage,
      'preferred_timezone': preferredTimezone,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_deleted': isDeleted,
      'is_email_verified': isEmailVerified,
      'last_login_at': lastLoginAt,
    };
  }

  /// Convert to Domain Entity
  User toEntity() {
    return User(
      id: userId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      createdAt: DateTimeUtils.toLocal(createdAt),
      lastLoginAt: lastLoginAt != null ? DateTimeUtils.toLocal(lastLoginAt!) : null,
      isEmailVerified: isEmailVerified,
    );
  }

  /// Create from Domain Entity
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      userId: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      createdAt: DateTimeUtils.toUtc(entity.createdAt),
      lastLoginAt: entity.lastLoginAt != null ? DateTimeUtils.toUtc(entity.lastLoginAt!) : null,
      isEmailVerified: entity.isEmailVerified,
    );
  }

  /// Create insert map for Supabase (user profile creation)
  ///
  /// Used when creating a new user profile in the users table.
  /// The user_id should match the auth.users.id from Supabase Auth.
  Map<String, dynamic> toInsertMap() {
    final map = <String, dynamic>{
      'user_id': userId,
      'email': email,
      'created_at': createdAt,
      'updated_at': DateTimeUtils.nowUtc(),
    };

    if (firstName != null) map['first_name'] = firstName;
    if (lastName != null) map['last_name'] = lastName;
    if (userPhoneNumber != null) map['user_phone_number'] = userPhoneNumber;
    if (profileImage != null) map['profile_image'] = profileImage;
    if (preferredTimezone != null) map['preferred_timezone'] = preferredTimezone;

    return map;
  }

  /// Create update map for Supabase
  ///
  /// Only includes fields that can be updated.
  /// Does not include user_id, email, or created_at.
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{
      'updated_at': DateTimeUtils.nowUtc(),
    };

    if (firstName != null) map['first_name'] = firstName;
    if (lastName != null) map['last_name'] = lastName;
    if (userPhoneNumber != null) map['user_phone_number'] = userPhoneNumber;
    if (profileImage != null) map['profile_image'] = profileImage;
    if (preferredTimezone != null) map['preferred_timezone'] = preferredTimezone;

    return map;
  }

  /// Copy with updated fields
  UserModel copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? userPhoneNumber,
    String? profileImage,
    String? preferredTimezone,
    String? createdAt,
    String? updatedAt,
    bool? isDeleted,
    bool? isEmailVerified,
    String? lastLoginAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      profileImage: profileImage ?? this.profileImage,
      preferredTimezone: preferredTimezone ?? this.preferredTimezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
