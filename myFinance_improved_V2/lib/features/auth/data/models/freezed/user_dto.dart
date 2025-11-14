// lib/features/auth/data/models/freezed/user_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// User Data Transfer Object
///
/// Maps directly to Supabase users table schema.
/// Uses Freezed for immutability and json_serializable for JSON mapping.
///
/// DB Columns (snake_case) → Dart Fields (camelCase):
/// - user_id → userId
/// - first_name → firstName
/// - last_name → lastName
/// - email → email
/// - created_at → createdAt
/// - updated_at → updatedAt
/// - is_deleted → isDeleted
/// - is_email_verified → isEmailVerified
/// - last_login_at → lastLoginAt
/// - user_phone_number → userPhoneNumber
/// - profile_image → profileImage
/// - preferred_timezone → preferredTimezone
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'user_phone_number') String? userPhoneNumber,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'preferred_timezone') String? preferredTimezone,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'is_email_verified') @Default(false) bool isEmailVerified,
    @JsonKey(name: 'last_login_at') String? lastLoginAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
