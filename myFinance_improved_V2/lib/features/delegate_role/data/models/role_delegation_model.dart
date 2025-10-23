import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/role_delegation.dart';

part 'role_delegation_model.freezed.dart';
part 'role_delegation_model.g.dart';

@freezed
class RoleDelegationModel with _$RoleDelegationModel {
  const RoleDelegationModel._();

  const factory RoleDelegationModel({
    required String id,
    required String delegatorId,
    required String delegateId,
    required String companyId,
    required String roleId,
    required String roleName,
    required Map<String, dynamic> delegateUser,
    required List<String> permissions,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RoleDelegationModel;

  factory RoleDelegationModel.fromJson(Map<String, dynamic> json) =>
      _$RoleDelegationModelFromJson(json);

  /// Convert model to domain entity
  RoleDelegation toEntity() {
    return RoleDelegation(
      id: id,
      delegatorId: delegatorId,
      delegateId: delegateId,
      companyId: companyId,
      roleId: roleId,
      roleName: roleName,
      delegateUser: delegateUser,
      permissions: permissions,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from domain entity
  factory RoleDelegationModel.fromEntity(RoleDelegation entity) {
    return RoleDelegationModel(
      id: entity.id,
      delegatorId: entity.delegatorId,
      delegateId: entity.delegateId,
      companyId: entity.companyId,
      roleId: entity.roleId,
      roleName: entity.roleName,
      delegateUser: entity.delegateUser,
      permissions: entity.permissions,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
