// lib/features/journal_input/di/journal_input_providers.dart
//
// Centralized Dependency Injection for journal_input feature
// All DataSource, Repository providers in one place
// Following Clean Architecture 2025 with @riverpod

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data Layer
import '../data/datasources/journal_entry_datasource.dart';
import '../data/repositories/journal_entry_repository_impl.dart';

// Domain Layer
import '../domain/repositories/journal_entry_repository.dart';

part 'journal_input_providers.g.dart';

// ============================================================================
// TIER 1: INFRASTRUCTURE - External Dependencies
// ============================================================================

/// Supabase Client Provider
/// Singleton instance for all database operations
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

// ============================================================================
// TIER 2: DATA SOURCES - Database Communication
// ============================================================================

/// Journal Entry DataSource
/// Handles all journal entry Supabase operations
@riverpod
JournalEntryDataSource journalEntryDataSource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return JournalEntryDataSource(client);
}

// ============================================================================
// TIER 3: REPOSITORIES - Domain Interface Implementations
// ============================================================================

/// Journal Entry Repository
/// Implements domain JournalEntryRepository interface
@riverpod
JournalEntryRepository journalEntryRepository(Ref ref) {
  final dataSource = ref.watch(journalEntryDataSourceProvider);
  return JournalEntryRepositoryImpl(dataSource);
}
