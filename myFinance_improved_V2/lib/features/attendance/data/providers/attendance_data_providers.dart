import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_datasource.dart';
import '../repositories/attendance_repository_impl.dart';

/// Re-export Domain provider interface
///
/// This allows Data layer to provide the implementation
/// while Presentation can import from Domain level
export '../../domain/providers/attendance_repository_provider.dart'
    show attendanceRepositoryProvider;

/// Supabase client provider (private to Data layer)
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Attendance datasource provider (private to Data layer)
///
/// Creates the datasource that handles all Supabase RPC calls
final _attendanceDatasourceProvider = Provider<AttendanceDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return AttendanceDatasource(client);
});

/// Attendance repository implementation provider
///
/// This provider overrides the Domain-level attendanceRepositoryProvider
/// to provide the concrete implementation.
///
/// Clean Architecture Flow:
/// 1. Domain defines the interface: attendanceRepositoryProvider (throws UnimplementedError)
/// 2. Data provides implementation: This file overrides with AttendanceRepositoryImpl
/// 3. Presentation uses Domain provider: No direct dependency on Data layer
///
/// To use in app initialization:
/// ```dart
/// ProviderScope(
///   overrides: [
///     // Domain provider is automatically overridden when this file is imported
///   ],
///   child: MyApp(),
/// )
/// ```
final attendanceRepositoryProviderImpl = Provider<AttendanceRepository>((ref) {
  final datasource = ref.watch(_attendanceDatasourceProvider);
  return AttendanceRepositoryImpl(datasource: datasource);
});
