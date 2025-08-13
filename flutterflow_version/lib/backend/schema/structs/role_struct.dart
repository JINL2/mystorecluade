// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RoleStruct extends BaseStruct {
  RoleStruct({
    String? roleId,
    String? roleName,
    List<String>? permissions,
  })  : _roleId = roleId,
        _roleName = roleName,
        _permissions = permissions;

  // "role_id" field.
  String? _roleId;
  String get roleId => _roleId ?? '';
  set roleId(String? val) => _roleId = val;

  bool hasRoleId() => _roleId != null;

  // "role_name" field.
  String? _roleName;
  String get roleName => _roleName ?? '';
  set roleName(String? val) => _roleName = val;

  bool hasRoleName() => _roleName != null;

  // "permissions" field.
  List<String>? _permissions;
  List<String> get permissions => _permissions ?? const [];
  set permissions(List<String>? val) => _permissions = val;

  void updatePermissions(Function(List<String>) updateFn) {
    updateFn(_permissions ??= []);
  }

  bool hasPermissions() => _permissions != null;

  static RoleStruct fromMap(Map<String, dynamic> data) => RoleStruct(
        roleId: data['role_id'] as String?,
        roleName: data['role_name'] as String?,
        permissions: getDataList(data['permissions']),
      );

  static RoleStruct? maybeFromMap(dynamic data) =>
      data is Map ? RoleStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'role_id': _roleId,
        'role_name': _roleName,
        'permissions': _permissions,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'role_id': serializeParam(
          _roleId,
          ParamType.String,
        ),
        'role_name': serializeParam(
          _roleName,
          ParamType.String,
        ),
        'permissions': serializeParam(
          _permissions,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static RoleStruct fromSerializableMap(Map<String, dynamic> data) =>
      RoleStruct(
        roleId: deserializeParam(
          data['role_id'],
          ParamType.String,
          false,
        ),
        roleName: deserializeParam(
          data['role_name'],
          ParamType.String,
          false,
        ),
        permissions: deserializeParam<String>(
          data['permissions'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'RoleStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RoleStruct &&
        roleId == other.roleId &&
        roleName == other.roleName &&
        listEquality.equals(permissions, other.permissions);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([roleId, roleName, permissions]);
}

RoleStruct createRoleStruct({
  String? roleId,
  String? roleName,
}) =>
    RoleStruct(
      roleId: roleId,
      roleName: roleName,
    );
