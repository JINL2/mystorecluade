// lib/features/report_control/presentation/pages/templates/daily_attendance/providers/attendance_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/attendance_datasource.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../domain/repositories/attendance_repository.dart';

/// Supabase Client Provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Attendance DataSource Provider
final attendanceDataSourceProvider = Provider<AttendanceDataSource>((ref) {
  final supabase = ref.watch(_supabaseClientProvider);
  return AttendanceDataSource(supabase);
});

/// Attendance Repository Provider
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final dataSource = ref.watch(attendanceDataSourceProvider);
  return AttendanceRepositoryImpl(dataSource);
});
