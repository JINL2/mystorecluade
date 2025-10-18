// lib/features/auth/domain/entities/user_entity.dart

import '../value_objects/validation_result.dart';
import '../validators/email_validator.dart';

/// User entity representing an authenticated user in the system.
///
/// This is a core domain entity that encapsulates user data and validation logic.
/// It is completely independent of any framework (Flutter, Supabase, etc.)
class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    required this.createdAt,
    this.lastLoginAt,
    required this.isEmailVerified,
  });

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

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName, isEmailVerified: $isEmailVerified)';
  }
}
