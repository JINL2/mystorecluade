import '../database.dart';

class VShiftRequestWithRealtimeProblemTable
    extends SupabaseTable<VShiftRequestWithRealtimeProblemRow> {
  @override
  String get tableName => 'v_shift_request_with_realtime_problem';

  @override
  VShiftRequestWithRealtimeProblemRow createRow(Map<String, dynamic> data) =>
      VShiftRequestWithRealtimeProblemRow(data);
}

class VShiftRequestWithRealtimeProblemRow extends SupabaseDataRow {
  VShiftRequestWithRealtimeProblemRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VShiftRequestWithRealtimeProblemTable();

  String? get shiftRequestId => getField<String>('shift_request_id');
  set shiftRequestId(String? value) =>
      setField<String>('shift_request_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get shiftId => getField<String>('shift_id');
  set shiftId(String? value) => setField<String>('shift_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  DateTime? get requestDate => getField<DateTime>('request_date');
  set requestDate(DateTime? value) => setField<DateTime>('request_date', value);

  bool? get isApproved => getField<bool>('is_approved');
  set isApproved(bool? value) => setField<bool>('is_approved', value);

  String? get approvedBy => getField<String>('approved_by');
  set approvedBy(String? value) => setField<String>('approved_by', value);

  DateTime? get actualStartTime => getField<DateTime>('actual_start_time');
  set actualStartTime(DateTime? value) =>
      setField<DateTime>('actual_start_time', value);

  DateTime? get actualEndTime => getField<DateTime>('actual_end_time');
  set actualEndTime(DateTime? value) =>
      setField<DateTime>('actual_end_time', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get startTime => getField<DateTime>('start_time');
  set startTime(DateTime? value) => setField<DateTime>('start_time', value);

  DateTime? get endTime => getField<DateTime>('end_time');
  set endTime(DateTime? value) => setField<DateTime>('end_time', value);

  bool? get isLate => getField<bool>('is_late');
  set isLate(bool? value) => setField<bool>('is_late', value);

  bool? get isExtratime => getField<bool>('is_extratime');
  set isExtratime(bool? value) => setField<bool>('is_extratime', value);

  double? get overtimeAmount => getField<double>('overtime_amount');
  set overtimeAmount(double? value) =>
      setField<double>('overtime_amount', value);

  String? get checkinLocation => getField<String>('checkin_location');
  set checkinLocation(String? value) =>
      setField<String>('checkin_location', value);

  double? get checkinDistanceFromStore =>
      getField<double>('checkin_distance_from_store');
  set checkinDistanceFromStore(double? value) =>
      setField<double>('checkin_distance_from_store', value);

  bool? get isValidCheckinLocation =>
      getField<bool>('is_valid_checkin_location');
  set isValidCheckinLocation(bool? value) =>
      setField<bool>('is_valid_checkin_location', value);

  String? get checkoutLocation => getField<String>('checkout_location');
  set checkoutLocation(String? value) =>
      setField<String>('checkout_location', value);

  double? get checkoutDistanceFromStore =>
      getField<double>('checkout_distance_from_store');
  set checkoutDistanceFromStore(double? value) =>
      setField<double>('checkout_distance_from_store', value);

  bool? get isValidCheckoutLocation =>
      getField<bool>('is_valid_checkout_location');
  set isValidCheckoutLocation(bool? value) =>
      setField<bool>('is_valid_checkout_location', value);

  double? get lateDeducutAmount => getField<double>('late_deducut_amount');
  set lateDeducutAmount(double? value) =>
      setField<double>('late_deducut_amount', value);

  double? get bonusAmount => getField<double>('bonus_amount');
  set bonusAmount(double? value) => setField<double>('bonus_amount', value);

  DateTime? get confirmStartTime => getField<DateTime>('confirm_start_time');
  set confirmStartTime(DateTime? value) =>
      setField<DateTime>('confirm_start_time', value);

  DateTime? get confirmEndTime => getField<DateTime>('confirm_end_time');
  set confirmEndTime(DateTime? value) =>
      setField<DateTime>('confirm_end_time', value);

  dynamic get noticeTag => getField<dynamic>('notice_tag');
  set noticeTag(dynamic value) => setField<dynamic>('notice_tag', value);

  bool? get isReported => getField<bool>('is_reported');
  set isReported(bool? value) => setField<bool>('is_reported', value);

  DateTime? get reportTime => getField<DateTime>('report_time');
  set reportTime(DateTime? value) => setField<DateTime>('report_time', value);

  String? get reportType => getField<String>('report_type');
  set reportType(String? value) => setField<String>('report_type', value);

  bool? get isProblem => getField<bool>('is_problem');
  set isProblem(bool? value) => setField<bool>('is_problem', value);

  bool? get realtimeIsProblem => getField<bool>('realtime_is_problem');
  set realtimeIsProblem(bool? value) =>
      setField<bool>('realtime_is_problem', value);

  String? get problemType => getField<String>('problem_type');
  set problemType(String? value) => setField<String>('problem_type', value);
}
