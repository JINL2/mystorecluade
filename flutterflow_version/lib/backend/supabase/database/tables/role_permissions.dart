import '../database.dart';

class RolePermissionsTable extends SupabaseTable<RolePermissionsRow> {
  @override
  String get tableName => 'role_permissions';

  @override
  RolePermissionsRow createRow(Map<String, dynamic> data) =>
      RolePermissionsRow(data);
}

class RolePermissionsRow extends SupabaseDataRow {
  RolePermissionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RolePermissionsTable();

  String get rolePermissionId => getField<String>('role_permission_id')!;
  set rolePermissionId(String value) =>
      setField<String>('role_permission_id', value);

  String? get roleId => getField<String>('role_id');
  set roleId(String? value) => setField<String>('role_id', value);

  String? get featureId => getField<String>('feature_id');
  set featureId(String? value) => setField<String>('feature_id', value);

  bool? get canAccess => getField<bool>('can_access');
  set canAccess(bool? value) => setField<bool>('can_access', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
