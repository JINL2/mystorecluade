import '../database.dart';

class VIncomeStatementByStoreTable
    extends SupabaseTable<VIncomeStatementByStoreRow> {
  @override
  String get tableName => 'v_income_statement_by_store';

  @override
  VIncomeStatementByStoreRow createRow(Map<String, dynamic> data) =>
      VIncomeStatementByStoreRow(data);
}

class VIncomeStatementByStoreRow extends SupabaseDataRow {
  VIncomeStatementByStoreRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VIncomeStatementByStoreTable();

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get storeName => getField<String>('store_name');
  set storeName(String? value) => setField<String>('store_name', value);

  String? get accountType => getField<String>('account_type');
  set accountType(String? value) => setField<String>('account_type', value);

  String? get accountName => getField<String>('account_name');
  set accountName(String? value) => setField<String>('account_name', value);

  double? get amount => getField<double>('amount');
  set amount(double? value) => setField<double>('amount', value);
}
