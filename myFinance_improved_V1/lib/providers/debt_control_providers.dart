import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_control_models.dart';
import '../repositories/debt_control_repository.dart';

// Enums
enum DebtPerspective { company, store }
enum DebtFilter { all, internal, external }

// Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Repository
final debtControlRepositoryProvider = Provider<DebtControlRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DebtControlRepository(client);
});

// State Management
final debtPerspectiveProvider = StateProvider<DebtPerspective>((ref) {
  return DebtPerspective.company; // Default to company view as in your image
});

final debtFilterProvider = StateProvider<DebtFilter>((ref) {
  return DebtFilter.all;
});

// Show all counterparties or only active ones
final showAllCounterpartiesProvider = StateProvider<bool>((ref) {
  return false; // Default to showing only active (with transactions)
});

// Store Selection
final selectedStoreProvider = StateProvider<Map<String, String>?>((ref) {
  // Default store - replace with your actual store selection logic
  return {
    'id': 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
    'name': 'test1',
  };
});

// Company ID - Replace with your actual company ID provider
final currentCompanyIdProvider = Provider<String>((ref) {
  return '7a2545e0-e112-4b0c-9c59-221a530c4602'; // Your company ID
});

// Main Data Provider
final debtControlDataProvider = FutureProvider<DebtControlResponse>((ref) async {
  final repository = ref.watch(debtControlRepositoryProvider);
  final perspective = ref.watch(debtPerspectiveProvider);
  final filter = ref.watch(debtFilterProvider);
  final companyId = ref.watch(currentCompanyIdProvider);
  final selectedStore = ref.watch(selectedStoreProvider);
  final showAll = ref.watch(showAllCounterpartiesProvider);
  
  final storeId = perspective == DebtPerspective.store 
      ? (selectedStore != null ? selectedStore['id'] : null)
      : null;
  
  return repository.getDebtControlData(
    companyId: companyId,
    storeId: storeId,
    perspective: perspective.name,
    filter: filter.name,
    showAll: showAll,
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