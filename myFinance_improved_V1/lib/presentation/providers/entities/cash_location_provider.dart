// =====================================================
// CASH LOCATION ENTITY RIVERPOD PROVIDERS
// Autonomous data providers for cash location selectors
// =====================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/selector_entities.dart';
import '../../../data/models/transaction_history_model.dart';
import '../../../data/services/supabase_service.dart';
import '../app_state_provider.dart';

part 'cash_location_provider.g.dart';

// =====================================================
// CASH LOCATION LIST PROVIDER
// Base provider that fetches cash locations from RPC
// =====================================================
@riverpod
class CashLocationList extends _$CashLocationList {
  @override
  Future<List<CashLocationData>> build(
    String companyId, [
    String? storeId,
    String? locationType,
  ]) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    try {
      final response = await supabase.client.rpc(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
          'p_location_type': locationType,
          'p_store_id': storeId,
        },
      );

      if (response == null) return [];

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => CashLocationData.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Log error but don't throw to prevent UI crashes
      print('Error fetching cash locations: $e');
      return [];
    }
  }

  // Helper methods for specific location types
  Future<List<CashLocationData>> getCashLocations() async {
    final locations = await future;
    return locations.cashLocations;
  }

  Future<List<CashLocationData>> getBankAccounts() async {
    final locations = await future;
    return locations.bankAccounts;
  }

  Future<List<CashLocationData>> getCompanyWideLocations() async {
    final locations = await future;
    return locations.companyWide;
  }

  Future<List<CashLocationData>> getStoreSpecificLocations() async {
    final locations = await future;
    return locations.storeSpecific;
  }
}

// =====================================================
// AUTO-CONTEXT CASH LOCATION PROVIDERS
// Automatically watch app state and refresh data
// =====================================================

/// Current cash locations based on selected company/store
@riverpod
Future<List<CashLocationData>> currentCashLocations(CurrentCashLocationsRef ref) async {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  final selectedStore = appStateNotifier.selectedStore;
  final companyId = selectedCompany?['company_id'] as String?;
  final storeId = selectedStore?['store_id'] as String?;
  
  if (companyId == null) return [];
  
  return ref.watch(cashLocationListProvider(companyId, storeId).future);
}

/// Company-wide cash locations (no store filtering)
@riverpod
Future<List<CashLocationData>> companyCashLocations(CompanyCashLocationsRef ref) async {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  final companyId = selectedCompany?['company_id'] as String?;
  
  if (companyId == null) return [];
  
  // Pass null for storeId to get ALL company locations
  return ref.watch(cashLocationListProvider(companyId, null).future);
}

/// Current cash locations filtered by type
@riverpod
Future<List<CashLocationData>> currentCashLocationsByType(
  CurrentCashLocationsByTypeRef ref,
  String locationType,
) async {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  final selectedStore = appStateNotifier.selectedStore;
  final companyId = selectedCompany?['company_id'] as String?;
  final storeId = selectedStore?['store_id'] as String?;
  
  if (companyId == null) return [];
  
  return ref.watch(cashLocationListProvider(companyId, storeId, locationType).future);
}

/// Current cash locations filtered by scope (company/store)
@riverpod
Future<List<CashLocationData>> currentCashLocationsByScope(
  CurrentCashLocationsByScopeRef ref,
  TransactionScope scope,
) async {
  final locations = await ref.watch(currentCashLocationsProvider.future);
  
  switch (scope) {
    case TransactionScope.company:
      return locations.companyWide;
    case TransactionScope.store:
      return locations.storeSpecific;
  }
}

/// Company-wide cash locations only
@riverpod
Future<List<CashLocationData>> currentCompanyCashLocations(CurrentCompanyCashLocationsRef ref) async {
  return ref.watch(currentCashLocationsByScopeProvider(TransactionScope.company).future);
}

/// Store-specific cash locations only
@riverpod
Future<List<CashLocationData>> currentStoreCashLocations(CurrentStoreCashLocationsRef ref) async {
  return ref.watch(currentCashLocationsByScopeProvider(TransactionScope.store).future);
}

/// Cash-type locations only (not bank accounts)
@riverpod
Future<List<CashLocationData>> currentCashOnlyLocations(CurrentCashOnlyLocationsRef ref) async {
  return ref.watch(currentCashLocationsByTypeProvider('cash').future);
}

/// Bank account locations only
@riverpod
Future<List<CashLocationData>> currentBankAccountLocations(CurrentBankAccountLocationsRef ref) async {
  return ref.watch(currentCashLocationsByTypeProvider('bank').future);
}

// =====================================================
// CASH LOCATION SELECTION STATE PROVIDERS
// Manage selected cash location state
// =====================================================

/// Single cash location selection state
@riverpod
class SelectedCashLocation extends _$SelectedCashLocation {
  @override
  String? build() => null;

  void select(String? locationId) {
    state = locationId;
  }

  void clear() {
    state = null;
  }
}

/// Multiple cash location selection state
@riverpod
class SelectedCashLocations extends _$SelectedCashLocations {
  @override
  List<String> build() => [];

  void select(List<String> locationIds) {
    state = locationIds;
  }

  void add(String locationId) {
    if (!state.contains(locationId)) {
      state = [...state, locationId];
    }
  }

  void remove(String locationId) {
    state = state.where((id) => id != locationId).toList();
  }

  void toggle(String locationId) {
    if (state.contains(locationId)) {
      remove(locationId);
    } else {
      add(locationId);
    }
  }

  void clear() {
    state = [];
  }
}

// =====================================================
// CASH LOCATION DATA HELPERS
// Helper providers for finding specific cash locations
// =====================================================

/// Find cash location by ID
@riverpod
Future<CashLocationData?> cashLocationById(
  CashLocationByIdRef ref,
  String locationId,
) async {
  final locations = await ref.watch(currentCashLocationsProvider.future);
  try {
    return locations.firstWhere((location) => location.id == locationId);
  } catch (e) {
    return null;
  }
}

/// Find cash locations by IDs
@riverpod
Future<List<CashLocationData>> cashLocationsByIds(
  CashLocationsByIdsRef ref,
  List<String> locationIds,
) async {
  final locations = await ref.watch(currentCashLocationsProvider.future);
  return locations.where((location) => locationIds.contains(location.id)).toList();
}

/// Filter cash locations by store ID
@riverpod
Future<List<CashLocationData>> cashLocationsByStore(
  CashLocationsByStoreRef ref,
  String storeId,
) async {
  final locations = await ref.watch(currentCashLocationsProvider.future);
  return locations.filterByStore(storeId);
}

// =====================================================
// COUNTERPARTY CASH LOCATION PROVIDERS
// For fetching cash locations of other companies
// =====================================================

/// Get cash locations for a counterparty company
@riverpod
Future<List<CashLocationData>> counterpartyCompanyCashLocations(
  CounterpartyCompanyCashLocationsRef ref,
  String companyId,
) async {
  // Fetch all cash locations for the counterparty company
  return ref.watch(cashLocationListProvider(companyId, null).future);
}

/// Get cash locations for a specific counterparty store
@riverpod
Future<List<CashLocationData>> counterpartyStoreCashLocations(
  CounterpartyStoreCashLocationsRef ref,
  ({String companyId, String storeId}) params,
) async {
  // Fetch cash locations for the specific store of the counterparty
  return ref.watch(cashLocationListProvider(params.companyId, params.storeId).future);
}