/// Repository Providers for attendance module
///
/// Following Clean Architecture pattern: Presentation layer imports this file
/// through domain/providers/repository_providers.dart facade.
///
/// Private providers (_prefix) are internal to Data layer.
/// Public providers expose Domain interfaces to Presentation layer.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_datasource.dart';
import '../repositories/attendance_repository_impl.dart';

// ============================================================================
// Internal Providers (Private - used only within this file)
// ============================================================================

/// Supabase client provider (Internal)
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Attendance datasource provider (Internal)
///
/// Creates the datasource that handles all Supabase RPC calls
final _attendanceDatasourceProvider = Provider<AttendanceDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return AttendanceDatasource(client);
});

// ============================================================================
// Public Repository Providers (Exposed to Presentation layer)
// ============================================================================

/// Attendance repository provider
///
/// Provides AttendanceRepositoryImpl implementation.
/// Presentation layer should import this through domain/providers facade.
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final datasource = ref.watch(_attendanceDatasourceProvider);
  return AttendanceRepositoryImpl(datasource: datasource);
});
