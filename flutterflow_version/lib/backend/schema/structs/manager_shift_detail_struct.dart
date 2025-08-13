// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ManagerShiftDetailStruct extends BaseStruct {
  ManagerShiftDetailStruct({
    String? requestDate,
    String? storeId,
    int? totalRequired,
    int? totalApproved,
    int? totalPending,
    List<ShiftsStruct>? shifts,
  })  : _requestDate = requestDate,
        _storeId = storeId,
        _totalRequired = totalRequired,
        _totalApproved = totalApproved,
        _totalPending = totalPending,
        _shifts = shifts;

  // "request_date" field.
  String? _requestDate;
  String get requestDate => _requestDate ?? '';
  set requestDate(String? val) => _requestDate = val;

  bool hasRequestDate() => _requestDate != null;

  // "store_id" field.
  String? _storeId;
  String get storeId => _storeId ?? '';
  set storeId(String? val) => _storeId = val;

  bool hasStoreId() => _storeId != null;

  // "total_required" field.
  int? _totalRequired;
  int get totalRequired => _totalRequired ?? 0;
  set totalRequired(int? val) => _totalRequired = val;

  void incrementTotalRequired(int amount) =>
      totalRequired = totalRequired + amount;

  bool hasTotalRequired() => _totalRequired != null;

  // "total_approved" field.
  int? _totalApproved;
  int get totalApproved => _totalApproved ?? 0;
  set totalApproved(int? val) => _totalApproved = val;

  void incrementTotalApproved(int amount) =>
      totalApproved = totalApproved + amount;

  bool hasTotalApproved() => _totalApproved != null;

  // "total_pending" field.
  int? _totalPending;
  int get totalPending => _totalPending ?? 0;
  set totalPending(int? val) => _totalPending = val;

  void incrementTotalPending(int amount) =>
      totalPending = totalPending + amount;

  bool hasTotalPending() => _totalPending != null;

  // "shifts" field.
  List<ShiftsStruct>? _shifts;
  List<ShiftsStruct> get shifts => _shifts ?? const [];
  set shifts(List<ShiftsStruct>? val) => _shifts = val;

  void updateShifts(Function(List<ShiftsStruct>) updateFn) {
    updateFn(_shifts ??= []);
  }

  bool hasShifts() => _shifts != null;

  static ManagerShiftDetailStruct fromMap(Map<String, dynamic> data) =>
      ManagerShiftDetailStruct(
        requestDate: data['request_date'] as String?,
        storeId: data['store_id'] as String?,
        totalRequired: castToType<int>(data['total_required']),
        totalApproved: castToType<int>(data['total_approved']),
        totalPending: castToType<int>(data['total_pending']),
        shifts: getStructList(
          data['shifts'],
          ShiftsStruct.fromMap,
        ),
      );

  static ManagerShiftDetailStruct? maybeFromMap(dynamic data) => data is Map
      ? ManagerShiftDetailStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'request_date': _requestDate,
        'store_id': _storeId,
        'total_required': _totalRequired,
        'total_approved': _totalApproved,
        'total_pending': _totalPending,
        'shifts': _shifts?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'request_date': serializeParam(
          _requestDate,
          ParamType.String,
        ),
        'store_id': serializeParam(
          _storeId,
          ParamType.String,
        ),
        'total_required': serializeParam(
          _totalRequired,
          ParamType.int,
        ),
        'total_approved': serializeParam(
          _totalApproved,
          ParamType.int,
        ),
        'total_pending': serializeParam(
          _totalPending,
          ParamType.int,
        ),
        'shifts': serializeParam(
          _shifts,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static ManagerShiftDetailStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ManagerShiftDetailStruct(
        requestDate: deserializeParam(
          data['request_date'],
          ParamType.String,
          false,
        ),
        storeId: deserializeParam(
          data['store_id'],
          ParamType.String,
          false,
        ),
        totalRequired: deserializeParam(
          data['total_required'],
          ParamType.int,
          false,
        ),
        totalApproved: deserializeParam(
          data['total_approved'],
          ParamType.int,
          false,
        ),
        totalPending: deserializeParam(
          data['total_pending'],
          ParamType.int,
          false,
        ),
        shifts: deserializeStructParam<ShiftsStruct>(
          data['shifts'],
          ParamType.DataStruct,
          true,
          structBuilder: ShiftsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ManagerShiftDetailStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ManagerShiftDetailStruct &&
        requestDate == other.requestDate &&
        storeId == other.storeId &&
        totalRequired == other.totalRequired &&
        totalApproved == other.totalApproved &&
        totalPending == other.totalPending &&
        listEquality.equals(shifts, other.shifts);
  }

  @override
  int get hashCode => const ListEquality().hash([
        requestDate,
        storeId,
        totalRequired,
        totalApproved,
        totalPending,
        shifts
      ]);
}

ManagerShiftDetailStruct createManagerShiftDetailStruct({
  String? requestDate,
  String? storeId,
  int? totalRequired,
  int? totalApproved,
  int? totalPending,
}) =>
    ManagerShiftDetailStruct(
      requestDate: requestDate,
      storeId: storeId,
      totalRequired: totalRequired,
      totalApproved: totalApproved,
      totalPending: totalPending,
    );
