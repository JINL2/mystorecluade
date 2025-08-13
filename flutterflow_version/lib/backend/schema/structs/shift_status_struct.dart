// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShiftStatusStruct extends BaseStruct {
  ShiftStatusStruct({
    String? shiftId,
    String? requestDate,
    int? totalRegistered,
    bool? isRegisteredByMe,
    String? shiftRequestId,
    bool? isApproved,
    String? storeId,
    int? totalOtherStaffs,

    /// other_staffs
    List<OtherStaffsStruct>? otherStaffs,
  })  : _shiftId = shiftId,
        _requestDate = requestDate,
        _totalRegistered = totalRegistered,
        _isRegisteredByMe = isRegisteredByMe,
        _shiftRequestId = shiftRequestId,
        _isApproved = isApproved,
        _storeId = storeId,
        _totalOtherStaffs = totalOtherStaffs,
        _otherStaffs = otherStaffs;

  // "shift_id" field.
  String? _shiftId;
  String get shiftId => _shiftId ?? '';
  set shiftId(String? val) => _shiftId = val;

  bool hasShiftId() => _shiftId != null;

  // "request_date" field.
  String? _requestDate;
  String get requestDate => _requestDate ?? '';
  set requestDate(String? val) => _requestDate = val;

  bool hasRequestDate() => _requestDate != null;

  // "total_registered" field.
  int? _totalRegistered;
  int get totalRegistered => _totalRegistered ?? 0;
  set totalRegistered(int? val) => _totalRegistered = val;

  void incrementTotalRegistered(int amount) =>
      totalRegistered = totalRegistered + amount;

  bool hasTotalRegistered() => _totalRegistered != null;

  // "is_registered_by_me" field.
  bool? _isRegisteredByMe;
  bool get isRegisteredByMe => _isRegisteredByMe ?? false;
  set isRegisteredByMe(bool? val) => _isRegisteredByMe = val;

  bool hasIsRegisteredByMe() => _isRegisteredByMe != null;

  // "shift_request_id" field.
  String? _shiftRequestId;
  String get shiftRequestId => _shiftRequestId ?? '';
  set shiftRequestId(String? val) => _shiftRequestId = val;

  bool hasShiftRequestId() => _shiftRequestId != null;

  // "is_approved" field.
  bool? _isApproved;
  bool get isApproved => _isApproved ?? false;
  set isApproved(bool? val) => _isApproved = val;

  bool hasIsApproved() => _isApproved != null;

  // "store_id" field.
  String? _storeId;
  String get storeId => _storeId ?? '';
  set storeId(String? val) => _storeId = val;

  bool hasStoreId() => _storeId != null;

  // "total_other_staffs" field.
  int? _totalOtherStaffs;
  int get totalOtherStaffs => _totalOtherStaffs ?? 0;
  set totalOtherStaffs(int? val) => _totalOtherStaffs = val;

  void incrementTotalOtherStaffs(int amount) =>
      totalOtherStaffs = totalOtherStaffs + amount;

  bool hasTotalOtherStaffs() => _totalOtherStaffs != null;

  // "other_staffs" field.
  List<OtherStaffsStruct>? _otherStaffs;
  List<OtherStaffsStruct> get otherStaffs => _otherStaffs ?? const [];
  set otherStaffs(List<OtherStaffsStruct>? val) => _otherStaffs = val;

  void updateOtherStaffs(Function(List<OtherStaffsStruct>) updateFn) {
    updateFn(_otherStaffs ??= []);
  }

  bool hasOtherStaffs() => _otherStaffs != null;

  static ShiftStatusStruct fromMap(Map<String, dynamic> data) =>
      ShiftStatusStruct(
        shiftId: data['shift_id'] as String?,
        requestDate: data['request_date'] as String?,
        totalRegistered: castToType<int>(data['total_registered']),
        isRegisteredByMe: data['is_registered_by_me'] as bool?,
        shiftRequestId: data['shift_request_id'] as String?,
        isApproved: data['is_approved'] as bool?,
        storeId: data['store_id'] as String?,
        totalOtherStaffs: castToType<int>(data['total_other_staffs']),
        otherStaffs: getStructList(
          data['other_staffs'],
          OtherStaffsStruct.fromMap,
        ),
      );

  static ShiftStatusStruct? maybeFromMap(dynamic data) => data is Map
      ? ShiftStatusStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'shift_id': _shiftId,
        'request_date': _requestDate,
        'total_registered': _totalRegistered,
        'is_registered_by_me': _isRegisteredByMe,
        'shift_request_id': _shiftRequestId,
        'is_approved': _isApproved,
        'store_id': _storeId,
        'total_other_staffs': _totalOtherStaffs,
        'other_staffs': _otherStaffs?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'shift_id': serializeParam(
          _shiftId,
          ParamType.String,
        ),
        'request_date': serializeParam(
          _requestDate,
          ParamType.String,
        ),
        'total_registered': serializeParam(
          _totalRegistered,
          ParamType.int,
        ),
        'is_registered_by_me': serializeParam(
          _isRegisteredByMe,
          ParamType.bool,
        ),
        'shift_request_id': serializeParam(
          _shiftRequestId,
          ParamType.String,
        ),
        'is_approved': serializeParam(
          _isApproved,
          ParamType.bool,
        ),
        'store_id': serializeParam(
          _storeId,
          ParamType.String,
        ),
        'total_other_staffs': serializeParam(
          _totalOtherStaffs,
          ParamType.int,
        ),
        'other_staffs': serializeParam(
          _otherStaffs,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static ShiftStatusStruct fromSerializableMap(Map<String, dynamic> data) =>
      ShiftStatusStruct(
        shiftId: deserializeParam(
          data['shift_id'],
          ParamType.String,
          false,
        ),
        requestDate: deserializeParam(
          data['request_date'],
          ParamType.String,
          false,
        ),
        totalRegistered: deserializeParam(
          data['total_registered'],
          ParamType.int,
          false,
        ),
        isRegisteredByMe: deserializeParam(
          data['is_registered_by_me'],
          ParamType.bool,
          false,
        ),
        shiftRequestId: deserializeParam(
          data['shift_request_id'],
          ParamType.String,
          false,
        ),
        isApproved: deserializeParam(
          data['is_approved'],
          ParamType.bool,
          false,
        ),
        storeId: deserializeParam(
          data['store_id'],
          ParamType.String,
          false,
        ),
        totalOtherStaffs: deserializeParam(
          data['total_other_staffs'],
          ParamType.int,
          false,
        ),
        otherStaffs: deserializeStructParam<OtherStaffsStruct>(
          data['other_staffs'],
          ParamType.DataStruct,
          true,
          structBuilder: OtherStaffsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ShiftStatusStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ShiftStatusStruct &&
        shiftId == other.shiftId &&
        requestDate == other.requestDate &&
        totalRegistered == other.totalRegistered &&
        isRegisteredByMe == other.isRegisteredByMe &&
        shiftRequestId == other.shiftRequestId &&
        isApproved == other.isApproved &&
        storeId == other.storeId &&
        totalOtherStaffs == other.totalOtherStaffs &&
        listEquality.equals(otherStaffs, other.otherStaffs);
  }

  @override
  int get hashCode => const ListEquality().hash([
        shiftId,
        requestDate,
        totalRegistered,
        isRegisteredByMe,
        shiftRequestId,
        isApproved,
        storeId,
        totalOtherStaffs,
        otherStaffs
      ]);
}

ShiftStatusStruct createShiftStatusStruct({
  String? shiftId,
  String? requestDate,
  int? totalRegistered,
  bool? isRegisteredByMe,
  String? shiftRequestId,
  bool? isApproved,
  String? storeId,
  int? totalOtherStaffs,
}) =>
    ShiftStatusStruct(
      shiftId: shiftId,
      requestDate: requestDate,
      totalRegistered: totalRegistered,
      isRegisteredByMe: isRegisteredByMe,
      shiftRequestId: shiftRequestId,
      isApproved: isApproved,
      storeId: storeId,
      totalOtherStaffs: totalOtherStaffs,
    );
