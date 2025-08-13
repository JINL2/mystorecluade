import '../database.dart';

class VDepreciationSummaryTable extends SupabaseTable<VDepreciationSummaryRow> {
  @override
  String get tableName => 'v_depreciation_summary';

  @override
  VDepreciationSummaryRow createRow(Map<String, dynamic> data) =>
      VDepreciationSummaryRow(data);
}

class VDepreciationSummaryRow extends SupabaseDataRow {
  VDepreciationSummaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VDepreciationSummaryTable();

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get assetId => getField<String>('asset_id');
  set assetId(String? value) => setField<String>('asset_id', value);

  String? get assetName => getField<String>('asset_name');
  set assetName(String? value) => setField<String>('asset_name', value);

  double? get acquisitionCost => getField<double>('acquisition_cost');
  set acquisitionCost(double? value) =>
      setField<double>('acquisition_cost', value);

  double? get salvageValue => getField<double>('salvage_value');
  set salvageValue(double? value) => setField<double>('salvage_value', value);

  int? get usefulLifeYears => getField<int>('useful_life_years');
  set usefulLifeYears(int? value) => setField<int>('useful_life_years', value);

  DateTime? get acquisitionDate => getField<DateTime>('acquisition_date');
  set acquisitionDate(DateTime? value) =>
      setField<DateTime>('acquisition_date', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  double? get accumulatedDepreciation =>
      getField<double>('accumulated_depreciation');
  set accumulatedDepreciation(double? value) =>
      setField<double>('accumulated_depreciation', value);

  int? get depreciationCount => getField<int>('depreciation_count');
  set depreciationCount(int? value) =>
      setField<int>('depreciation_count', value);

  DateTime? get lastDepreciationDate =>
      getField<DateTime>('last_depreciation_date');
  set lastDepreciationDate(DateTime? value) =>
      setField<DateTime>('last_depreciation_date', value);

  String? get companyName => getField<String>('company_name');
  set companyName(String? value) => setField<String>('company_name', value);

  double? get depreciableAmount => getField<double>('depreciable_amount');
  set depreciableAmount(double? value) =>
      setField<double>('depreciable_amount', value);

  double? get bookValue => getField<double>('book_value');
  set bookValue(double? value) => setField<double>('book_value', value);

  String? get depreciationStatus => getField<String>('depreciation_status');
  set depreciationStatus(String? value) =>
      setField<String>('depreciation_status', value);

  double? get depreciationRatePercent =>
      getField<double>('depreciation_rate_percent');
  set depreciationRatePercent(double? value) =>
      setField<double>('depreciation_rate_percent', value);
}
