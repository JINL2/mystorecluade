import '../database.dart';

class ViewRolesWithPermissionsTable
    extends SupabaseTable<ViewRolesWithPermissionsRow> {
  @override
  String get tableName => 'view_roles_with_permissions';

  @override
  ViewRolesWithPermissionsRow createRow(Map<String, dynamic> data) =>
      ViewRolesWithPermissionsRow(data);
}

class ViewRolesWithPermissionsRow extends SupabaseDataRow {
  ViewRolesWithPermissionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewRolesWithPermissionsTable();

  String? get roleId => getField<String>('role_id');
  set roleId(String? value) => setField<String>('role_id', value);

  String? get roleName => getField<String>('role_name');
  set roleName(String? value) => setField<String>('role_name', value);

  String? get roleType => getField<String>('role_type');
  set roleType(String? value) => setField<String>('role_type', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get parentRoleId => getField<String>('parent_role_id');
  set parentRoleId(String? value) => setField<String>('parent_role_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get isDeletable => getField<bool>('is_deletable');
  set isDeletable(bool? value) => setField<bool>('is_deletable', value);

  dynamic get permissions => getField<dynamic>('permissions');
  set permissions(dynamic value) => setField<dynamic>('permissions', value);
}
