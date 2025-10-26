import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../domain/entities/role.dart';

/// Data Model: Role Model
///
/// DTO (Data Transfer Object) for Role with JSON serialization.
/// This model knows how to convert between JSON and Domain Entity.
class RoleModel extends Role {
  const RoleModel({
    required super.roleId,
    required super.roleName,
    required super.roleType,
    super.companyId,
    super.parentRoleId,
    super.description,
    super.tags,
    super.isDeletable,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from domain entity
  factory RoleModel.fromEntity(Role entity) {
    return RoleModel(
      roleId: entity.roleId,
      roleName: entity.roleName,
      roleType: entity.roleType,
      companyId: entity.companyId,
      parentRoleId: entity.parentRoleId,
      description: entity.description,
      tags: entity.tags,
      isDeletable: entity.isDeletable,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Create model from JSON (Supabase response)
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String,
      roleType: json['role_type'] as String,
      companyId: json['company_id'] as String?,
      parentRoleId: json['parent_role_id'] as String?,
      description: json['description'] as String?,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
      isDeletable: json['is_deletable'] as bool?,
      createdAt: DateTimeUtils.toLocal(json['created_at'] as String),
      updatedAt: DateTimeUtils.toLocal(json['updated_at'] as String),
    );
  }

  /// Convert model to JSON (for Supabase requests)
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
      'created_at': DateTimeUtils.toUtc(createdAt),
      'updated_at': DateTimeUtils.toUtc(updatedAt),
    };
  }

  /// Convert model to domain entity
  Role toEntity() {
    return Role(
      roleId: roleId,
      roleName: roleName,
      roleType: roleType,
      companyId: companyId,
      parentRoleId: parentRoleId,
      description: description,
      tags: tags,
      isDeletable: isDeletable,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
