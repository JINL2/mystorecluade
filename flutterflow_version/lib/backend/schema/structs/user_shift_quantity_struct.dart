// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserShiftQuantityStruct extends BaseStruct {
  UserShiftQuantityStruct({
    String? shiftQuantity,
    String? requestDate,
  })  : _shiftQuantity = shiftQuantity,
        _requestDate = requestDate;

  // "shift_quantity" field.
  String? _shiftQuantity;
  String get shiftQuantity => _shiftQuantity ?? '';
  set shiftQuantity(String? val) => _shiftQuantity = val;

  bool hasShiftQuantity() => _shiftQuantity != null;

  // "request_date" field.
  String? _requestDate;
  String get requestDate => _requestDate ?? '';
  set requestDate(String? val) => _requestDate = val;

  bool hasRequestDate() => _requestDate != null;

  static UserShiftQuantityStruct fromMap(Map<String, dynamic> data) =>
      UserShiftQuantityStruct(
        shiftQuantity: data['shift_quantity'] as String?,
        requestDate: data['request_date'] as String?,
      );

  static UserShiftQuantityStruct? maybeFromMap(dynamic data) => data is Map
      ? UserShiftQuantityStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'shift_quantity': _shiftQuantity,
        'request_date': _requestDate,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'shift_quantity': serializeParam(
          _shiftQuantity,
          ParamType.String,
        ),
        'request_date': serializeParam(
          _requestDate,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserShiftQuantityStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      UserShiftQuantityStruct(
        shiftQuantity: deserializeParam(
          data['shift_quantity'],
          ParamType.String,
          false,
        ),
        requestDate: deserializeParam(
          data['request_date'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserShiftQuantityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserShiftQuantityStruct &&
        shiftQuantity == other.shiftQuantity &&
        requestDate == other.requestDate;
  }

  @override
  int get hashCode => const ListEquality().hash([shiftQuantity, requestDate]);
}

UserShiftQuantityStruct createUserShiftQuantityStruct({
  String? shiftQuantity,
  String? requestDate,
}) =>
    UserShiftQuantityStruct(
      shiftQuantity: shiftQuantity,
      requestDate: requestDate,
    );
