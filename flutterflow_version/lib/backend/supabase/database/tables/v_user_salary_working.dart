import '../database.dart';

class VUserSalaryWorkingTable extends SupabaseTable<VUserSalaryWorkingRow> {
  @override
  String get tableName => 'v_user_salary_working';

  @override
  VUserSalaryWorkingRow createRow(Map<String, dynamic> data) =>
      VUserSalaryWorkingRow(data);
}

class VUserSalaryWorkingRow extends SupabaseDataRow {
  VUserSalaryWorkingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VUserSalaryWorkingTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get month => getField<String>('month');
  set month(String? value) => setField<String>('month', value);

  int? get totalWorkingDay => getField<int>('total_working_day');
  set totalWorkingDay(int? value) => setField<int>('total_working_day', value);

  double? get totalWorkingHour => getField<double>('total_working_hour');
  set totalWorkingHour(double? value) =>
      setField<double>('total_working_hour', value);

  double? get totalSalary => getField<double>('total_salary');
  set totalSalary(double? value) => setField<double>('total_salary', value);

  String? get salaryType => getField<String>('salary_type');
  set salaryType(String? value) => setField<String>('salary_type', value);

  String? get currencyId => getField<String>('currency_id');
  set currencyId(String? value) => setField<String>('currency_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);
}
