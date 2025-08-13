import '../database.dart';

class AssetImpairmentsTable extends SupabaseTable<AssetImpairmentsRow> {
  @override
  String get tableName => 'asset_impairments';

  @override
  AssetImpairmentsRow createRow(Map<String, dynamic> data) =>
      AssetImpairmentsRow(data);
}

class AssetImpairmentsRow extends SupabaseDataRow {
  AssetImpairmentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AssetImpairmentsTable();

  String get impairmentId => getField<String>('impairment_id')!;
  set impairmentId(String value) => setField<String>('impairment_id', value);

  String get assetId => getField<String>('asset_id')!;
  set assetId(String value) => setField<String>('asset_id', value);

  DateTime get impairmentDate => getField<DateTime>('impairment_date')!;
  set impairmentDate(DateTime value) =>
      setField<DateTime>('impairment_date', value);

  double get impairedValue => getField<double>('impaired_value')!;
  set impairedValue(double value) => setField<double>('impaired_value', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  String? get journalId => getField<String>('journal_id');
  set journalId(String? value) => setField<String>('journal_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
