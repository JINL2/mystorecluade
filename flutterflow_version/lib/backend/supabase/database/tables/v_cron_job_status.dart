import '../database.dart';

class VCronJobStatusTable extends SupabaseTable<VCronJobStatusRow> {
  @override
  String get tableName => 'v_cron_job_status';

  @override
  VCronJobStatusRow createRow(Map<String, dynamic> data) =>
      VCronJobStatusRow(data);
}

class VCronJobStatusRow extends SupabaseDataRow {
  VCronJobStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VCronJobStatusTable();

  String? get jobname => getField<String>('jobname');
  set jobname(String? value) => setField<String>('jobname', value);

  String? get schedule => getField<String>('schedule');
  set schedule(String? value) => setField<String>('schedule', value);

  String? get command => getField<String>('command');
  set command(String? value) => setField<String>('command', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);

  String? get scheduleDescription => getField<String>('schedule_description');
  set scheduleDescription(String? value) =>
      setField<String>('schedule_description', value);

  String? get executionMethod => getField<String>('execution_method');
  set executionMethod(String? value) =>
      setField<String>('execution_method', value);
}
