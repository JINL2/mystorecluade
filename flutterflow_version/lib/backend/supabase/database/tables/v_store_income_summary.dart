import '../database.dart';

class VStoreIncomeSummaryTable extends SupabaseTable<VStoreIncomeSummaryRow> {
  @override
  String get tableName => 'v_store_income_summary';

  @override
  VStoreIncomeSummaryRow createRow(Map<String, dynamic> data) =>
      VStoreIncomeSummaryRow(data);
}

class VStoreIncomeSummaryRow extends SupabaseDataRow {
  VStoreIncomeSummaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VStoreIncomeSummaryTable();

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get storeName => getField<String>('store_name');
  set storeName(String? value) => setField<String>('store_name', value);

  double? get totalIncome => getField<double>('total_income');
  set totalIncome(double? value) => setField<double>('total_income', value);

  double? get totalExpense => getField<double>('total_expense');
  set totalExpense(double? value) => setField<double>('total_expense', value);

  double? get netIncome => getField<double>('net_income');
  set netIncome(double? value) => setField<double>('net_income', value);
}
