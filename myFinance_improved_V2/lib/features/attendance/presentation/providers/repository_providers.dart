import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/attendance_datasource.dart';
import '../../data/repositories/attendance_repository_impl.dart';
import '../../domain/repositories/attendance_repository.dart';

part 'repository_providers.g.dart';

/// Supabase client provider
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

/// Attendance datasource provider
@riverpod
AttendanceDatasource attendanceDatasource(AttendanceDatasourceRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return AttendanceDatasource(client);
}

/// Attendance repository provider
///
/// Provides the concrete implementation of AttendanceRepository.
/// Presentation layer accesses this through the interface type.
@riverpod
AttendanceRepository attendanceRepository(AttendanceRepositoryRef ref) {
  final datasource = ref.watch(attendanceDatasourceProvider);
  return AttendanceRepositoryImpl(datasource: datasource);
}
