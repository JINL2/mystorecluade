// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VShiftRequestMonthStruct extends BaseStruct {
  VShiftRequestMonthStruct({
    String? shiftRequestId,
    String? shiftId,
    String? actualStartTime,
    String? actualEndTime,
    String? requestDate,
    String? totalSalaryPay,
    String? salaryType,
    String? paidHour,
    String? salaryAmount,
    String? lateDeducutAmount,
    String? overtimeAmount,
    bool? isLate,
    bool? isValidCheckoutLocation,
    bool? isValidCheckinLocation,
    String? bonusAmount,
    String? startTime,
    String? endTime,
    bool? isApproved,
    String? confirmStartTime,
    String? confirmEndTime,
  })  : _shiftRequestId = shiftRequestId,
        _shiftId = shiftId,
        _actualStartTime = actualStartTime,
        _actualEndTime = actualEndTime,
        _requestDate = requestDate,
        _totalSalaryPay = totalSalaryPay,
        _salaryType = salaryType,
        _paidHour = paidHour,
        _salaryAmount = salaryAmount,
        _lateDeducutAmount = lateDeducutAmount,
        _overtimeAmount = overtimeAmount,
        _isLate = isLate,
        _isValidCheckoutLocation = isValidCheckoutLocation,
        _isValidCheckinLocation = isValidCheckinLocation,
        _bonusAmount = bonusAmount,
        _startTime = startTime,
        _endTime = endTime,
        _isApproved = isApproved,
        _confirmStartTime = confirmStartTime,
        _confirmEndTime = confirmEndTime;

  // "shift_request_id" field.
  String? _shiftRequestId;
  String get shiftRequestId => _shiftRequestId ?? '';
  set shiftRequestId(String? val) => _shiftRequestId = val;

  bool hasShiftRequestId() => _shiftRequestId != null;

  // "shift_id" field.
  String? _shiftId;
  String get shiftId => _shiftId ?? '';
  set shiftId(String? val) => _shiftId = val;

  bool hasShiftId() => _shiftId != null;

  // "actual_start_time" field.
  String? _actualStartTime;
  String get actualStartTime => _actualStartTime ?? '';
  set actualStartTime(String? val) => _actualStartTime = val;

  bool hasActualStartTime() => _actualStartTime != null;

  // "actual_end_time" field.
  String? _actualEndTime;
  String get actualEndTime => _actualEndTime ?? '';
  set actualEndTime(String? val) => _actualEndTime = val;

  bool hasActualEndTime() => _actualEndTime != null;

  // "request_date" field.
  String? _requestDate;
  String get requestDate => _requestDate ?? '';
  set requestDate(String? val) => _requestDate = val;

  bool hasRequestDate() => _requestDate != null;

  // "total_salary_pay" field.
  String? _totalSalaryPay;
  String get totalSalaryPay => _totalSalaryPay ?? '';
  set totalSalaryPay(String? val) => _totalSalaryPay = val;

  bool hasTotalSalaryPay() => _totalSalaryPay != null;

  // "salary_type" field.
  String? _salaryType;
  String get salaryType => _salaryType ?? '';
  set salaryType(String? val) => _salaryType = val;

  bool hasSalaryType() => _salaryType != null;

  // "paid_hour" field.
  String? _paidHour;
  String get paidHour => _paidHour ?? '';
  set paidHour(String? val) => _paidHour = val;

  bool hasPaidHour() => _paidHour != null;

  // "salary_amount" field.
  String? _salaryAmount;
  String get salaryAmount => _salaryAmount ?? '';
  set salaryAmount(String? val) => _salaryAmount = val;

  bool hasSalaryAmount() => _salaryAmount != null;

  // "late_deducut_amount" field.
  String? _lateDeducutAmount;
  String get lateDeducutAmount => _lateDeducutAmount ?? '';
  set lateDeducutAmount(String? val) => _lateDeducutAmount = val;

  bool hasLateDeducutAmount() => _lateDeducutAmount != null;

  // "overtime_amount" field.
  String? _overtimeAmount;
  String get overtimeAmount => _overtimeAmount ?? '';
  set overtimeAmount(String? val) => _overtimeAmount = val;

  bool hasOvertimeAmount() => _overtimeAmount != null;

  // "is_late" field.
  bool? _isLate;
  bool get isLate => _isLate ?? false;
  set isLate(bool? val) => _isLate = val;

  bool hasIsLate() => _isLate != null;

  // "is_valid_checkout_location" field.
  bool? _isValidCheckoutLocation;
  bool get isValidCheckoutLocation => _isValidCheckoutLocation ?? false;
  set isValidCheckoutLocation(bool? val) => _isValidCheckoutLocation = val;

  bool hasIsValidCheckoutLocation() => _isValidCheckoutLocation != null;

  // "is_valid_checkin_location" field.
  bool? _isValidCheckinLocation;
  bool get isValidCheckinLocation => _isValidCheckinLocation ?? false;
  set isValidCheckinLocation(bool? val) => _isValidCheckinLocation = val;

  bool hasIsValidCheckinLocation() => _isValidCheckinLocation != null;

  // "bonus_amount" field.
  String? _bonusAmount;
  String get bonusAmount => _bonusAmount ?? '';
  set bonusAmount(String? val) => _bonusAmount = val;

  bool hasBonusAmount() => _bonusAmount != null;

  // "start_time" field.
  String? _startTime;
  String get startTime => _startTime ?? '';
  set startTime(String? val) => _startTime = val;

  bool hasStartTime() => _startTime != null;

  // "end_time" field.
  String? _endTime;
  String get endTime => _endTime ?? '';
  set endTime(String? val) => _endTime = val;

  bool hasEndTime() => _endTime != null;

  // "is_approved" field.
  bool? _isApproved;
  bool get isApproved => _isApproved ?? false;
  set isApproved(bool? val) => _isApproved = val;

  bool hasIsApproved() => _isApproved != null;

  // "confirm_start_time" field.
  String? _confirmStartTime;
  String get confirmStartTime => _confirmStartTime ?? '';
  set confirmStartTime(String? val) => _confirmStartTime = val;

  bool hasConfirmStartTime() => _confirmStartTime != null;

  // "confirm_end_time" field.
  String? _confirmEndTime;
  String get confirmEndTime => _confirmEndTime ?? '';
  set confirmEndTime(String? val) => _confirmEndTime = val;

  bool hasConfirmEndTime() => _confirmEndTime != null;

  static VShiftRequestMonthStruct fromMap(Map<String, dynamic> data) =>
      VShiftRequestMonthStruct(
        shiftRequestId: data['shift_request_id'] as String?,
        shiftId: data['shift_id'] as String?,
        actualStartTime: data['actual_start_time'] as String?,
        actualEndTime: data['actual_end_time'] as String?,
        requestDate: data['request_date'] as String?,
        totalSalaryPay: data['total_salary_pay'] as String?,
        salaryType: data['salary_type'] as String?,
        paidHour: data['paid_hour'] as String?,
        salaryAmount: data['salary_amount'] as String?,
        lateDeducutAmount: data['late_deducut_amount'] as String?,
        overtimeAmount: data['overtime_amount'] as String?,
        isLate: data['is_late'] as bool?,
        isValidCheckoutLocation: data['is_valid_checkout_location'] as bool?,
        isValidCheckinLocation: data['is_valid_checkin_location'] as bool?,
        bonusAmount: data['bonus_amount'] as String?,
        startTime: data['start_time'] as String?,
        endTime: data['end_time'] as String?,
        isApproved: data['is_approved'] as bool?,
        confirmStartTime: data['confirm_start_time'] as String?,
        confirmEndTime: data['confirm_end_time'] as String?,
      );

  static VShiftRequestMonthStruct? maybeFromMap(dynamic data) => data is Map
      ? VShiftRequestMonthStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'shift_request_id': _shiftRequestId,
        'shift_id': _shiftId,
        'actual_start_time': _actualStartTime,
        'actual_end_time': _actualEndTime,
        'request_date': _requestDate,
        'total_salary_pay': _totalSalaryPay,
        'salary_type': _salaryType,
        'paid_hour': _paidHour,
        'salary_amount': _salaryAmount,
        'late_deducut_amount': _lateDeducutAmount,
        'overtime_amount': _overtimeAmount,
        'is_late': _isLate,
        'is_valid_checkout_location': _isValidCheckoutLocation,
        'is_valid_checkin_location': _isValidCheckinLocation,
        'bonus_amount': _bonusAmount,
        'start_time': _startTime,
        'end_time': _endTime,
        'is_approved': _isApproved,
        'confirm_start_time': _confirmStartTime,
        'confirm_end_time': _confirmEndTime,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'shift_request_id': serializeParam(
          _shiftRequestId,
          ParamType.String,
        ),
        'shift_id': serializeParam(
          _shiftId,
          ParamType.String,
        ),
        'actual_start_time': serializeParam(
          _actualStartTime,
          ParamType.String,
        ),
        'actual_end_time': serializeParam(
          _actualEndTime,
          ParamType.String,
        ),
        'request_date': serializeParam(
          _requestDate,
          ParamType.String,
        ),
        'total_salary_pay': serializeParam(
          _totalSalaryPay,
          ParamType.String,
        ),
        'salary_type': serializeParam(
          _salaryType,
          ParamType.String,
        ),
        'paid_hour': serializeParam(
          _paidHour,
          ParamType.String,
        ),
        'salary_amount': serializeParam(
          _salaryAmount,
          ParamType.String,
        ),
        'late_deducut_amount': serializeParam(
          _lateDeducutAmount,
          ParamType.String,
        ),
        'overtime_amount': serializeParam(
          _overtimeAmount,
          ParamType.String,
        ),
        'is_late': serializeParam(
          _isLate,
          ParamType.bool,
        ),
        'is_valid_checkout_location': serializeParam(
          _isValidCheckoutLocation,
          ParamType.bool,
        ),
        'is_valid_checkin_location': serializeParam(
          _isValidCheckinLocation,
          ParamType.bool,
        ),
        'bonus_amount': serializeParam(
          _bonusAmount,
          ParamType.String,
        ),
        'start_time': serializeParam(
          _startTime,
          ParamType.String,
        ),
        'end_time': serializeParam(
          _endTime,
          ParamType.String,
        ),
        'is_approved': serializeParam(
          _isApproved,
          ParamType.bool,
        ),
        'confirm_start_time': serializeParam(
          _confirmStartTime,
          ParamType.String,
        ),
        'confirm_end_time': serializeParam(
          _confirmEndTime,
          ParamType.String,
        ),
      }.withoutNulls;

  static VShiftRequestMonthStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      VShiftRequestMonthStruct(
        shiftRequestId: deserializeParam(
          data['shift_request_id'],
          ParamType.String,
          false,
        ),
        shiftId: deserializeParam(
          data['shift_id'],
          ParamType.String,
          false,
        ),
        actualStartTime: deserializeParam(
          data['actual_start_time'],
          ParamType.String,
          false,
        ),
        actualEndTime: deserializeParam(
          data['actual_end_time'],
          ParamType.String,
          false,
        ),
        requestDate: deserializeParam(
          data['request_date'],
          ParamType.String,
          false,
        ),
        totalSalaryPay: deserializeParam(
          data['total_salary_pay'],
          ParamType.String,
          false,
        ),
        salaryType: deserializeParam(
          data['salary_type'],
          ParamType.String,
          false,
        ),
        paidHour: deserializeParam(
          data['paid_hour'],
          ParamType.String,
          false,
        ),
        salaryAmount: deserializeParam(
          data['salary_amount'],
          ParamType.String,
          false,
        ),
        lateDeducutAmount: deserializeParam(
          data['late_deducut_amount'],
          ParamType.String,
          false,
        ),
        overtimeAmount: deserializeParam(
          data['overtime_amount'],
          ParamType.String,
          false,
        ),
        isLate: deserializeParam(
          data['is_late'],
          ParamType.bool,
          false,
        ),
        isValidCheckoutLocation: deserializeParam(
          data['is_valid_checkout_location'],
          ParamType.bool,
          false,
        ),
        isValidCheckinLocation: deserializeParam(
          data['is_valid_checkin_location'],
          ParamType.bool,
          false,
        ),
        bonusAmount: deserializeParam(
          data['bonus_amount'],
          ParamType.String,
          false,
        ),
        startTime: deserializeParam(
          data['start_time'],
          ParamType.String,
          false,
        ),
        endTime: deserializeParam(
          data['end_time'],
          ParamType.String,
          false,
        ),
        isApproved: deserializeParam(
          data['is_approved'],
          ParamType.bool,
          false,
        ),
        confirmStartTime: deserializeParam(
          data['confirm_start_time'],
          ParamType.String,
          false,
        ),
        confirmEndTime: deserializeParam(
          data['confirm_end_time'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VShiftRequestMonthStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VShiftRequestMonthStruct &&
        shiftRequestId == other.shiftRequestId &&
        shiftId == other.shiftId &&
        actualStartTime == other.actualStartTime &&
        actualEndTime == other.actualEndTime &&
        requestDate == other.requestDate &&
        totalSalaryPay == other.totalSalaryPay &&
        salaryType == other.salaryType &&
        paidHour == other.paidHour &&
        salaryAmount == other.salaryAmount &&
        lateDeducutAmount == other.lateDeducutAmount &&
        overtimeAmount == other.overtimeAmount &&
        isLate == other.isLate &&
        isValidCheckoutLocation == other.isValidCheckoutLocation &&
        isValidCheckinLocation == other.isValidCheckinLocation &&
        bonusAmount == other.bonusAmount &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        isApproved == other.isApproved &&
        confirmStartTime == other.confirmStartTime &&
        confirmEndTime == other.confirmEndTime;
  }

  @override
  int get hashCode => const ListEquality().hash([
        shiftRequestId,
        shiftId,
        actualStartTime,
        actualEndTime,
        requestDate,
        totalSalaryPay,
        salaryType,
        paidHour,
        salaryAmount,
        lateDeducutAmount,
        overtimeAmount,
        isLate,
        isValidCheckoutLocation,
        isValidCheckinLocation,
        bonusAmount,
        startTime,
        endTime,
        isApproved,
        confirmStartTime,
        confirmEndTime
      ]);
}

VShiftRequestMonthStruct createVShiftRequestMonthStruct({
  String? shiftRequestId,
  String? shiftId,
  String? actualStartTime,
  String? actualEndTime,
  String? requestDate,
  String? totalSalaryPay,
  String? salaryType,
  String? paidHour,
  String? salaryAmount,
  String? lateDeducutAmount,
  String? overtimeAmount,
  bool? isLate,
  bool? isValidCheckoutLocation,
  bool? isValidCheckinLocation,
  String? bonusAmount,
  String? startTime,
  String? endTime,
  bool? isApproved,
  String? confirmStartTime,
  String? confirmEndTime,
}) =>
    VShiftRequestMonthStruct(
      shiftRequestId: shiftRequestId,
      shiftId: shiftId,
      actualStartTime: actualStartTime,
      actualEndTime: actualEndTime,
      requestDate: requestDate,
      totalSalaryPay: totalSalaryPay,
      salaryType: salaryType,
      paidHour: paidHour,
      salaryAmount: salaryAmount,
      lateDeducutAmount: lateDeducutAmount,
      overtimeAmount: overtimeAmount,
      isLate: isLate,
      isValidCheckoutLocation: isValidCheckoutLocation,
      isValidCheckinLocation: isValidCheckinLocation,
      bonusAmount: bonusAmount,
      startTime: startTime,
      endTime: endTime,
      isApproved: isApproved,
      confirmStartTime: confirmStartTime,
      confirmEndTime: confirmEndTime,
    );
