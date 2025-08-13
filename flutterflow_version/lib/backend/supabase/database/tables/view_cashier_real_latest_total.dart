import '../database.dart';

class ViewCashierRealLatestTotalTable
    extends SupabaseTable<ViewCashierRealLatestTotalRow> {
  @override
  String get tableName => 'view_cashier_real_latest_total';

  @override
  ViewCashierRealLatestTotalRow createRow(Map<String, dynamic> data) =>
      ViewCashierRealLatestTotalRow(data);
}

class ViewCashierRealLatestTotalRow extends SupabaseDataRow {
  ViewCashierRealLatestTotalRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewCashierRealLatestTotalTable();

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get locationId => getField<String>('location_id');
  set locationId(String? value) => setField<String>('location_id', value);

  DateTime? get recordDate => getField<DateTime>('record_date');
  set recordDate(DateTime? value) => setField<DateTime>('record_date', value);

  double? get totalRealAmountConverted =>
      getField<double>('total_real_amount_converted');
  set totalRealAmountConverted(double? value) =>
      setField<double>('total_real_amount_converted', value);
}
