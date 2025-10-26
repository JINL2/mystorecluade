import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../domain/entities/role_delegation.dart';

part 'role_delegation_model.freezed.dart';
part 'role_delegation_model.g.dart';

/// Custom JSON converter for DateTime with UTC to Local conversion
class _DateTimeConverter implements JsonConverter<DateTime, String> {
  const _DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTimeUtils.toLocal(json);
  }

  @override
  String toJson(DateTime object) {
    return DateTimeUtils.toUtc(object);
  }
}

/// Custom JSON converter for nullable DateTime with UTC to Local conversion
class _NullableDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const _NullableDateTimeConverter();

  @override
  DateTime? fromJson(String? json) {
    return DateTimeUtils.toLocalSafe(json);
  }

  @override
  String? toJson(DateTime? object) {
    return object != null ? DateTimeUtils.toUtc(object) : null;
  }
}

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
    @_DateTimeConverter() required DateTime startDate,
    @_DateTimeConverter() required DateTime endDate,
    required bool isActive,
    @_NullableDateTimeConverter() DateTime? createdAt,
    @_NullableDateTimeConverter() DateTime? updatedAt,
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
