import '../database.dart';

class FixedAssetsTable extends SupabaseTable<FixedAssetsRow> {
  @override
  String get tableName => 'fixed_assets';

  @override
  FixedAssetsRow createRow(Map<String, dynamic> data) => FixedAssetsRow(data);
}

class FixedAssetsRow extends SupabaseDataRow {
  FixedAssetsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FixedAssetsTable();

  String get assetId => getField<String>('asset_id')!;
  set assetId(String value) => setField<String>('asset_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String get accountId => getField<String>('account_id')!;
  set accountId(String value) => setField<String>('account_id', value);

  String get assetName => getField<String>('asset_name')!;
  set assetName(String value) => setField<String>('asset_name', value);

  DateTime get acquisitionDate => getField<DateTime>('acquisition_date')!;
  set acquisitionDate(DateTime value) =>
      setField<DateTime>('acquisition_date', value);

  double get acquisitionCost => getField<double>('acquisition_cost')!;
  set acquisitionCost(double value) =>
      setField<double>('acquisition_cost', value);

  int get usefulLifeYears => getField<int>('useful_life_years')!;
  set usefulLifeYears(int value) => setField<int>('useful_life_years', value);

  double? get salvageValue => getField<double>('salvage_value');
  set salvageValue(double? value) => setField<double>('salvage_value', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get relatedJournalLineId =>
      getField<String>('related_journal_line_id');
  set relatedJournalLineId(String? value) =>
      setField<String>('related_journal_line_id', value);

  double? get impairedValue => getField<double>('impaired_value');
  set impairedValue(double? value) => setField<double>('impaired_value', value);

  DateTime? get impairedAt => getField<DateTime>('impaired_at');
  set impairedAt(DateTime? value) => setField<DateTime>('impaired_at', value);

  String? get impairmentReason => getField<String>('impairment_reason');
  set impairmentReason(String? value) =>
      setField<String>('impairment_reason', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get depreciationMethodId =>
      getField<String>('depreciation_method_id');
  set depreciationMethodId(String? value) =>
      setField<String>('depreciation_method_id', value);
}
