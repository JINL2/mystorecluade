import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../domain/entities/currency.dart';
import '../../../../domain/repositories/currency_repository.dart';
import '../../../../data/repositories/supabase_currency_repository.dart';
import '../../../providers/app_state_provider.dart';

// Repository providers
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseCurrencyRepository(supabaseClient);
});

// Available currency types provider
final availableCurrencyTypesProvider = FutureProvider<List<CurrencyType>>((ref) async {
  final repository = ref.watch(currencyRepositoryProvider);
  return repository.getAvailableCurrencyTypes();
});

// Company currencies provider
final companyCurrenciesProvider = FutureProvider<List<Currency>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    throw Exception('No company selected');
  }
  
  final repository = ref.watch(currencyRepositoryProvider);
  return repository.getCompanyCurrencies(companyId);
});

// Company currencies stream provider for real-time updates
final companyCurrenciesStreamProvider = StreamProvider<List<Currency>>((ref) {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    return Stream.value([]);
  }
  
  final repository = ref.watch(currencyRepositoryProvider);
  return repository.watchCompanyCurrencies(companyId);
});

// Search functionality
class CurrencySearchNotifier extends StateNotifier<AsyncValue<List<CurrencyType>>> {
  CurrencySearchNotifier(this._repository) : super(const AsyncValue.data([]));
  
  final CurrencyRepository _repository;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final results = await _repository.searchCurrencyTypes(query.trim());
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

final currencySearchProvider = StateNotifierProvider<CurrencySearchNotifier, AsyncValue<List<CurrencyType>>>((ref) {
  final repository = ref.watch(currencyRepositoryProvider);
  return CurrencySearchNotifier(repository);
});

// Selected currency type for adding
final selectedCurrencyTypeProvider = StateProvider<String?>((ref) => null);

// Currency operations provider
class CurrencyOperationsNotifier extends StateNotifier<AsyncValue<void>> {
  CurrencyOperationsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));
  
  final CurrencyRepository _repository;
  final Ref _ref;

  Future<void> addCompanyCurrency(String currencyId) async {
    final appState = _ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      // First, get the currency type to create a full currency object for optimistic update
      final allTypes = await _repository.getAvailableCurrencyTypes();
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
      _ref.read(localCurrencyListProvider.notifier).optimisticallyAdd(optimisticCurrency);
      
      // Perform database operation in background
      await _repository.addCompanyCurrency(companyId, currencyId);
      
      // Refresh the remote providers after successful database operation
      _ref.invalidate(companyCurrenciesProvider);
      _ref.invalidate(companyCurrenciesStreamProvider);
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      // If database operation fails, revert the optimistic update
      _ref.read(localCurrencyListProvider.notifier).optimisticallyRemove(currencyId);
      
      // Enhanced error reporting
      final errorMessage = error.toString().contains('already exists') 
          ? 'This currency has already been added to your company'
          : 'Failed to add currency: Network error or server unavailable';
      
      state = AsyncValue.error(errorMessage, stackTrace);
    }
  }

  Future<void> removeCompanyCurrency(String currencyId) async {
    final appState = _ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    // Store the current currency for potential rollback
    final localNotifier = _ref.read(localCurrencyListProvider.notifier);
    final currentCurrencies = localNotifier.getCurrencies();
    final currencyToRemove = currentCurrencies.firstWhere((c) => c.id == currencyId);

    state = const AsyncValue.loading();
    
    try {
      // OPTIMISTIC UI UPDATE - Remove from local state immediately
      localNotifier.optimisticallyRemove(currencyId);
      
      // Perform database operation in background
      await _repository.removeCompanyCurrency(companyId, currencyId);
      
      // Refresh the remote providers after successful database operation
      _ref.invalidate(companyCurrenciesProvider);
      _ref.invalidate(companyCurrenciesStreamProvider);
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      // If database operation fails, revert the optimistic update
      localNotifier.optimisticallyAdd(currencyToRemove);
      
      // Enhanced error reporting
      final errorMessage = error.toString().contains('has denominations') 
          ? 'Cannot remove currency that has denominations. Delete all denominations first.'
          : 'Failed to remove currency: Network error or server unavailable';
      
      state = AsyncValue.error(errorMessage, stackTrace);
    }
  }

  Future<void> updateCompanyCurrency(String currencyId, {bool? isActive}) async {
    final appState = _ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      await _repository.updateCompanyCurrency(companyId, currencyId, isActive: isActive);
      
      // Refresh the company currencies list
      _ref.invalidate(companyCurrenciesProvider);
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void resetState() {
    state = const AsyncValue.data(null);
  }
}

final currencyOperationsProvider = StateNotifierProvider<CurrencyOperationsNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(currencyRepositoryProvider);
  return CurrencyOperationsNotifier(repository, ref);
});

// Expanded currencies state (which currencies are expanded in the UI)
final expandedCurrenciesProvider = StateProvider<Set<String>>((ref) => <String>{});

// Filtered currencies provider (for search functionality)
class FilteredCurrenciesNotifier extends StateNotifier<List<Currency>> {
  FilteredCurrenciesNotifier(this._ref) : super([]) {
    _ref.listen<AsyncValue<List<Currency>>>(companyCurrenciesProvider, (_, next) {
      next.when(
        data: (currencies) {
          _allCurrencies = currencies;
          _applyFilter();
        },
        loading: () {},
        error: (_, __) => state = [],
      );
    });
  }
  
  final Ref _ref;
  List<Currency> _allCurrencies = [];
  String _searchQuery = '';

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilter();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      state = _allCurrencies;
      return;
    }

    state = _allCurrencies.where((currency) {
      return currency.name.toLowerCase().contains(_searchQuery) ||
             currency.code.toLowerCase().contains(_searchQuery) ||
             currency.fullName.toLowerCase().contains(_searchQuery);
    }).toList();
  }
}

final filteredCurrenciesProvider = StateNotifierProvider<FilteredCurrenciesNotifier, List<Currency>>((ref) {
  return FilteredCurrenciesNotifier(ref);
});

// Search query provider with auto-dispose and explicit page lifecycle management
final currencySearchQueryProvider = StateProvider.autoDispose<String>((ref) {
  // Auto-dispose when no longer watched - ensures clean state on page exit
  return '';
});

// Page-specific search controller provider that manages TossSearchField state
final currencySearchControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) {
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
});

// Navigation-aware search state manager - simplified since all providers auto-dispose
final searchStateManagerProvider = Provider.autoDispose<void>((ref) {
  // This provider ensures all search-related providers are properly watched
  // and will auto-dispose when the page is no longer active
  ref.watch(currencySearchQueryProvider);
  return;
});

// Local currency list state for optimistic UI updates
class LocalCurrencyListNotifier extends StateNotifier<List<Currency>?> {
  LocalCurrencyListNotifier(this._ref) : super(null);
  
  final Ref _ref; // ignore: unused_field

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
    final updatedList = [...currentList, currency];
    state = updatedList;
  }

  // Optimistically remove currency from local state
  void optimisticallyRemove(String currencyId) {
    final currentList = state ?? [];
    final updatedList = currentList.where((c) => c.id != currencyId).toList();
    state = updatedList;
  }

  // Update a currency optimistically
  void optimisticallyUpdate(String currencyId, Currency updatedCurrency) {
    final currentList = state ?? [];
    final updatedList = currentList.map((c) => c.id == currencyId ? updatedCurrency : c).toList();
    state = updatedList;
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

final localCurrencyListProvider = StateNotifierProvider.autoDispose<LocalCurrencyListNotifier, List<Currency>?>((ref) {
  return LocalCurrencyListNotifier(ref);
});

// Effective company currencies provider that uses local state when available
final effectiveCompanyCurrenciesProvider = Provider.autoDispose<AsyncValue<List<Currency>>>((ref) {
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
});

// Combined provider with auto-dispose that listens to search query changes and uses effective currencies
final searchFilteredCurrenciesProvider = Provider.autoDispose<AsyncValue<List<Currency>>>((ref) {
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
});

// Available currencies to add provider that filters out already added currencies
final availableCurrenciesToAddProvider = FutureProvider.autoDispose<List<CurrencyType>>((ref) async {
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
});