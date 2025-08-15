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
      await _repository.addCompanyCurrency(companyId, currencyId);
      
      // Refresh the company currencies list
      _ref.invalidate(companyCurrenciesProvider);
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeCompanyCurrency(String currencyId) async {
    final appState = _ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      await _repository.removeCompanyCurrency(companyId, currencyId);
      
      // Refresh the company currencies list
      _ref.invalidate(companyCurrenciesProvider);
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
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

// Search query provider
final currencySearchQueryProvider = StateProvider<String>((ref) => '');

// Combined provider that listens to search query changes
final searchFilteredCurrenciesProvider = Provider<AsyncValue<List<Currency>>>((ref) {
  final companyCurrencies = ref.watch(companyCurrenciesProvider);
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