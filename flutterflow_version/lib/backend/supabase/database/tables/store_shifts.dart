import '../database.dart';

class StoreShiftsTable extends SupabaseTable<StoreShiftsRow> {
  @override
  String get tableName => 'store_shifts';

  @override
  StoreShiftsRow createRow(Map<String, dynamic> data) => StoreShiftsRow(data);
}

class StoreShiftsRow extends SupabaseDataRow {
  StoreShiftsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StoreShiftsTable();

  String get shiftId => getField<String>('shift_id')!;
  set shiftId(String value) => setField<String>('shift_id', value);

  String get storeId => getField<String>('store_id')!;
  set storeId(String value) => setField<String>('store_id', value);

  String get shiftName => getField<String>('shift_name')!;
  set shiftName(String value) => setField<String>('shift_name', value);

  PostgresTime get startTime => getField<PostgresTime>('start_time')!;
  set startTime(PostgresTime value) =>
      setField<PostgresTime>('start_time', value);

  PostgresTime get endTime => getField<PostgresTime>('end_time')!;
  set endTime(PostgresTime value) => setField<PostgresTime>('end_time', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get numberShift => getField<int>('number_shift');
  set numberShift(int? value) => setField<int>('number_shift', value);

  bool get isCanOvertime => getField<bool>('is_can_overtime')!;
  set isCanOvertime(bool value) => setField<bool>('is_can_overtime', value);
}
