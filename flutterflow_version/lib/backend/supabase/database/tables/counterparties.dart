import '../database.dart';

class CounterpartiesTable extends SupabaseTable<CounterpartiesRow> {
  @override
  String get tableName => 'counterparties';

  @override
  CounterpartiesRow createRow(Map<String, dynamic> data) =>
      CounterpartiesRow(data);
}

class CounterpartiesRow extends SupabaseDataRow {
  CounterpartiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CounterpartiesTable();

  String get counterpartyId => getField<String>('counterparty_id')!;
  set counterpartyId(String value) =>
      setField<String>('counterparty_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool get isDeleted => getField<bool>('is_deleted')!;
  set isDeleted(bool value) => setField<bool>('is_deleted', value);

  bool get isInternal => getField<bool>('is_internal')!;
  set isInternal(bool value) => setField<bool>('is_internal', value);

  String? get linkedCompanyId => getField<String>('linked_company_id');
  set linkedCompanyId(String? value) =>
      setField<String>('linked_company_id', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);
}
