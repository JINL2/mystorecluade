import '../database.dart';

class VUserStoresTable extends SupabaseTable<VUserStoresRow> {
  @override
  String get tableName => 'v_user_stores';

  @override
  VUserStoresRow createRow(Map<String, dynamic> data) => VUserStoresRow(data);
}

class VUserStoresRow extends SupabaseDataRow {
  VUserStoresRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VUserStoresTable();

  String? get userStoreId => getField<String>('user_store_id');
  set userStoreId(String? value) => setField<String>('user_store_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get isDeleted => getField<bool>('is_deleted');
  set isDeleted(bool? value) => setField<bool>('is_deleted', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  String? get userFullname => getField<String>('user_fullname');
  set userFullname(String? value) => setField<String>('user_fullname', value);

  String? get profileImage => getField<String>('profile_image');
  set profileImage(String? value) => setField<String>('profile_image', value);
}
