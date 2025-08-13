// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OtherStaffsStruct extends BaseStruct {
  OtherStaffsStruct({
    String? employeeId,
    String? employeeFullName,
    bool? isApproved,
    bool? isRegistered,
  })  : _employeeId = employeeId,
        _employeeFullName = employeeFullName,
        _isApproved = isApproved,
        _isRegistered = isRegistered;

  // "employee_id" field.
  String? _employeeId;
  String get employeeId => _employeeId ?? '';
  set employeeId(String? val) => _employeeId = val;

  bool hasEmployeeId() => _employeeId != null;

  // "employee_full_name" field.
  String? _employeeFullName;
  String get employeeFullName => _employeeFullName ?? '';
  set employeeFullName(String? val) => _employeeFullName = val;

  bool hasEmployeeFullName() => _employeeFullName != null;

  // "is_approved" field.
  bool? _isApproved;
  bool get isApproved => _isApproved ?? false;
  set isApproved(bool? val) => _isApproved = val;

  bool hasIsApproved() => _isApproved != null;

  // "is_registered" field.
  bool? _isRegistered;
  bool get isRegistered => _isRegistered ?? false;
  set isRegistered(bool? val) => _isRegistered = val;

  bool hasIsRegistered() => _isRegistered != null;

  static OtherStaffsStruct fromMap(Map<String, dynamic> data) =>
      OtherStaffsStruct(
        employeeId: data['employee_id'] as String?,
        employeeFullName: data['employee_full_name'] as String?,
        isApproved: data['is_approved'] as bool?,
        isRegistered: data['is_registered'] as bool?,
      );

  static OtherStaffsStruct? maybeFromMap(dynamic data) => data is Map
      ? OtherStaffsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'employee_id': _employeeId,
        'employee_full_name': _employeeFullName,
        'is_approved': _isApproved,
        'is_registered': _isRegistered,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'employee_id': serializeParam(
          _employeeId,
          ParamType.String,
        ),
        'employee_full_name': serializeParam(
          _employeeFullName,
          ParamType.String,
        ),
        'is_approved': serializeParam(
          _isApproved,
          ParamType.bool,
        ),
        'is_registered': serializeParam(
          _isRegistered,
          ParamType.bool,
        ),
      }.withoutNulls;

  static OtherStaffsStruct fromSerializableMap(Map<String, dynamic> data) =>
      OtherStaffsStruct(
        employeeId: deserializeParam(
          data['employee_id'],
          ParamType.String,
          false,
        ),
        employeeFullName: deserializeParam(
          data['employee_full_name'],
          ParamType.String,
          false,
        ),
        isApproved: deserializeParam(
          data['is_approved'],
          ParamType.bool,
          false,
        ),
        isRegistered: deserializeParam(
          data['is_registered'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'OtherStaffsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OtherStaffsStruct &&
        employeeId == other.employeeId &&
        employeeFullName == other.employeeFullName &&
        isApproved == other.isApproved &&
        isRegistered == other.isRegistered;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([employeeId, employeeFullName, isApproved, isRegistered]);
}

OtherStaffsStruct createOtherStaffsStruct({
  String? employeeId,
  String? employeeFullName,
  bool? isApproved,
  bool? isRegistered,
}) =>
    OtherStaffsStruct(
      employeeId: employeeId,
      employeeFullName: employeeFullName,
      isApproved: isApproved,
      isRegistered: isRegistered,
    );
