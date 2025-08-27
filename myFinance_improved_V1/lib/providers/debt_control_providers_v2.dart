import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_control_models.dart';
import '../repositories/debt_control_repository_v2.dart';

// Enums
enum DebtPerspective { company, store }
enum DebtFilter { all, internal, external }

// Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Repository V2 - Singleton instance
final debtControlRepositoryV2Provider = Provider<DebtControlRepositoryV2>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DebtControlRepositoryV2(client);
});

// State Management
final debtPerspectiveProvider = StateProvider<DebtPerspective>((ref) {
  return DebtPerspective.company;
});

final debtFilterProvider = StateProvider<DebtFilter>((ref) {
  return DebtFilter.all;
});

final showAllCounterpartiesProvider = StateProvider<bool>((ref) {
  return false;
});

// Store Selection
final selectedStoreProvider = StateProvider<Map<String, String>?>((ref) {
  return {
    'id': 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
    'name': 'test1',
  };
});

// Company ID
final currentCompanyIdProvider = Provider<String>((ref) {
  return '7a2545e0-e112-4b0c-9c59-221a530c4602';
});

/// Optimized Data Provider - Fetches both perspectives once
final debtControlDataV2Provider = FutureProvider<DebtControlResponse>((ref) async {
  final repository = ref.watch(debtControlRepositoryV2Provider);
  final perspective = ref.watch(debtPerspectiveProvider);
  final filter = ref.watch(debtFilterProvider);
  final companyId = ref.watch(currentCompanyIdProvider);
  final selectedStore = ref.watch(selectedStoreProvider);
  final showAll = ref.watch(showAllCounterpartiesProvider);
  
  // Check if we have cached data for current perspective
  final cachedData = repository.getCachedData(perspective.name);
  if (cachedData != null) {
    return cachedData;
  }
  
  // Fetch both perspectives in one call
  await repository.fetchAllData(
    companyId: companyId,
    storeId: selectedStore?['id'],
    filter: filter.name,
    showAll: showAll,
  );
  
  // Return the requested perspective
  if (perspective == DebtPerspective.company) {
    return repository.getCompanyData(
      companyId: companyId,
      filter: filter.name,
      showAll: showAll,
    );
  } else {
    return repository.getStoreData(
      companyId: companyId,
      storeId: selectedStore!['id'],
      filter: filter.name,
      showAll: showAll,
    );
  }
});

/// Instant perspective switching - uses cached data
final instantPerspectiveProvider = Provider<DebtControlResponse?>((ref) {
  final repository = ref.watch(debtControlRepositoryV2Provider);
  final perspective = ref.watch(debtPerspectiveProvider);
  
  // Return cached data instantly without API call
  return repository.getCachedData(perspective.name);
});

// Helper provider for filter display names
final filterDisplayNameProvider = Provider.family<String, DebtFilter>((ref, filter) {
  switch (filter) {
    case DebtFilter.all:
      return 'All';
    case DebtFilter.internal:
      return 'My Group';
    case DebtFilter.external:
      return 'External';
  }
});

// Force refresh provider
final refreshDebtDataProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final repository = ref.read(debtControlRepositoryV2Provider);
    final companyId = ref.read(currentCompanyIdProvider);
    final selectedStore = ref.read(selectedStoreProvider);
    final filter = ref.read(debtFilterProvider);
    final showAll = ref.read(showAllCounterpartiesProvider);
    
    await repository.refreshData(
      companyId: companyId,
      storeId: selectedStore?['id'],
      filter: filter.name,
      showAll: showAll,
    );
    
    // Invalidate the provider to trigger rebuild
    ref.invalidate(debtControlDataV2Provider);
  };
});