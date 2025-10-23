// Repository Providers
// Riverpod providers for repository and datasource instances

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/journal_entry_repository.dart';
import '../datasources/journal_entry_datasource.dart';
import 'journal_entry_repository_impl.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// DataSource provider
final journalEntryDataSourceProvider = Provider<JournalEntryDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return JournalEntryDataSource(supabase);
});

// Repository provider
final journalEntryRepositoryProvider = Provider<JournalEntryRepository>((ref) {
  final dataSource = ref.watch(journalEntryDataSourceProvider);
  return JournalEntryRepositoryImpl(dataSource);
});
