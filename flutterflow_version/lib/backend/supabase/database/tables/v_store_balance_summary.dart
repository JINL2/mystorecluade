import '../database.dart';

class VStoreBalanceSummaryTable extends SupabaseTable<VStoreBalanceSummaryRow> {
  @override
  String get tableName => 'v_store_balance_summary';

  @override
  VStoreBalanceSummaryRow createRow(Map<String, dynamic> data) =>
      VStoreBalanceSummaryRow(data);
}

class VStoreBalanceSummaryRow extends SupabaseDataRow {
  VStoreBalanceSummaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VStoreBalanceSummaryTable();

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get storeName => getField<String>('store_name');
  set storeName(String? value) => setField<String>('store_name', value);

  double? get totalDebit => getField<double>('total_debit');
  set totalDebit(double? value) => setField<double>('total_debit', value);

  double? get totalCredit => getField<double>('total_credit');
  set totalCredit(double? value) => setField<double>('total_credit', value);

  double? get balanceDifference => getField<double>('balance_difference');
  set balanceDifference(double? value) =>
      setField<double>('balance_difference', value);
}
