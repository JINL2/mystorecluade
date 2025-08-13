import '../database.dart';

class CompanyTypesTable extends SupabaseTable<CompanyTypesRow> {
  @override
  String get tableName => 'company_types';

  @override
  CompanyTypesRow createRow(Map<String, dynamic> data) => CompanyTypesRow(data);
}

class CompanyTypesRow extends SupabaseDataRow {
  CompanyTypesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CompanyTypesTable();

  String get companyTypeId => getField<String>('company_type_id')!;
  set companyTypeId(String value) => setField<String>('company_type_id', value);

  String? get typeName => getField<String>('type_name');
  set typeName(String? value) => setField<String>('type_name', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
