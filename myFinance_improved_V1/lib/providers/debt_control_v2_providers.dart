import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_control_v2_models.dart';
import '../repositories/debt_control_v2_repository.dart';

// Enums
enum DebtPerspective { company, store }
enum DebtFilter { all, internal, external }

// Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Repository V2
final debtControlV2RepositoryProvider = Provider<DebtControlV2Repository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DebtControlV2Repository(client);
});

// State Management
final debtPerspectiveProvider = StateProvider<DebtPerspective>((ref) {
  return DebtPerspective.company; // Default to company view
});

final debtFilterProvider = StateProvider<DebtFilter>((ref) {
  return DebtFilter.all;
});

final showAllCounterpartiesProvider = StateProvider<bool>((ref) {
  return false; // Default to showing only active (with transactions)
});

// Store Selection
final selectedStoreProvider = StateProvider<Map<String, String>?>((ref) {
  // Replace with your actual store selection logic
  return {
    'id': 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
    'name': 'test1',
  };
});

// Company ID - Replace with your actual company ID provider
final currentCompanyIdProvider = Provider<String>((ref) {
  return '7a2545e0-e112-4b0c-9c59-221a530c4602'; // Your company ID
});

// Main Data Provider V2 - Single call gets both perspectives
final debtDataV2Provider = FutureProvider<DebtControlV2Response>((ref) async {
  final repository = ref.watch(debtControlV2RepositoryProvider);
  final filter = ref.watch(debtFilterProvider);
  final companyId = ref.watch(currentCompanyIdProvider);
  final selectedStore = ref.watch(selectedStoreProvider);
  final showAll = ref.watch(showAllCounterpartiesProvider);
  
  // Single call gets both company and store perspectives
  return repository.getDebtControlData(
    companyId: companyId,
    storeId: selectedStore?['id'],
    filter: filter.name,
    showAll: showAll,
  );
});

// Computed provider for current perspective data
final currentPerspectiveDataProvider = Provider<DebtPerspectiveData?>((ref) {
  final dataAsync = ref.watch(debtDataV2Provider);
  final perspective = ref.watch(debtPerspectiveProvider);
  
  return dataAsync.maybeWhen(
    data: (response) {
      // Return the appropriate perspective based on current selection
      if (perspective == DebtPerspective.company) {
        return response.company;
      } else {
        return response.store;
      }
    },
    orElse: () => null,
  );
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

// Refresh function provider
final refreshDebtDataProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    // Invalidate the provider to trigger a refresh
    ref.invalidate(debtDataV2Provider);
  };
});