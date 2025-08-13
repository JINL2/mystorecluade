import '../database.dart';

class VMonthlyDepreciationSummaryTable
    extends SupabaseTable<VMonthlyDepreciationSummaryRow> {
  @override
  String get tableName => 'v_monthly_depreciation_summary';

  @override
  VMonthlyDepreciationSummaryRow createRow(Map<String, dynamic> data) =>
      VMonthlyDepreciationSummaryRow(data);
}

class VMonthlyDepreciationSummaryRow extends SupabaseDataRow {
  VMonthlyDepreciationSummaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VMonthlyDepreciationSummaryTable();

  DateTime? get month => getField<DateTime>('month');
  set month(DateTime? value) => setField<DateTime>('month', value);

  String? get companyName => getField<String>('company_name');
  set companyName(String? value) => setField<String>('company_name', value);

  int? get assetCount => getField<int>('asset_count');
  set assetCount(int? value) => setField<int>('asset_count', value);

  double? get totalDepreciation => getField<double>('total_depreciation');
  set totalDepreciation(double? value) =>
      setField<double>('total_depreciation', value);
}
