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

  Role({
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

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String,
      roleType: json['role_type'] as String,
      companyId: json['company_id'] as String?,
      parentRoleId: json['parent_role_id'] as String?,
      description: json['description'] as String?,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      isDeletable: json['is_deletable'] as bool?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'role_name': roleName,
      'role_type': roleType,
      'company_id': companyId,
      'parent_role_id': parentRoleId,
      'description': description,
      'tags': tags,
      'is_deletable': isDeletable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

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