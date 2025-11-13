// Data Layer - Repository Provider Implementation
// Provides concrete implementation of domain repository interface

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/journal_entry_repository.dart';
import '../datasources/journal_entry_datasource.dart';
import 'journal_entry_repository_impl.dart';

// =============================================================================
// Infrastructure Providers (Data Layer Only)
// =============================================================================

/// Supabase client provider (Infrastructure)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// DataSource provider (Data Layer)
final journalEntryDataSourceProvider = Provider<JournalEntryDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return JournalEntryDataSource(supabase);
});

// =============================================================================
// Repository Implementation Provider
// =============================================================================

/// Repository implementation provider
///
/// This overrides the domain provider with the actual implementation.
/// The domain layer defines the interface, this provides the concrete implementation.
///
/// Architecture:
/// - Domain Layer: Defines interface (journalEntryRepositoryProvider)
/// - Data Layer: Provides implementation (this file)
/// - Presentation Layer: Uses domain interface (no knowledge of data layer)
final journalEntryRepositoryProvider = Provider<JournalEntryRepository>((ref) {
  final dataSource = ref.watch(journalEntryDataSourceProvider);
  return JournalEntryRepositoryImpl(dataSource);
}, name: 'journalEntryRepositoryProvider');
