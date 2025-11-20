// lib/features/delegate_role/domain/value_objects/permission_set.dart

import '../exceptions/role_exceptions.dart';

/// Permission Set Value Object
///
/// Encapsulates a set of permissions with validation rules:
/// - Must have at least one permission for custom roles
/// - Cannot exceed 100 permissions per role
/// - Immutable once created
class PermissionSet {
  final Set<String> permissions;

  const PermissionSet._(this.permissions);

  /// Maximum permissions per role
  static const int maxPermissions = 100;

  /// Create PermissionSet with validation
  factory PermissionSet.create(Set<String> permissions) {
    // Business rule: Custom roles must have at least one permission
    if (permissions.isEmpty) {
      throw const RoleValidationException(
        'Role must have at least one permission',
      );
    }

    // Business rule: Max 100 permissions per role
    if (permissions.length > maxPermissions) {
      throw const RoleValidationException(
        'Role cannot have more than $maxPermissions permissions',
      );
    }

    // Make immutable
    return PermissionSet._(Set.unmodifiable(permissions));
  }

  /// Create empty permission set (for system roles)
  factory PermissionSet.empty() => const PermissionSet._({});

  /// Check if contains a specific permission
  bool contains(String permission) => permissions.contains(permission);

  /// Get permission count
  int get count => permissions.length;

  /// Check if empty
  bool get isEmpty => permissions.isEmpty;

  /// Check if not empty
  bool get isNotEmpty => permissions.isNotEmpty;

  /// Get list of permissions
  List<String> toList() => permissions.toList();

  /// Create new set with added permission
  PermissionSet add(String permission) {
    final newPermissions = Set<String>.from(permissions)..add(permission);
    return PermissionSet.create(newPermissions);
  }

  /// Create new set with removed permission
  PermissionSet remove(String permission) {
    final newPermissions = Set<String>.from(permissions)..remove(permission);
    // Allow empty for remove operation
    if (newPermissions.isEmpty) {
      return PermissionSet.empty();
    }
    return PermissionSet._(Set.unmodifiable(newPermissions));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionSet &&
          runtimeType == other.runtimeType &&
          permissions.length == other.permissions.length &&
          permissions.every((p) => other.permissions.contains(p));

  @override
  int get hashCode => permissions.fold(0, (hash, p) => hash ^ p.hashCode);

  @override
  String toString() => 'PermissionSet(${permissions.length} permissions)';
}
