import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/role.dart';

part 'role_model.freezed.dart';

@freezed
class RoleModel with _$RoleModel {
  const RoleModel._();

  const factory RoleModel({
    required String roleId,
    required String companyId,
    required String roleName,
    String? description,
    required String roleType,
    required List<String> tags,
    required List<String> permissions,
    required int memberCount,
    required bool canEdit,
    required bool canDelegate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    // Handle different JSON formats from RPC
    return RoleModel(
      roleId: json['roleId'] as String? ?? json['role_id'] as String? ?? '',
      companyId: json['companyId'] as String? ?? json['company_id'] as String? ?? '',
      roleName: json['roleName'] as String? ?? json['role_name'] as String? ?? '',
      description: json['description'] as String?,
      roleType: json['roleType'] as String? ?? json['role_type'] as String? ?? 'custom',
      tags: _parseTags(json['tags']),
      permissions: _parsePermissions(json['permissions']),
      memberCount: json['memberCount'] as int? ?? json['member_count'] as int? ?? 0,
      canEdit: json['canEdit'] as bool? ?? json['can_edit'] as bool? ?? false,
      canDelegate: json['canDelegate'] as bool? ?? json['can_delegate'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  /// Convert model to domain entity
  Role toEntity() {
    return Role(
      roleId: roleId,
      companyId: companyId,
      roleName: roleName,
      description: description,
      roleType: roleType,
      tags: tags,
      permissions: permissions,
      memberCount: memberCount,
      canEdit: canEdit,
      canDelegate: canDelegate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from domain entity
  factory RoleModel.fromEntity(Role entity) {
    return RoleModel(
      roleId: entity.roleId,
      companyId: entity.companyId,
      roleName: entity.roleName,
      description: entity.description,
      roleType: entity.roleType,
      tags: entity.tags,
      permissions: entity.permissions,
      memberCount: entity.memberCount,
      canEdit: entity.canEdit,
      canDelegate: entity.canDelegate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Helper to parse tags from various formats
  static List<String> _parseTags(dynamic tagsData) {
    if (tagsData == null) return [];

    if (tagsData is List) {
      return tagsData.map((e) => e.toString()).toList();
    }

    // Handle legacy malformed data (Map format)
    if (tagsData is Map && tagsData.containsKey('tag1')) {
      String tagString = tagsData['tag1'].toString();
      tagString = tagString.replaceAll('[', '').replaceAll(']', '');
      return tagString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    return [];
  }

  /// Helper to parse permissions
  static List<String> _parsePermissions(dynamic permissionsData) {
    if (permissionsData == null) return [];

    if (permissionsData is List) {
      return permissionsData.map((e) => e.toString()).toList();
    }

    return [];
  }
}
