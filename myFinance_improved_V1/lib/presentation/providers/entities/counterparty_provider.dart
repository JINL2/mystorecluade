// =====================================================
// COUNTERPARTY ENTITY RIVERPOD PROVIDERS
// Autonomous data providers for counterparty selectors
// =====================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/selector_entities.dart';
import '../../../data/services/supabase_service.dart';
import '../app_state_provider.dart';

part 'counterparty_provider.g.dart';

// =====================================================
// COUNTERPARTY LIST PROVIDER
// Base provider that fetches counterparties from RPC
// =====================================================
@riverpod
class CounterpartyList extends _$CounterpartyList {
  @override
  Future<List<CounterpartyData>> build(
    String companyId, [
    String? storeId,
    String? counterpartyType,
  ]) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    try {
      final response = await supabase.client.rpc(
        'get_counterparties',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_counterparty_type': counterpartyType,
        },
      );

      if (response == null) return [];

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => CounterpartyData.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Log error but don't throw to prevent UI crashes
      print('Error fetching counterparties: $e');
      return [];
    }
  }

  // Helper methods for specific counterparty types
  Future<List<CounterpartyData>> getCustomers() async {
    final counterparties = await future;
    return counterparties.customers;
  }

  Future<List<CounterpartyData>> getVendors() async {
    final counterparties = await future;
    return counterparties.vendors;
  }

  Future<List<CounterpartyData>> getInternalCounterparties() async {
    final counterparties = await future;
    return counterparties.internal;
  }

  Future<List<CounterpartyData>> getExternalCounterparties() async {
    final counterparties = await future;
    return counterparties.external;
  }
}

// =====================================================
// AUTO-CONTEXT COUNTERPARTY PROVIDERS
// Automatically watch app state and refresh data
// =====================================================

/// Current counterparties based on selected company/store
@riverpod
Future<List<CounterpartyData>> currentCounterparties(CurrentCounterpartiesRef ref) async {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  final selectedStore = appStateNotifier.selectedStore;
  final companyId = selectedCompany?['company_id'] as String?;
  final storeId = selectedStore?['store_id'] as String?;
  
  if (companyId == null) return [];
  
  return ref.watch(counterpartyListProvider(companyId, storeId).future);
}

/// Current counterparties filtered by type
@riverpod
Future<List<CounterpartyData>> currentCounterpartiesByType(
  CurrentCounterpartiesByTypeRef ref,
  String counterpartyType,
) async {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  final selectedStore = appStateNotifier.selectedStore;
  final companyId = selectedCompany?['company_id'] as String?;
  final storeId = selectedStore?['store_id'] as String?;
  
  if (companyId == null) return [];
  
  return ref.watch(counterpartyListProvider(companyId, storeId, counterpartyType).future);
}

/// Customer counterparties only
@riverpod
Future<List<CounterpartyData>> currentCustomers(CurrentCustomersRef ref) async {
  return ref.watch(currentCounterpartiesByTypeProvider('customer').future);
}

/// Vendor counterparties only
@riverpod
Future<List<CounterpartyData>> currentVendors(CurrentVendorsRef ref) async {
  return ref.watch(currentCounterpartiesByTypeProvider('vendor').future);
}

/// Supplier counterparties only
@riverpod
Future<List<CounterpartyData>> currentSuppliers(CurrentSuppliersRef ref) async {
  return ref.watch(currentCounterpartiesByTypeProvider('supplier').future);
}

/// Internal counterparties only
@riverpod
Future<List<CounterpartyData>> currentInternalCounterparties(CurrentInternalCounterpartiesRef ref) async {
  final counterparties = await ref.watch(currentCounterpartiesProvider.future);
  return counterparties.internal;
}

/// External counterparties only
@riverpod
Future<List<CounterpartyData>> currentExternalCounterparties(CurrentExternalCounterpartiesRef ref) async {
  final counterparties = await ref.watch(currentCounterpartiesProvider.future);
  return counterparties.external;
}

// =====================================================
// COUNTERPARTY SELECTION STATE PROVIDERS
// Manage selected counterparty state
// =====================================================

/// Single counterparty selection state
@riverpod
class SelectedCounterparty extends _$SelectedCounterparty {
  @override
  String? build() => null;

  void select(String? counterpartyId) {
    state = counterpartyId;
  }

  void clear() {
    state = null;
  }
}

/// Multiple counterparty selection state
@riverpod
class SelectedCounterparties extends _$SelectedCounterparties {
  @override
  List<String> build() => [];

  void select(List<String> counterpartyIds) {
    state = counterpartyIds;
  }

  void add(String counterpartyId) {
    if (!state.contains(counterpartyId)) {
      state = [...state, counterpartyId];
    }
  }

  void remove(String counterpartyId) {
    state = state.where((id) => id != counterpartyId).toList();
  }

  void toggle(String counterpartyId) {
    if (state.contains(counterpartyId)) {
      remove(counterpartyId);
    } else {
      add(counterpartyId);
    }
  }

  void clear() {
    state = [];
  }
}

// =====================================================
// COUNTERPARTY DATA HELPERS
// Helper providers for finding specific counterparties
// =====================================================

/// Find counterparty by ID
@riverpod
Future<CounterpartyData?> counterpartyById(
  CounterpartyByIdRef ref,
  String counterpartyId,
) async {
  final counterparties = await ref.watch(currentCounterpartiesProvider.future);
  try {
    return counterparties.firstWhere((cp) => cp.id == counterpartyId);
  } catch (e) {
    return null;
  }
}

/// Find counterparties by IDs
@riverpod
Future<List<CounterpartyData>> counterpartiesByIds(
  CounterpartiesByIdsRef ref,
  List<String> counterpartyIds,
) async {
  final counterparties = await ref.watch(currentCounterpartiesProvider.future);
  return counterparties.where((cp) => counterpartyIds.contains(cp.id)).toList();
}

/// Search counterparties by name
@riverpod
Future<List<CounterpartyData>> searchCounterparties(
  SearchCounterpartiesRef ref,
  String searchQuery,
) async {
  final counterparties = await ref.watch(currentCounterpartiesProvider.future);
  if (searchQuery.isEmpty) return counterparties;
  
  final queryLower = searchQuery.toLowerCase();
  return counterparties.where((cp) {
    return cp.name.toLowerCase().contains(queryLower) ||
           cp.type.toLowerCase().contains(queryLower) ||
           (cp.email?.toLowerCase().contains(queryLower) ?? false);
  }).toList();
}