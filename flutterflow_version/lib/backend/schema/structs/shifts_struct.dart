// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShiftsStruct extends BaseStruct {
  ShiftsStruct({
    String? shiftId,
    String? shiftName,
    int? pendingCount,
    int? approvedCount,
    List<PendingEmployeesStruct>? pendingEmployees,
    List<ApprovedEmployeesStruct>? approvedEmployees,
    int? requiredEmployees,
  })  : _shiftId = shiftId,
        _shiftName = shiftName,
        _pendingCount = pendingCount,
        _approvedCount = approvedCount,
        _pendingEmployees = pendingEmployees,
        _approvedEmployees = approvedEmployees,
        _requiredEmployees = requiredEmployees;

  // "shift_id" field.
  String? _shiftId;
  String get shiftId => _shiftId ?? '';
  set shiftId(String? val) => _shiftId = val;

  bool hasShiftId() => _shiftId != null;

  // "shift_name" field.
  String? _shiftName;
  String get shiftName => _shiftName ?? '';
  set shiftName(String? val) => _shiftName = val;

  bool hasShiftName() => _shiftName != null;

  // "pending_count" field.
  int? _pendingCount;
  int get pendingCount => _pendingCount ?? 0;
  set pendingCount(int? val) => _pendingCount = val;

  void incrementPendingCount(int amount) =>
      pendingCount = pendingCount + amount;

  bool hasPendingCount() => _pendingCount != null;

  // "approved_count" field.
  int? _approvedCount;
  int get approvedCount => _approvedCount ?? 0;
  set approvedCount(int? val) => _approvedCount = val;

  void incrementApprovedCount(int amount) =>
      approvedCount = approvedCount + amount;

  bool hasApprovedCount() => _approvedCount != null;

  // "pending_employees" field.
  List<PendingEmployeesStruct>? _pendingEmployees;
  List<PendingEmployeesStruct> get pendingEmployees =>
      _pendingEmployees ?? const [];
  set pendingEmployees(List<PendingEmployeesStruct>? val) =>
      _pendingEmployees = val;

  void updatePendingEmployees(Function(List<PendingEmployeesStruct>) updateFn) {
    updateFn(_pendingEmployees ??= []);
  }

  bool hasPendingEmployees() => _pendingEmployees != null;

  // "approved_employees" field.
  List<ApprovedEmployeesStruct>? _approvedEmployees;
  List<ApprovedEmployeesStruct> get approvedEmployees =>
      _approvedEmployees ?? const [];
  set approvedEmployees(List<ApprovedEmployeesStruct>? val) =>
      _approvedEmployees = val;

  void updateApprovedEmployees(
      Function(List<ApprovedEmployeesStruct>) updateFn) {
    updateFn(_approvedEmployees ??= []);
  }

  bool hasApprovedEmployees() => _approvedEmployees != null;

  // "required_employees" field.
  int? _requiredEmployees;
  int get requiredEmployees => _requiredEmployees ?? 0;
  set requiredEmployees(int? val) => _requiredEmployees = val;

  void incrementRequiredEmployees(int amount) =>
      requiredEmployees = requiredEmployees + amount;

  bool hasRequiredEmployees() => _requiredEmployees != null;

  static ShiftsStruct fromMap(Map<String, dynamic> data) => ShiftsStruct(
        shiftId: data['shift_id'] as String?,
        shiftName: data['shift_name'] as String?,
        pendingCount: castToType<int>(data['pending_count']),
        approvedCount: castToType<int>(data['approved_count']),
        pendingEmployees: getStructList(
          data['pending_employees'],
          PendingEmployeesStruct.fromMap,
        ),
        approvedEmployees: getStructList(
          data['approved_employees'],
          ApprovedEmployeesStruct.fromMap,
        ),
        requiredEmployees: castToType<int>(data['required_employees']),
      );

  static ShiftsStruct? maybeFromMap(dynamic data) =>
      data is Map ? ShiftsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'shift_id': _shiftId,
        'shift_name': _shiftName,
        'pending_count': _pendingCount,
        'approved_count': _approvedCount,
        'pending_employees': _pendingEmployees?.map((e) => e.toMap()).toList(),
        'approved_employees':
            _approvedEmployees?.map((e) => e.toMap()).toList(),
        'required_employees': _requiredEmployees,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'shift_id': serializeParam(
          _shiftId,
          ParamType.String,
        ),
        'shift_name': serializeParam(
          _shiftName,
          ParamType.String,
        ),
        'pending_count': serializeParam(
          _pendingCount,
          ParamType.int,
        ),
        'approved_count': serializeParam(
          _approvedCount,
          ParamType.int,
        ),
        'pending_employees': serializeParam(
          _pendingEmployees,
          ParamType.DataStruct,
          isList: true,
        ),
        'approved_employees': serializeParam(
          _approvedEmployees,
          ParamType.DataStruct,
          isList: true,
        ),
        'required_employees': serializeParam(
          _requiredEmployees,
          ParamType.int,
        ),
      }.withoutNulls;

  static ShiftsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ShiftsStruct(
        shiftId: deserializeParam(
          data['shift_id'],
          ParamType.String,
          false,
        ),
        shiftName: deserializeParam(
          data['shift_name'],
          ParamType.String,
          false,
        ),
        pendingCount: deserializeParam(
          data['pending_count'],
          ParamType.int,
          false,
        ),
        approvedCount: deserializeParam(
          data['approved_count'],
          ParamType.int,
          false,
        ),
        pendingEmployees: deserializeStructParam<PendingEmployeesStruct>(
          data['pending_employees'],
          ParamType.DataStruct,
          true,
          structBuilder: PendingEmployeesStruct.fromSerializableMap,
        ),
        approvedEmployees: deserializeStructParam<ApprovedEmployeesStruct>(
          data['approved_employees'],
          ParamType.DataStruct,
          true,
          structBuilder: ApprovedEmployeesStruct.fromSerializableMap,
        ),
        requiredEmployees: deserializeParam(
          data['required_employees'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ShiftsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ShiftsStruct &&
        shiftId == other.shiftId &&
        shiftName == other.shiftName &&
        pendingCount == other.pendingCount &&
        approvedCount == other.approvedCount &&
        listEquality.equals(pendingEmployees, other.pendingEmployees) &&
        listEquality.equals(approvedEmployees, other.approvedEmployees) &&
        requiredEmployees == other.requiredEmployees;
  }

  @override
  int get hashCode => const ListEquality().hash([
        shiftId,
        shiftName,
        pendingCount,
        approvedCount,
        pendingEmployees,
        approvedEmployees,
        requiredEmployees
      ]);
}

ShiftsStruct createShiftsStruct({
  String? shiftId,
  String? shiftName,
  int? pendingCount,
  int? approvedCount,
  int? requiredEmployees,
}) =>
    ShiftsStruct(
      shiftId: shiftId,
      shiftName: shiftName,
      pendingCount: pendingCount,
      approvedCount: approvedCount,
      requiredEmployees: requiredEmployees,
    );
