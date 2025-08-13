import '../database.dart';

class ShiftEditLogsTable extends SupabaseTable<ShiftEditLogsRow> {
  @override
  String get tableName => 'shift_edit_logs';

  @override
  ShiftEditLogsRow createRow(Map<String, dynamic> data) =>
      ShiftEditLogsRow(data);
}

class ShiftEditLogsRow extends SupabaseDataRow {
  ShiftEditLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShiftEditLogsTable();

  String get logId => getField<String>('log_id')!;
  set logId(String value) => setField<String>('log_id', value);

  String? get shiftRequestId => getField<String>('shift_request_id');
  set shiftRequestId(String? value) =>
      setField<String>('shift_request_id', value);

  String? get editedBy => getField<String>('edited_by');
  set editedBy(String? value) => setField<String>('edited_by', value);

  String? get editType => getField<String>('edit_type');
  set editType(String? value) => setField<String>('edit_type', value);

  dynamic get oldValue => getField<dynamic>('old_value');
  set oldValue(dynamic value) => setField<dynamic>('old_value', value);

  dynamic get newValue => getField<dynamic>('new_value');
  set newValue(dynamic value) => setField<dynamic>('new_value', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
