import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// App-level
import 'package:myfinance_improved/app/providers/app_state_provider.dart';

// Feature - DI (Dependency Injection)
import '../../di/providers.dart';
// Feature - Domain
import '../../domain/entities/currency.dart';

part 'currency_providers.g.dart';

// ============================================================================
// Available Currency Types Provider
// ============================================================================

/// Available currency types provider
@riverpod
Future<List<CurrencyType>> availableCurrencyTypes(Ref ref) async {
  final repository = ref.watch(currencyRepositoryProvider);
  return repository.getAvailableCurrencyTypes();
}

// ============================================================================
// Company Currencies Provider
// ============================================================================

/// Company currencies provider
@riverpod
Future<List<Currency>> companyCurrencies(Ref ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    throw Exception('No company selected');
  }

  final repository = ref.watch(currencyRepositoryProvider);
  return repository.getCompanyCurrencies(companyId);
}

/// Company currencies stream provider for real-time updates
@riverpod
Stream<List<Currency>> companyCurrenciesStream(Ref ref) {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return Stream.value([]);
  }

  final repository = ref.watch(currencyRepositoryProvider);
  return repository.watchCompanyCurrencies(companyId);
}

// ============================================================================
// Currency Search Notifier
// ============================================================================

/// Currency search notifier
@riverpod
class CurrencySearch extends _$CurrencySearch {
  @override
  AsyncValue<List<CurrencyType>> build() => const AsyncValue.data([]);

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(currencyRepositoryProvider);
      final results = await repository.searchCurrencyTypes(query.trim());
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

// ============================================================================
// Selected Currency Type Provider
// ============================================================================

/// Selected currency type for adding
@riverpod
class SelectedCurrencyType extends _$SelectedCurrencyType {
  @override
  String? build() => null;

  void update(String? value) {
    state = value;
  }

  void clear() {
    state = null;
  }
}

// ============================================================================
// Currency Operations Notifier
// ============================================================================

/// Currency operations notifier
@riverpod
class CurrencyOperations extends _$CurrencyOperations {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> addCompanyCurrency(String currencyId) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(currencyRepositoryProvider);

      // First, get the currency type to create a full currency object for optimistic update
      final allTypes = await repository.getAvailableCurrencyTypes();
      final currencyType = allTypes.firstWhere((type) => type.currencyId == currencyId);

      // Create a temporary currency object for optimistic update
      final optimisticCurrency = Currency(
        id: currencyType.currencyId,
        code: currencyType.currencyCode,
        name: currencyType.currencyName,
        fullName: currencyType.currencyName, // CurrencyType doesn't have fullName, use currencyName
        symbol: currencyType.symbol,
        flagEmoji: currencyType.flagEmoji,
      );

      // OPTIMISTIC UI UPDATE - Add to local state immediately
      ref.read(localCurrencyListProvider.notifier).optimisticallyAdd(optimisticCurrency);

      // Perform database operation in background
      await repository.addCompanyCurrency(companyId, currencyId);

      // Refresh the remote providers after successful database operation
      ref.invalidate(companyCurrenciesProvider);
      ref.invalidate(companyCurrenciesStreamProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      // If database operation fails, revert the optimistic update
      ref.read(localCurrencyListProvider.notifier).optimisticallyRemove(currencyId);

      // Enhanced error reporting
      final errorMessage = error.toString().contains('already exists')
          ? 'This currency has already been added to your company'
          : 'Failed to add currency: Network error or server unavailable';

      state = AsyncValue.error(errorMessage, stackTrace);
    }
  }

  Future<void> removeCompanyCurrency(String currencyId) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    // Store the current currency for potential rollback
    final localNotifier = ref.read(localCurrencyListProvider.notifier);
    final currentCurrencies = localNotifier.getCurrencies();
    final currencyToRemove = currentCurrencies.firstWhere((c) => c.id == currencyId);

    state = const AsyncValue.loading();

    try {
      // OPTIMISTIC UI UPDATE - Remove from local state immediately
      localNotifier.optimisticallyRemove(currencyId);

      // Perform database operation in background
      final repository = ref.read(currencyRepositoryProvider);
      await repository.removeCompanyCurrency(companyId, currencyId);

      // Refresh the remote providers after successful database operation
      ref.invalidate(companyCurrenciesProvider);
      ref.invalidate(companyCurrenciesStreamProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      // If database operation fails, revert the optimistic update
      localNotifier.optimisticallyAdd(currencyToRemove);

      // Enhanced error reporting
      final errorMessage = error.toString().contains('Currency not found')
          ? 'Currency not found in your company.'
          : 'Failed to remove currency: ${error.toString()}';

      state = AsyncValue.error(errorMessage, stackTrace);
    }
  }

  Future<void> updateCompanyCurrency(String currencyId, {bool? isActive}) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(currencyRepositoryProvider);
      await repository.updateCompanyCurrency(companyId, currencyId, isActive: isActive);

      // Refresh the company currencies list
      ref.invalidate(companyCurrenciesProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void resetState() {
    state = const AsyncValue.data(null);
  }
}

// ============================================================================
// Expanded Currencies Provider
// ============================================================================

/// Expanded currencies state (which currencies are expanded in the UI)
@riverpod
class ExpandedCurrencies extends _$ExpandedCurrencies {
  @override
  Set<String> build() => <String>{};

  void toggle(String currencyId) {
    if (state.contains(currencyId)) {
      state = {...state}..remove(currencyId);
    } else {
      state = {...state, currencyId};
    }
  }

  void expand(String currencyId) {
    state = {...state, currencyId};
  }

  void collapse(String currencyId) {
    state = {...state}..remove(currencyId);
  }

  void clear() {
    state = <String>{};
  }
}

// ============================================================================
// Search Query Provider
// ============================================================================

/// Search query provider with auto-dispose
@riverpod
class CurrencySearchQuery extends _$CurrencySearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Page-specific search controller provider that manages TossSearchField state
@riverpod
class CurrencySearchController extends _$CurrencySearchController {
  @override
  TextEditingController build() {
    final controller = TextEditingController();

    // Listen to search query changes and sync with controller
    ref.listen(currencySearchQueryProvider, (previous, next) {
      if (controller.text != next) {
        controller.text = next;
      }
    });

    // Clean disposal
    ref.onDispose(() {
      controller.dispose();
    });

    return controller;
  }
}

// ============================================================================
// Local Currency List Provider (for Optimistic UI Updates)
// ============================================================================

/// Local currency list notifier for optimistic UI updates
@riverpod
class LocalCurrencyList extends _$LocalCurrencyList {
  @override
  List<Currency>? build() => null;

  // Initialize local state with remote data
  void initializeFromRemote(List<Currency> currencies) {
    state = currencies;
  }

  // Get current local currencies
  List<Currency> getCurrencies() {
    return state ?? [];
  }

  // Optimistically add currency to local state
  void optimisticallyAdd(Currency currency) {
    final currentList = state ?? [];
    state = [...currentList, currency];
  }

  // Optimistically remove currency from local state
  void optimisticallyRemove(String currencyId) {
    final currentList = state ?? [];
    state = currentList.where((c) => c.id != currencyId).toList();
  }

  // Update a currency optimistically
  void optimisticallyUpdate(String currencyId, Currency updatedCurrency) {
    final currentList = state ?? [];
    state = currentList.map((c) => c.id == currencyId ? updatedCurrency : c).toList();
  }

  // Reset local state (sync with remote)
  void reset() {
    state = null;
  }

  // Check if we have local state
  bool hasLocalState() {
    return state != null;
  }
}

// ============================================================================
// Effective Company Currencies Provider
// ============================================================================

/// Effective company currencies provider that uses local state when available
@riverpod
AsyncValue<List<Currency>> effectiveCompanyCurrencies(Ref ref) {
  final localState = ref.watch(localCurrencyListProvider);
  final remoteState = ref.watch(companyCurrenciesStreamProvider);

  // If we have local state, use it
  if (localState != null) {
    return AsyncValue.data(localState);
  }

  // Schedule initialization for next frame to avoid modifying during build
  remoteState.whenData((currencies) {
    Future.microtask(() {
      ref.read(localCurrencyListProvider.notifier).initializeFromRemote(currencies);
    });
  });

  return remoteState;
}

// ============================================================================
// Search Filtered Currencies Provider
// ============================================================================

/// Combined provider that listens to search query changes and uses effective currencies
@riverpod
AsyncValue<List<Currency>> searchFilteredCurrencies(Ref ref) {
  final companyCurrencies = ref.watch(effectiveCompanyCurrenciesProvider);
  final searchQuery = ref.watch(currencySearchQueryProvider).toLowerCase();

  return companyCurrencies.when(
    data: (currencies) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(currencies);
      }

      final filtered = currencies.where((currency) {
        return currency.name.toLowerCase().contains(searchQuery) ||
            currency.code.toLowerCase().contains(searchQuery) ||
            currency.fullName.toLowerCase().contains(searchQuery);
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
}

// ============================================================================
// Available Currencies to Add Provider
// ============================================================================

/// Available currencies to add provider that filters out already added currencies
@riverpod
Future<List<CurrencyType>> availableCurrenciesToAdd(Ref ref) async {
  final allTypes = await ref.watch(availableCurrencyTypesProvider.future);
  final companyCurrencies = ref.watch(effectiveCompanyCurrenciesProvider);

  return companyCurrencies.when(
    data: (currencies) {
      final companyCurrencyIds = currencies.map((c) => c.id).toSet();
      return allTypes.where((type) => !companyCurrencyIds.contains(type.currencyId)).toList();
    },
    loading: () => [],
    error: (_, __) => allTypes,
  );
}
