/// Domain Entity: Role
///
/// Pure business object representing a user role in the system.
class Role {
  final String roleId;
  final String roleName;
  final String roleType;
  final String? companyId;
  final String? parentRoleId;
  final String? description;
  final List<String>? tags;
  final bool? isDeletable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Role({
    required this.roleId,
    required this.roleName,
    required this.roleType,
    this.companyId,
    this.parentRoleId,
    this.description,
    this.tags,
    this.isDeletable,
    required this.createdAt,
    required this.updatedAt,
  });

  Role copyWith({
    String? roleId,
    String? roleName,
    String? roleType,
    String? companyId,
    String? parentRoleId,
    String? description,
    List<String>? tags,
    bool? isDeletable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Role(
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      roleType: roleType ?? this.roleType,
      companyId: companyId ?? this.companyId,
      parentRoleId: parentRoleId ?? this.parentRoleId,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isDeletable: isDeletable ?? this.isDeletable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Role{roleId: $roleId, roleName: $roleName, roleType: $roleType, companyId: $companyId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Role &&
          runtimeType == other.runtimeType &&
          roleId == other.roleId;

  @override
  int get hashCode => roleId.hashCode;
}
