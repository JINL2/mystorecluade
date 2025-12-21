// =====================================================
// STORE ENTITY RIVERPOD PROVIDERS
// Autonomous data providers for store selectors
// =====================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/selector_entities.dart';
import '../../data/services/supabase_service.dart';
import '../app_state_provider.dart';

part 'store_provider.g.dart';

// =====================================================
// STORE LIST PROVIDER
// Base provider that fetches stores from RPC
// =====================================================
@riverpod
class StoreList extends _$StoreList {
  @override
  Future<List<StoreData>> build(String companyId) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    try {
      final response = await supabase.client.rpc(
        'get_stores',
        params: {
          'p_company_id': companyId,
        },
      );

      if (response == null) return [];

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => StoreData.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Log error but don't throw to prevent UI crashes
      print('Error fetching stores: $e');
      return [];
    }
  }
}

// =====================================================
// AUTO-CONTEXT STORE PROVIDERS
// Automatically watch app state and refresh data
// =====================================================

/// Current stores based on selected company
@riverpod
Future<List<StoreData>> currentStores(CurrentStoresRef ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.selectedCompany?['company_id'] as String?;
  
  if (companyId == null) return [];
  
  return ref.watch(storeListProvider(companyId).future);
}

/// Current stores with transaction count filter
@riverpod
Future<List<StoreData>> currentActiveStores(CurrentActiveStoresRef ref) async {
  final stores = await ref.watch(currentStoresProvider.future);
  return stores.where((store) => store.transactionCount > 0).toList();
}

// =====================================================
// STORE SELECTION STATE PROVIDERS
// Manage selected store state
// =====================================================

/// Single store selection state
@riverpod
class SelectedStore extends _$SelectedStore {
  @override
  String? build() => null;

  void select(String? storeId) {
    state = storeId;
  }

  void clear() {
    state = null;
  }
}

/// Multiple store selection state
@riverpod
class SelectedStores extends _$SelectedStores {
  @override
  List<String> build() => [];

  void select(List<String> storeIds) {
    state = storeIds;
  }

  void add(String storeId) {
    if (!state.contains(storeId)) {
      state = [...state, storeId];
    }
  }

  void remove(String storeId) {
    state = state.where((id) => id != storeId).toList();
  }

  void toggle(String storeId) {
    if (state.contains(storeId)) {
      remove(storeId);
    } else {
      add(storeId);
    }
  }

  void clear() {
    state = [];
  }
}

// =====================================================
// STORE DATA HELPERS
// Helper providers for finding specific stores
// =====================================================

/// Find store by ID
@riverpod
Future<StoreData?> storeById(
  StoreByIdRef ref,
  String storeId,
) async {
  final stores = await ref.watch(currentStoresProvider.future);
  try {
    return stores.firstWhere((store) => store.id == storeId);
  } catch (e) {
    return null;
  }
}

/// Find stores by IDs
@riverpod
Future<List<StoreData>> storesByIds(
  StoresByIdsRef ref,
  List<String> storeIds,
) async {
  final stores = await ref.watch(currentStoresProvider.future);
  return stores.where((store) => storeIds.contains(store.id)).toList();
}

/// Search stores by name or code
@riverpod
Future<List<StoreData>> searchStores(
  SearchStoresRef ref,
  String searchQuery,
) async {
  final stores = await ref.watch(currentStoresProvider.future);
  if (searchQuery.isEmpty) return stores;
  
  final queryLower = searchQuery.toLowerCase();
  return stores.where((store) {
    return store.name.toLowerCase().contains(queryLower) ||
           store.code.toLowerCase().contains(queryLower) ||
           (store.address?.toLowerCase().contains(queryLower) ?? false);
  }).toList();
}