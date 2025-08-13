import '../database.dart';

class VStoreShiftsTable extends SupabaseTable<VStoreShiftsRow> {
  @override
  String get tableName => 'v_store_shifts';

  @override
  VStoreShiftsRow createRow(Map<String, dynamic> data) => VStoreShiftsRow(data);
}

class VStoreShiftsRow extends SupabaseDataRow {
  VStoreShiftsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VStoreShiftsTable();

  String? get shiftId => getField<String>('shift_id');
  set shiftId(String? value) => setField<String>('shift_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get shiftName => getField<String>('shift_name');
  set shiftName(String? value) => setField<String>('shift_name', value);

  PostgresTime? get startTime => getField<PostgresTime>('start_time');
  set startTime(PostgresTime? value) =>
      setField<PostgresTime>('start_time', value);

  PostgresTime? get endTime => getField<PostgresTime>('end_time');
  set endTime(PostgresTime? value) => setField<PostgresTime>('end_time', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get isCanOvertime => getField<bool>('is_can_overtime');
  set isCanOvertime(bool? value) => setField<bool>('is_can_overtime', value);

  int? get orderNumber => getField<int>('order_number');
  set orderNumber(int? value) => setField<int>('order_number', value);
}
