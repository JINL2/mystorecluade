import '../database.dart';

class VUserSalaryTable extends SupabaseTable<VUserSalaryRow> {
  @override
  String get tableName => 'v_user_salary';

  @override
  VUserSalaryRow createRow(Map<String, dynamic> data) => VUserSalaryRow(data);
}

class VUserSalaryRow extends SupabaseDataRow {
  VUserSalaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VUserSalaryTable();

  String? get salaryId => getField<String>('salary_id');
  set salaryId(String? value) => setField<String>('salary_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get profileImage => getField<String>('profile_image');
  set profileImage(String? value) => setField<String>('profile_image', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  double? get salaryAmount => getField<double>('salary_amount');
  set salaryAmount(double? value) => setField<double>('salary_amount', value);

  String? get salaryType => getField<String>('salary_type');
  set salaryType(String? value) => setField<String>('salary_type', value);

  double? get bonusAmount => getField<double>('bonus_amount');
  set bonusAmount(double? value) => setField<double>('bonus_amount', value);

  String? get roleId => getField<String>('role_id');
  set roleId(String? value) => setField<String>('role_id', value);

  String? get roleName => getField<String>('role_name');
  set roleName(String? value) => setField<String>('role_name', value);

  String? get currencyName => getField<String>('currency_name');
  set currencyName(String? value) => setField<String>('currency_name', value);

  String? get currencyCode => getField<String>('currency_code');
  set currencyCode(String? value) => setField<String>('currency_code', value);

  String? get symbol => getField<String>('symbol');
  set symbol(String? value) => setField<String>('symbol', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
