import '../database.dart';

class VCashLocationTable extends SupabaseTable<VCashLocationRow> {
  @override
  String get tableName => 'v_cash_location';

  @override
  VCashLocationRow createRow(Map<String, dynamic> data) =>
      VCashLocationRow(data);
}

class VCashLocationRow extends SupabaseDataRow {
  VCashLocationRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VCashLocationTable();

  String? get cashLocationId => getField<String>('cash_location_id');
  set cashLocationId(String? value) =>
      setField<String>('cash_location_id', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get locationName => getField<String>('location_name');
  set locationName(String? value) => setField<String>('location_name', value);

  String? get locationType => getField<String>('location_type');
  set locationType(String? value) => setField<String>('location_type', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get locationInfo => getField<String>('location_info');
  set locationInfo(String? value) => setField<String>('location_info', value);

  double? get totalJournalCashAmount =>
      getField<double>('total_journal_cash_amount');
  set totalJournalCashAmount(double? value) =>
      setField<double>('total_journal_cash_amount', value);

  double? get totalRealCashAmount => getField<double>('total_real_cash_amount');
  set totalRealCashAmount(double? value) =>
      setField<double>('total_real_cash_amount', value);

  double? get cashDifference => getField<double>('cash_difference');
  set cashDifference(double? value) =>
      setField<double>('cash_difference', value);
}
