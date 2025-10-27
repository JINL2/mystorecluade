import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/delegatable_role.dart';

part 'delegatable_role_model.freezed.dart';
part 'delegatable_role_model.g.dart';

@freezed
class DelegatableRoleModel with _$DelegatableRoleModel {
  const DelegatableRoleModel._();

  const factory DelegatableRoleModel({
    required String roleId,
    required String roleName,
    required String description,
    required List<String> permissions,
    required bool canDelegate,
  }) = _DelegatableRoleModel;

  factory DelegatableRoleModel.fromJson(Map<String, dynamic> json) =>
      _$DelegatableRoleModelFromJson(json);

  /// Convert model to domain entity
  DelegatableRole toEntity() {
    return DelegatableRole(
      roleId: roleId,
      roleName: roleName,
      description: description,
      permissions: permissions,
      canDelegate: canDelegate,
    );
  }

  /// Create model from domain entity
  factory DelegatableRoleModel.fromEntity(DelegatableRole entity) {
    return DelegatableRoleModel(
      roleId: entity.roleId,
      roleName: entity.roleName,
      description: entity.description,
      permissions: entity.permissions,
      canDelegate: entity.canDelegate,
    );
  }
}
