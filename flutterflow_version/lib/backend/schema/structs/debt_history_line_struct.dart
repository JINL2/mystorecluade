// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DebtHistoryLineStruct extends BaseStruct {
  DebtHistoryLineStruct({
    String? createdAt,
    String? debtId,
    String? direction,
    int? originalAmount,
    String? description,
    String? status,
  })  : _createdAt = createdAt,
        _debtId = debtId,
        _direction = direction,
        _originalAmount = originalAmount,
        _description = description,
        _status = status;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "debt_id" field.
  String? _debtId;
  String get debtId => _debtId ?? '';
  set debtId(String? val) => _debtId = val;

  bool hasDebtId() => _debtId != null;

  // "direction" field.
  String? _direction;
  String get direction => _direction ?? '';
  set direction(String? val) => _direction = val;

  bool hasDirection() => _direction != null;

  // "original_amount" field.
  int? _originalAmount;
  int get originalAmount => _originalAmount ?? 0;
  set originalAmount(int? val) => _originalAmount = val;

  void incrementOriginalAmount(int amount) =>
      originalAmount = originalAmount + amount;

  bool hasOriginalAmount() => _originalAmount != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  static DebtHistoryLineStruct fromMap(Map<String, dynamic> data) =>
      DebtHistoryLineStruct(
        createdAt: data['created_at'] as String?,
        debtId: data['debt_id'] as String?,
        direction: data['direction'] as String?,
        originalAmount: castToType<int>(data['original_amount']),
        description: data['description'] as String?,
        status: data['status'] as String?,
      );

  static DebtHistoryLineStruct? maybeFromMap(dynamic data) => data is Map
      ? DebtHistoryLineStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'created_at': _createdAt,
        'debt_id': _debtId,
        'direction': _direction,
        'original_amount': _originalAmount,
        'description': _description,
        'status': _status,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'debt_id': serializeParam(
          _debtId,
          ParamType.String,
        ),
        'direction': serializeParam(
          _direction,
          ParamType.String,
        ),
        'original_amount': serializeParam(
          _originalAmount,
          ParamType.int,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
      }.withoutNulls;

  static DebtHistoryLineStruct fromSerializableMap(Map<String, dynamic> data) =>
      DebtHistoryLineStruct(
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        debtId: deserializeParam(
          data['debt_id'],
          ParamType.String,
          false,
        ),
        direction: deserializeParam(
          data['direction'],
          ParamType.String,
          false,
        ),
        originalAmount: deserializeParam(
          data['original_amount'],
          ParamType.int,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DebtHistoryLineStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DebtHistoryLineStruct &&
        createdAt == other.createdAt &&
        debtId == other.debtId &&
        direction == other.direction &&
        originalAmount == other.originalAmount &&
        description == other.description &&
        status == other.status;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [createdAt, debtId, direction, originalAmount, description, status]);
}

DebtHistoryLineStruct createDebtHistoryLineStruct({
  String? createdAt,
  String? debtId,
  String? direction,
  int? originalAmount,
  String? description,
  String? status,
}) =>
    DebtHistoryLineStruct(
      createdAt: createdAt,
      debtId: debtId,
      direction: direction,
      originalAmount: originalAmount,
      description: description,
      status: status,
    );
