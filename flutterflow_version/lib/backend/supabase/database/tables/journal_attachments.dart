import '../database.dart';

class JournalAttachmentsTable extends SupabaseTable<JournalAttachmentsRow> {
  @override
  String get tableName => 'journal_attachments';

  @override
  JournalAttachmentsRow createRow(Map<String, dynamic> data) =>
      JournalAttachmentsRow(data);
}

class JournalAttachmentsRow extends SupabaseDataRow {
  JournalAttachmentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => JournalAttachmentsTable();

  String get attachmentId => getField<String>('attachment_id')!;
  set attachmentId(String value) => setField<String>('attachment_id', value);

  String get journalId => getField<String>('journal_id')!;
  set journalId(String value) => setField<String>('journal_id', value);

  String get fileUrl => getField<String>('file_url')!;
  set fileUrl(String value) => setField<String>('file_url', value);

  String? get fileName => getField<String>('file_name');
  set fileName(String? value) => setField<String>('file_name', value);

  String? get uploadedBy => getField<String>('uploaded_by');
  set uploadedBy(String? value) => setField<String>('uploaded_by', value);

  DateTime? get uploadedAt => getField<DateTime>('uploaded_at');
  set uploadedAt(DateTime? value) => setField<DateTime>('uploaded_at', value);
}
