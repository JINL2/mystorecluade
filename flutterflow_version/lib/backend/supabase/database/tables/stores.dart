import '../database.dart';

class StoresTable extends SupabaseTable<StoresRow> {
  @override
  String get tableName => 'stores';

  @override
  StoresRow createRow(Map<String, dynamic> data) => StoresRow(data);
}

class StoresRow extends SupabaseDataRow {
  StoresRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StoresTable();

  String get storeId => getField<String>('store_id')!;
  set storeId(String value) => setField<String>('store_id', value);

  String? get storeName => getField<String>('store_name');
  set storeName(String? value) => setField<String>('store_name', value);

  String? get storeCode => getField<String>('store_code');
  set storeCode(String? value) => setField<String>('store_code', value);

  String? get storeAddress => getField<String>('store_address');
  set storeAddress(String? value) => setField<String>('store_address', value);

  String? get storePhone => getField<String>('store_phone');
  set storePhone(String? value) => setField<String>('store_phone', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get isDeleted => getField<bool>('is_deleted');
  set isDeleted(bool? value) => setField<bool>('is_deleted', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  int? get huddleTime => getField<int>('huddle_time');
  set huddleTime(int? value) => setField<int>('huddle_time', value);

  int? get paymentTime => getField<int>('payment_time');
  set paymentTime(int? value) => setField<int>('payment_time', value);

  int? get allowedDistance => getField<int>('allowed_distance');
  set allowedDistance(int? value) => setField<int>('allowed_distance', value);

  String? get storeLocation => getField<String>('store_location');
  set storeLocation(String? value) => setField<String>('store_location', value);

  String? get storeQrcode => getField<String>('store_qrcode');
  set storeQrcode(String? value) => setField<String>('store_qrcode', value);
}
