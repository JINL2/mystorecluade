import '../database.dart';

class VUserRoleInfoTable extends SupabaseTable<VUserRoleInfoRow> {
  @override
  String get tableName => 'v_user_role_info';

  @override
  VUserRoleInfoRow createRow(Map<String, dynamic> data) =>
      VUserRoleInfoRow(data);
}

class VUserRoleInfoRow extends SupabaseDataRow {
  VUserRoleInfoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VUserRoleInfoTable();

  String? get userRoleId => getField<String>('user_role_id');
  set userRoleId(String? value) => setField<String>('user_role_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get roleId => getField<String>('role_id');
  set roleId(String? value) => setField<String>('role_id', value);

  String? get roleName => getField<String>('role_name');
  set roleName(String? value) => setField<String>('role_name', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get profileImage => getField<String>('profile_image');
  set profileImage(String? value) => setField<String>('profile_image', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get isDeleted => getField<bool>('is_deleted');
  set isDeleted(bool? value) => setField<bool>('is_deleted', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}
