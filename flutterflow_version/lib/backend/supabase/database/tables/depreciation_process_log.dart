import '../database.dart';

class DepreciationProcessLogTable
    extends SupabaseTable<DepreciationProcessLogRow> {
  @override
  String get tableName => 'depreciation_process_log';

  @override
  DepreciationProcessLogRow createRow(Map<String, dynamic> data) =>
      DepreciationProcessLogRow(data);
}

class DepreciationProcessLogRow extends SupabaseDataRow {
  DepreciationProcessLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DepreciationProcessLogTable();

  String get logId => getField<String>('log_id')!;
  set logId(String value) => setField<String>('log_id', value);

  DateTime get processDate => getField<DateTime>('process_date')!;
  set processDate(DateTime value) => setField<DateTime>('process_date', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  int? get assetCount => getField<int>('asset_count');
  set assetCount(int? value) => setField<int>('asset_count', value);

  double? get totalAmount => getField<double>('total_amount');
  set totalAmount(double? value) => setField<double>('total_amount', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
