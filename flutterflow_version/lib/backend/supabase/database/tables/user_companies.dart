import '../database.dart';

class UserCompaniesTable extends SupabaseTable<UserCompaniesRow> {
  @override
  String get tableName => 'user_companies';

  @override
  UserCompaniesRow createRow(Map<String, dynamic> data) =>
      UserCompaniesRow(data);
}

class UserCompaniesRow extends SupabaseDataRow {
  UserCompaniesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserCompaniesTable();

  String get userCompanyId => getField<String>('user_company_id')!;
  set userCompanyId(String value) => setField<String>('user_company_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get isDeleted => getField<bool>('is_deleted');
  set isDeleted(bool? value) => setField<bool>('is_deleted', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}
