import '../database.dart';

class VDepreciationProcessStatusTable
    extends SupabaseTable<VDepreciationProcessStatusRow> {
  @override
  String get tableName => 'v_depreciation_process_status';

  @override
  VDepreciationProcessStatusRow createRow(Map<String, dynamic> data) =>
      VDepreciationProcessStatusRow(data);
}

class VDepreciationProcessStatusRow extends SupabaseDataRow {
  VDepreciationProcessStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VDepreciationProcessStatusTable();

  DateTime? get processDate => getField<DateTime>('process_date');
  set processDate(DateTime? value) => setField<DateTime>('process_date', value);

  String? get companyName => getField<String>('company_name');
  set companyName(String? value) => setField<String>('company_name', value);

  int? get assetCount => getField<int>('asset_count');
  set assetCount(int? value) => setField<int>('asset_count', value);

  double? get totalAmount => getField<double>('total_amount');
  set totalAmount(double? value) => setField<double>('total_amount', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
