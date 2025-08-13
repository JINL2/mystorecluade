import '../database.dart';

class UserStoresTable extends SupabaseTable<UserStoresRow> {
  @override
  String get tableName => 'user_stores';

  @override
  UserStoresRow createRow(Map<String, dynamic> data) => UserStoresRow(data);
}

class UserStoresRow extends SupabaseDataRow {
  UserStoresRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserStoresTable();

  String get userStoreId => getField<String>('user_store_id')!;
  set userStoreId(String value) => setField<String>('user_store_id', value);

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
}
