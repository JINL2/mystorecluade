import '../database.dart';

class VShiftRequestTable extends SupabaseTable<VShiftRequestRow> {
  @override
  String get tableName => 'v_shift_request';

  @override
  VShiftRequestRow createRow(Map<String, dynamic> data) =>
      VShiftRequestRow(data);
}

class VShiftRequestRow extends SupabaseDataRow {
  VShiftRequestRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VShiftRequestTable();

  String? get shiftRequestId => getField<String>('shift_request_id');
  set shiftRequestId(String? value) =>
      setField<String>('shift_request_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  String? get userName => getField<String>('user_name');
  set userName(String? value) => setField<String>('user_name', value);

  String? get userEmail => getField<String>('user_email');
  set userEmail(String? value) => setField<String>('user_email', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get storeName => getField<String>('store_name');
  set storeName(String? value) => setField<String>('store_name', value);

  String? get storeCode => getField<String>('store_code');
  set storeCode(String? value) => setField<String>('store_code', value);

  DateTime? get requestDate => getField<DateTime>('request_date');
  set requestDate(DateTime? value) => setField<DateTime>('request_date', value);

  String? get shiftId => getField<String>('shift_id');
  set shiftId(String? value) => setField<String>('shift_id', value);

  String? get shiftName => getField<String>('shift_name');
  set shiftName(String? value) => setField<String>('shift_name', value);

  int? get orderNumber => getField<int>('order_number');
  set orderNumber(int? value) => setField<int>('order_number', value);

  bool? get isCanOvertime => getField<bool>('is_can_overtime');
  set isCanOvertime(bool? value) => setField<bool>('is_can_overtime', value);

  DateTime? get startTime => getField<DateTime>('start_time');
  set startTime(DateTime? value) => setField<DateTime>('start_time', value);

  DateTime? get endTime => getField<DateTime>('end_time');
  set endTime(DateTime? value) => setField<DateTime>('end_time', value);

  double? get scheduledHours => getField<double>('scheduled_hours');
  set scheduledHours(double? value) =>
      setField<double>('scheduled_hours', value);

  DateTime? get actualStartTime => getField<DateTime>('actual_start_time');
  set actualStartTime(DateTime? value) =>
      setField<DateTime>('actual_start_time', value);

  DateTime? get actualEndTime => getField<DateTime>('actual_end_time');
  set actualEndTime(DateTime? value) =>
      setField<DateTime>('actual_end_time', value);

  double? get actualWorkedHours => getField<double>('actual_worked_hours');
  set actualWorkedHours(double? value) =>
      setField<double>('actual_worked_hours', value);

  DateTime? get originalConfirmStartTime =>
      getField<DateTime>('original_confirm_start_time');
  set originalConfirmStartTime(DateTime? value) =>
      setField<DateTime>('original_confirm_start_time', value);

  DateTime? get originalConfirmEndTime =>
      getField<DateTime>('original_confirm_end_time');
  set originalConfirmEndTime(DateTime? value) =>
      setField<DateTime>('original_confirm_end_time', value);

  DateTime? get confirmStartTime => getField<DateTime>('confirm_start_time');
  set confirmStartTime(DateTime? value) =>
      setField<DateTime>('confirm_start_time', value);

  DateTime? get confirmEndTime => getField<DateTime>('confirm_end_time');
  set confirmEndTime(DateTime? value) =>
      setField<DateTime>('confirm_end_time', value);

  double? get paidHours => getField<double>('paid_hours');
  set paidHours(double? value) => setField<double>('paid_hours', value);

  bool? get isLate => getField<bool>('is_late');
  set isLate(bool? value) => setField<bool>('is_late', value);

  double? get lateMinutes => getField<double>('late_minutes');
  set lateMinutes(double? value) => setField<double>('late_minutes', value);

  double? get lateDeducutAmount => getField<double>('late_deducut_amount');
  set lateDeducutAmount(double? value) =>
      setField<double>('late_deducut_amount', value);

  bool? get isExtratime => getField<bool>('is_extratime');
  set isExtratime(bool? value) => setField<bool>('is_extratime', value);

  double? get overtimeMinutes => getField<double>('overtime_minutes');
  set overtimeMinutes(double? value) =>
      setField<double>('overtime_minutes', value);

  double? get overtimeAmount => getField<double>('overtime_amount');
  set overtimeAmount(double? value) =>
      setField<double>('overtime_amount', value);

  String? get salaryType => getField<String>('salary_type');
  set salaryType(String? value) => setField<String>('salary_type', value);

  double? get salaryAmount => getField<double>('salary_amount');
  set salaryAmount(double? value) => setField<double>('salary_amount', value);

  double? get totalSalaryPay => getField<double>('total_salary_pay');
  set totalSalaryPay(double? value) =>
      setField<double>('total_salary_pay', value);

  double? get bonusAmount => getField<double>('bonus_amount');
  set bonusAmount(double? value) => setField<double>('bonus_amount', value);

  double? get totalPayWithBonus => getField<double>('total_pay_with_bonus');
  set totalPayWithBonus(double? value) =>
      setField<double>('total_pay_with_bonus', value);

  double? get lateDeductionKrw => getField<double>('late_deduction_krw');
  set lateDeductionKrw(double? value) =>
      setField<double>('late_deduction_krw', value);

  bool? get isApproved => getField<bool>('is_approved');
  set isApproved(bool? value) => setField<bool>('is_approved', value);

  String? get approvedBy => getField<String>('approved_by');
  set approvedBy(String? value) => setField<String>('approved_by', value);

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

  int? get allowedDistance => getField<int>('allowed_distance');
  set allowedDistance(int? value) => setField<int>('allowed_distance', value);

  int? get huddleTime => getField<int>('huddle_time');
  set huddleTime(int? value) => setField<int>('huddle_time', value);

  int? get paymentTime => getField<int>('payment_time');
  set paymentTime(int? value) => setField<int>('payment_time', value);

  dynamic get noticeTag => getField<dynamic>('notice_tag');
  set noticeTag(dynamic value) => setField<dynamic>('notice_tag', value);

  bool? get isReported => getField<bool>('is_reported');
  set isReported(bool? value) => setField<bool>('is_reported', value);

  DateTime? get reportTime => getField<DateTime>('report_time');
  set reportTime(DateTime? value) => setField<DateTime>('report_time', value);

  String? get problemType => getField<String>('problem_type');
  set problemType(String? value) => setField<String>('problem_type', value);

  bool? get isProblem => getField<bool>('is_problem');
  set isProblem(bool? value) => setField<bool>('is_problem', value);

  bool? get isProblemSolved => getField<bool>('is_problem_solved');
  set isProblemSolved(bool? value) =>
      setField<bool>('is_problem_solved', value);

  bool? get hasUnsolvedProblem => getField<bool>('has_unsolved_problem');
  set hasUnsolvedProblem(bool? value) =>
      setField<bool>('has_unsolved_problem', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
