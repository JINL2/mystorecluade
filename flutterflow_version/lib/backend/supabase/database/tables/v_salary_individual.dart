import '../database.dart';

class VSalaryIndividualTable extends SupabaseTable<VSalaryIndividualRow> {
  @override
  String get tableName => 'v_salary_individual';

  @override
  VSalaryIndividualRow createRow(Map<String, dynamic> data) =>
      VSalaryIndividualRow(data);
}

class VSalaryIndividualRow extends SupabaseDataRow {
  VSalaryIndividualRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VSalaryIndividualTable();

  String? get salaryRequestId => getField<String>('salary_request_id');
  set salaryRequestId(String? value) =>
      setField<String>('salary_request_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  DateTime? get requestDate => getField<DateTime>('request_date');
  set requestDate(DateTime? value) => setField<DateTime>('request_date', value);

  String? get salaryType => getField<String>('salary_type');
  set salaryType(String? value) => setField<String>('salary_type', value);

  double? get userSalary => getField<double>('user_salary');
  set userSalary(double? value) => setField<double>('user_salary', value);

  double? get totalSalary => getField<double>('total_salary');
  set totalSalary(double? value) => setField<double>('total_salary', value);

  double? get totalWorkHour => getField<double>('total_work_hour');
  set totalWorkHour(double? value) =>
      setField<double>('total_work_hour', value);

  bool? get finishedWork => getField<bool>('finished_work');
  set finishedWork(bool? value) => setField<bool>('finished_work', value);
}
