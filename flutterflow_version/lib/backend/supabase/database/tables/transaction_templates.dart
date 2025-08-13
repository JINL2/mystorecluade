import '../database.dart';

class TransactionTemplatesTable extends SupabaseTable<TransactionTemplatesRow> {
  @override
  String get tableName => 'transaction_templates';

  @override
  TransactionTemplatesRow createRow(Map<String, dynamic> data) =>
      TransactionTemplatesRow(data);
}

class TransactionTemplatesRow extends SupabaseDataRow {
  TransactionTemplatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TransactionTemplatesTable();

  String get templateId => getField<String>('template_id')!;
  set templateId(String value) => setField<String>('template_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  dynamic get dataField => getField<dynamic>('data')!;
  set dataField(dynamic value) => setField<dynamic>('data', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);
}
