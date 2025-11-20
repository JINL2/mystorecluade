import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_datasource.dart';
import '../repositories/attendance_repository_impl.dart';

/// Supabase client provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Attendance datasource provider
///
/// Creates the datasource that handles all Supabase RPC calls
final attendanceDatasourceProvider = Provider<AttendanceDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return AttendanceDatasource(client);
});

/// Attendance repository implementation provider
///
/// Creates the repository implementation that converts models to entities
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final datasource = ref.watch(attendanceDatasourceProvider);
  return AttendanceRepositoryImpl(datasource: datasource);
});
