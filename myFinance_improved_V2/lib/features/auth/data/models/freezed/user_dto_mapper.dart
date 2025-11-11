// lib/features/auth/data/models/freezed/user_dto_mapper.dart

import '../../../domain/entities/user_entity.dart';
import '../../../../../core/utils/datetime_utils.dart';
import 'user_dto.dart';

/// UserDto Mapper
///
/// Converts between UserDto (Data Layer) and User Entity (Domain Layer).
///
/// Responsibilities:
/// - DTO → Entity conversion (toEntity)
/// - Entity → DTO conversion (fromEntity)
/// - DateTime string parsing and formatting
extension UserDtoMapper on UserDto {
  /// Convert DTO to Domain Entity
  User toEntity() {
    return User(
      id: userId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      createdAt: DateTimeUtils.toLocal(createdAt),
      lastLoginAt:
          lastLoginAt != null ? DateTimeUtils.toLocal(lastLoginAt!) : null,
      isEmailVerified: isEmailVerified,
    );
  }

  /// Create insert map for Supabase (user profile creation)
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
}

/// User Entity to DTO extension
extension UserEntityMapper on User {
  /// Convert Entity to DTO
  UserDto toDto() {
    return UserDto(
      userId: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      createdAt: DateTimeUtils.toUtc(createdAt),
      lastLoginAt:
          lastLoginAt != null ? DateTimeUtils.toUtc(lastLoginAt!) : null,
      isEmailVerified: isEmailVerified,
    );
  }
}
