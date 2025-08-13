import '../database.dart';

class VShiftRequestWithUserTable
    extends SupabaseTable<VShiftRequestWithUserRow> {
  @override
  String get tableName => 'v_shift_request_with_user';

  @override
  VShiftRequestWithUserRow createRow(Map<String, dynamic> data) =>
      VShiftRequestWithUserRow(data);
}

class VShiftRequestWithUserRow extends SupabaseDataRow {
  VShiftRequestWithUserRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VShiftRequestWithUserTable();

  String? get shiftRequestId => getField<String>('shift_request_id');
  set shiftRequestId(String? value) =>
      setField<String>('shift_request_id', value);

  String? get shiftId => getField<String>('shift_id');
  set shiftId(String? value) => setField<String>('shift_id', value);

  DateTime? get requestDate => getField<DateTime>('request_date');
  set requestDate(DateTime? value) => setField<DateTime>('request_date', value);

  bool? get isApproved => getField<bool>('is_approved');
  set isApproved(bool? value) => setField<bool>('is_approved', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get profileImage => getField<String>('profile_image');
  set profileImage(String? value) => setField<String>('profile_image', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
