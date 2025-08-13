// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VSalaryIndividualStruct extends BaseStruct {
  VSalaryIndividualStruct({
    String? salaryRequestId,
    String? userId,
    String? storeId,
    String? requestDate,
    String? salaryType,
    String? userSalary,
    String? totalSalary,
    bool? finishedWork,
    String? totalWorkHour,
  })  : _salaryRequestId = salaryRequestId,
        _userId = userId,
        _storeId = storeId,
        _requestDate = requestDate,
        _salaryType = salaryType,
        _userSalary = userSalary,
        _totalSalary = totalSalary,
        _finishedWork = finishedWork,
        _totalWorkHour = totalWorkHour;

  // "salary_request_id" field.
  String? _salaryRequestId;
  String get salaryRequestId => _salaryRequestId ?? '';
  set salaryRequestId(String? val) => _salaryRequestId = val;

  bool hasSalaryRequestId() => _salaryRequestId != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "store_id" field.
  String? _storeId;
  String get storeId => _storeId ?? '';
  set storeId(String? val) => _storeId = val;

  bool hasStoreId() => _storeId != null;

  // "request_date" field.
  String? _requestDate;
  String get requestDate => _requestDate ?? '';
  set requestDate(String? val) => _requestDate = val;

  bool hasRequestDate() => _requestDate != null;

  // "salary_type" field.
  String? _salaryType;
  String get salaryType => _salaryType ?? '';
  set salaryType(String? val) => _salaryType = val;

  bool hasSalaryType() => _salaryType != null;

  // "user_salary" field.
  String? _userSalary;
  String get userSalary => _userSalary ?? '';
  set userSalary(String? val) => _userSalary = val;

  bool hasUserSalary() => _userSalary != null;

  // "total_salary" field.
  String? _totalSalary;
  String get totalSalary => _totalSalary ?? '';
  set totalSalary(String? val) => _totalSalary = val;

  bool hasTotalSalary() => _totalSalary != null;

  // "finished_work" field.
  bool? _finishedWork;
  bool get finishedWork => _finishedWork ?? false;
  set finishedWork(bool? val) => _finishedWork = val;

  bool hasFinishedWork() => _finishedWork != null;

  // "total_work_hour" field.
  String? _totalWorkHour;
  String get totalWorkHour => _totalWorkHour ?? '';
  set totalWorkHour(String? val) => _totalWorkHour = val;

  bool hasTotalWorkHour() => _totalWorkHour != null;

  static VSalaryIndividualStruct fromMap(Map<String, dynamic> data) =>
      VSalaryIndividualStruct(
        salaryRequestId: data['salary_request_id'] as String?,
        userId: data['user_id'] as String?,
        storeId: data['store_id'] as String?,
        requestDate: data['request_date'] as String?,
        salaryType: data['salary_type'] as String?,
        userSalary: data['user_salary'] as String?,
        totalSalary: data['total_salary'] as String?,
        finishedWork: data['finished_work'] as bool?,
        totalWorkHour: data['total_work_hour'] as String?,
      );

  static VSalaryIndividualStruct? maybeFromMap(dynamic data) => data is Map
      ? VSalaryIndividualStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'salary_request_id': _salaryRequestId,
        'user_id': _userId,
        'store_id': _storeId,
        'request_date': _requestDate,
        'salary_type': _salaryType,
        'user_salary': _userSalary,
        'total_salary': _totalSalary,
        'finished_work': _finishedWork,
        'total_work_hour': _totalWorkHour,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'salary_request_id': serializeParam(
          _salaryRequestId,
          ParamType.String,
        ),
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'store_id': serializeParam(
          _storeId,
          ParamType.String,
        ),
        'request_date': serializeParam(
          _requestDate,
          ParamType.String,
        ),
        'salary_type': serializeParam(
          _salaryType,
          ParamType.String,
        ),
        'user_salary': serializeParam(
          _userSalary,
          ParamType.String,
        ),
        'total_salary': serializeParam(
          _totalSalary,
          ParamType.String,
        ),
        'finished_work': serializeParam(
          _finishedWork,
          ParamType.bool,
        ),
        'total_work_hour': serializeParam(
          _totalWorkHour,
          ParamType.String,
        ),
      }.withoutNulls;

  static VSalaryIndividualStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      VSalaryIndividualStruct(
        salaryRequestId: deserializeParam(
          data['salary_request_id'],
          ParamType.String,
          false,
        ),
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        storeId: deserializeParam(
          data['store_id'],
          ParamType.String,
          false,
        ),
        requestDate: deserializeParam(
          data['request_date'],
          ParamType.String,
          false,
        ),
        salaryType: deserializeParam(
          data['salary_type'],
          ParamType.String,
          false,
        ),
        userSalary: deserializeParam(
          data['user_salary'],
          ParamType.String,
          false,
        ),
        totalSalary: deserializeParam(
          data['total_salary'],
          ParamType.String,
          false,
        ),
        finishedWork: deserializeParam(
          data['finished_work'],
          ParamType.bool,
          false,
        ),
        totalWorkHour: deserializeParam(
          data['total_work_hour'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VSalaryIndividualStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VSalaryIndividualStruct &&
        salaryRequestId == other.salaryRequestId &&
        userId == other.userId &&
        storeId == other.storeId &&
        requestDate == other.requestDate &&
        salaryType == other.salaryType &&
        userSalary == other.userSalary &&
        totalSalary == other.totalSalary &&
        finishedWork == other.finishedWork &&
        totalWorkHour == other.totalWorkHour;
  }

  @override
  int get hashCode => const ListEquality().hash([
        salaryRequestId,
        userId,
        storeId,
        requestDate,
        salaryType,
        userSalary,
        totalSalary,
        finishedWork,
        totalWorkHour
      ]);
}

VSalaryIndividualStruct createVSalaryIndividualStruct({
  String? salaryRequestId,
  String? userId,
  String? storeId,
  String? requestDate,
  String? salaryType,
  String? userSalary,
  String? totalSalary,
  bool? finishedWork,
  String? totalWorkHour,
}) =>
    VSalaryIndividualStruct(
      salaryRequestId: salaryRequestId,
      userId: userId,
      storeId: storeId,
      requestDate: requestDate,
      salaryType: salaryType,
      userSalary: userSalary,
      totalSalary: totalSalary,
      finishedWork: finishedWork,
      totalWorkHour: totalWorkHour,
    );
