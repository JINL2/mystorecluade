// lib/features/auth/domain/entities/user_entity.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/validation_result.dart';
import '../validators/email_validator.dart';

part 'user_entity.freezed.dart';

/// User entity representing an authenticated user in the system.
///
/// This is a core domain entity that encapsulates user data and validation logic.
/// It is completely independent of any framework (Flutter, Supabase, etc.)
///
/// Migrated to Freezed for:
/// - Immutability guarantees
/// - Automatic copyWith generation
/// - Type-safe equality
/// - Reduced boilerplate
@freezed
class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    required DateTime createdAt,
    DateTime? lastLoginAt,
    required bool isEmailVerified,
  }) = _User;

  /// Validates the user entity
  ///
  /// Returns a [ValidationResult] containing any validation errors.
  /// This follows the Entity self-validation pattern from Clean Architecture.
  ValidationResult validate() {
    final errors = <String>[];

    // Email validation
    if (email.trim().isEmpty) {
      errors.add('Email is required');
    }
    if (!EmailValidator.isValid(email)) {
      errors.add('Invalid email format');
    }

    // Name validation (optional fields, but if provided should not be empty)
    if (firstName != null && firstName!.trim().isEmpty) {
      errors.add('First name cannot be empty if provided');
    }
    if (lastName != null && lastName!.trim().isEmpty) {
      errors.add('Last name cannot be empty if provided');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Get display name for UI
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) {
      return firstName!;
    }
    return email.split('@').first; // Fallback to email username
  }

  /// Get initials for avatar
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (firstName != null) {
      return firstName!.substring(0, 1).toUpperCase();
    }
    return email.substring(0, 1).toUpperCase();
  }
}
