import '../database.dart';

class AccountMappingsTable extends SupabaseTable<AccountMappingsRow> {
  @override
  String get tableName => 'account_mappings';

  @override
  AccountMappingsRow createRow(Map<String, dynamic> data) =>
      AccountMappingsRow(data);
}

class AccountMappingsRow extends SupabaseDataRow {
  AccountMappingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AccountMappingsTable();

  String get mappingId => getField<String>('mapping_id')!;
  set mappingId(String value) => setField<String>('mapping_id', value);

  String get myCompanyId => getField<String>('my_company_id')!;
  set myCompanyId(String value) => setField<String>('my_company_id', value);

  String get myAccountId => getField<String>('my_account_id')!;
  set myAccountId(String value) => setField<String>('my_account_id', value);

  String get counterpartyId => getField<String>('counterparty_id')!;
  set counterpartyId(String value) =>
      setField<String>('counterparty_id', value);

  String get linkedAccountId => getField<String>('linked_account_id')!;
  set linkedAccountId(String value) =>
      setField<String>('linked_account_id', value);

  String get direction => getField<String>('direction')!;
  set direction(String value) => setField<String>('direction', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
