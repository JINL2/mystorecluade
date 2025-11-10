// lib/features/delegate_role/domain/value_objects/role_name.dart

import '../exceptions/role_exceptions.dart';

/// Role Name Value Object with business validation
///
/// Encapsulates role name with validation rules:
/// - Cannot be empty
/// - Must be 2-50 characters
/// - Cannot be reserved system names (Owner, Admin)
class RoleName {
  final String value;

  const RoleName._(this.value);

  /// Reserved role names that cannot be created by users
  static const List<String> _reservedNames = ['owner', 'admin'];

  /// Create RoleName from string with validation
  factory RoleName.create(String name) {
    final trimmed = name.trim();

    // Business rule: Role name cannot be empty
    if (trimmed.isEmpty) {
      throw RoleValidationException('Role name cannot be empty');
    }

    // Business rule: Role name must be 2-50 characters
    if (trimmed.length < 2) {
      throw RoleValidationException(
        'Role name must be at least 2 characters',
      );
    }

    if (trimmed.length > 50) {
      throw RoleValidationException(
        'Role name cannot exceed 50 characters',
      );
    }

    // Business rule: Reserved names cannot be used
    final normalizedName = trimmed.toLowerCase();
    if (_reservedNames.contains(normalizedName)) {
      throw RoleValidationException(
        'Cannot create role named "$trimmed" - this is a reserved system role',
      );
    }

    return RoleName._(trimmed);
  }

  /// Create RoleName without validation (for system roles)
  factory RoleName.unsafe(String name) {
    return RoleName._(name);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleName &&
          runtimeType == other.runtimeType &&
          value.toLowerCase() == other.value.toLowerCase();

  @override
  int get hashCode => value.toLowerCase().hashCode;

  @override
  String toString() => value;
}
