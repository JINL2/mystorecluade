/// Dependency Injection for Time Table Feature
///
/// This file manages all concrete implementations and their dependencies.
/// Presentation layer should NOT directly import Data layer classes.
///
/// Clean Architecture Compliance:
/// - Presentation → Domain (interface only) ✅
/// - Data → Domain (implements interface) ✅
/// - DI layer handles concrete implementations 🔧
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/time_table_datasource.dart';
import '../data/repositories/time_table_repository_impl.dart';
import '../domain/repositories/time_table_repository.dart';

// ============================================================================
// Infrastructure Layer (Supabase)
// ============================================================================

/// Supabase Client Provider
///
/// Provides access to Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// Data Layer (Datasource)
// ============================================================================

/// Time Table Datasource Provider
///
/// Concrete implementation of data source using Supabase
/// This provider is internal to DI layer and should not be exposed to Presentation
final _timeTableDatasourceProvider = Provider<TimeTableDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TimeTableDatasource(client);
});

// ============================================================================
// Data Layer (Repository Implementation)
// ============================================================================

/// Time Table Repository Implementation Provider
///
/// Provides concrete implementation of TimeTableRepository
/// Presentation layer accesses this through the interface type
final timeTableRepositoryProvider = Provider<TimeTableRepository>((ref) {
  final datasource = ref.watch(_timeTableDatasourceProvider);
  return TimeTableRepositoryImpl(datasource);
});

// ============================================================================
// Why This Architecture?
// ============================================================================
//
// ✅ BEFORE (Violated Clean Architecture):
// Presentation → Data (TimeTableDatasource, TimeTableRepositoryImpl)
//
// ✅ AFTER (Clean Architecture Compliant):
// Presentation → Domain (TimeTableRepository interface)
// DI Layer → Data (TimeTableDatasource, TimeTableRepositoryImpl)
//
// Benefits:
// 1. Testability: Can inject mock repositories easily
// 2. Flexibility: Can swap implementations (Supabase → Firebase, REST API)
// 3. Maintainability: Clear separation of concerns
// 4. Dependency Inversion: High-level modules don't depend on low-level details
//
// ============================================================================
