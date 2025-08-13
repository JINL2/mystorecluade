import '../database.dart';

class UserSalariesTable extends SupabaseTable<UserSalariesRow> {
  @override
  String get tableName => 'user_salaries';

  @override
  UserSalariesRow createRow(Map<String, dynamic> data) => UserSalariesRow(data);
}

class UserSalariesRow extends SupabaseDataRow {
  UserSalariesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserSalariesTable();

  String get salaryId => getField<String>('salary_id')!;
  set salaryId(String value) => setField<String>('salary_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  double get salaryAmount => getField<double>('salary_amount')!;
  set salaryAmount(double value) => setField<double>('salary_amount', value);

  String get salaryType => getField<String>('salary_type')!;
  set salaryType(String value) => setField<String>('salary_type', value);

  double? get bonusAmount => getField<double>('bonus_amount');
  set bonusAmount(double? value) => setField<double>('bonus_amount', value);

  String get accountId => getField<String>('account_id')!;
  set accountId(String value) => setField<String>('account_id', value);

  String? get editedBy => getField<String>('edited_by');
  set editedBy(String? value) => setField<String>('edited_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get currencyId => getField<String>('currency_id');
  set currencyId(String? value) => setField<String>('currency_id', value);
}
