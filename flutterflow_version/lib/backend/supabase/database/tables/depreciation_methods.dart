import '../database.dart';

class DepreciationMethodsTable extends SupabaseTable<DepreciationMethodsRow> {
  @override
  String get tableName => 'depreciation_methods';

  @override
  DepreciationMethodsRow createRow(Map<String, dynamic> data) =>
      DepreciationMethodsRow(data);
}

class DepreciationMethodsRow extends SupabaseDataRow {
  DepreciationMethodsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DepreciationMethodsTable();

  String get methodId => getField<String>('method_id')!;
  set methodId(String value) => setField<String>('method_id', value);

  String get methodName => getField<String>('method_name')!;
  set methodName(String value) => setField<String>('method_name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get formula => getField<String>('formula');
  set formula(String? value) => setField<String>('formula', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
