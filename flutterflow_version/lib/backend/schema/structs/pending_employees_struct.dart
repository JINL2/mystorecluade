// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PendingEmployeesStruct extends BaseStruct {
  PendingEmployeesStruct({
    String? userId,
    String? userName,
    bool? isApproved,
    String? shiftRequestId,
  })  : _userId = userId,
        _userName = userName,
        _isApproved = isApproved,
        _shiftRequestId = shiftRequestId;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "user_name" field.
  String? _userName;
  String get userName => _userName ?? '';
  set userName(String? val) => _userName = val;

  bool hasUserName() => _userName != null;

  // "is_approved" field.
  bool? _isApproved;
  bool get isApproved => _isApproved ?? false;
  set isApproved(bool? val) => _isApproved = val;

  bool hasIsApproved() => _isApproved != null;

  // "shift_request_id" field.
  String? _shiftRequestId;
  String get shiftRequestId => _shiftRequestId ?? '';
  set shiftRequestId(String? val) => _shiftRequestId = val;

  bool hasShiftRequestId() => _shiftRequestId != null;

  static PendingEmployeesStruct fromMap(Map<String, dynamic> data) =>
      PendingEmployeesStruct(
        userId: data['user_id'] as String?,
        userName: data['user_name'] as String?,
        isApproved: data['is_approved'] as bool?,
        shiftRequestId: data['shift_request_id'] as String?,
      );

  static PendingEmployeesStruct? maybeFromMap(dynamic data) => data is Map
      ? PendingEmployeesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'user_id': _userId,
        'user_name': _userName,
        'is_approved': _isApproved,
        'shift_request_id': _shiftRequestId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'user_name': serializeParam(
          _userName,
          ParamType.String,
        ),
        'is_approved': serializeParam(
          _isApproved,
          ParamType.bool,
        ),
        'shift_request_id': serializeParam(
          _shiftRequestId,
          ParamType.String,
        ),
      }.withoutNulls;

  static PendingEmployeesStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PendingEmployeesStruct(
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        userName: deserializeParam(
          data['user_name'],
          ParamType.String,
          false,
        ),
        isApproved: deserializeParam(
          data['is_approved'],
          ParamType.bool,
          false,
        ),
        shiftRequestId: deserializeParam(
          data['shift_request_id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PendingEmployeesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PendingEmployeesStruct &&
        userId == other.userId &&
        userName == other.userName &&
        isApproved == other.isApproved &&
        shiftRequestId == other.shiftRequestId;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([userId, userName, isApproved, shiftRequestId]);
}

PendingEmployeesStruct createPendingEmployeesStruct({
  String? userId,
  String? userName,
  bool? isApproved,
  String? shiftRequestId,
}) =>
    PendingEmployeesStruct(
      userId: userId,
      userName: userName,
      isApproved: isApproved,
      shiftRequestId: shiftRequestId,
    );
