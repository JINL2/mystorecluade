import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/counter_party_providers.dart' as di;
import '../../domain/entities/counter_party.dart';
import '../../domain/entities/counter_party_stats.dart';
import '../../domain/value_objects/counter_party_filter.dart';
import 'counter_party_data.dart';
import 'counter_party_params.dart';

// ============================================================================
// State Providers
// ============================================================================

/// Search query provider
final counterPartySearchProvider = StateProvider<String>((ref) => '');

/// Filter provider
final counterPartyFilterProvider = StateProvider<CounterPartyFilter>((ref) {
  return const CounterPartyFilter();
});

/// Optimized base provider - Single source of truth
final optimizedCounterPartyDataProvider =
    FutureProvider.family<CounterPartyData, String>((ref, companyId) async {
  final repository = ref.watch(di.counterPartyRepositoryProvider);
  final calculateStats = ref.watch(di.calculateCounterPartyStatsProvider);

  try {
    // Single database query
    final counterParties = await repository.getCounterParties(
      companyId: companyId,
      filter: const CounterPartyFilter(
        sortBy: CounterPartySortOption.createdAt,
        ascending: false,
      ),
    );

    // Efficient statistics calculation using UseCase
    final stats = calculateStats(counterParties);

    return CounterPartyData(
      counterParties: counterParties,
      stats: stats,
      fetchedAt: DateTime.now(),
    );
  } catch (e) {
    throw Exception('Failed to load counter party data: $e');
  }
});

// Selected company ID provider (from app state)
final selectedCompanyIdProvider = Provider<String?>((ref) {
  final appState = ref.watch(appStateProvider);
  final companyChoosen = appState.companyChoosen;
  if (companyChoosen.isEmpty) return null;
  return companyChoosen;
});

/// Optimized counter parties provider - derived from base data
final optimizedCounterPartiesProvider =
    Provider<AsyncValue<List<CounterParty>>>((ref) {
  final companyId = ref.watch(selectedCompanyIdProvider);
  final filter = ref.watch(counterPartyFilterProvider);
  final sortUseCase = ref.watch(di.sortCounterPartiesProvider);

  if (companyId == null) {
    return const AsyncValue.data([]);
  }
  final dataAsync = ref.watch(optimizedCounterPartyDataProvider(companyId));

  return dataAsync.when(
    data: (data) {
      var counterParties = data.counterParties;

      // Apply filters
      if (filter.types != null && filter.types!.isNotEmpty) {
        counterParties = counterParties
            .where((cp) => filter.types!.contains(cp.type))
            .toList();
      }

      if (filter.isInternal != null) {
        counterParties = counterParties
            .where((cp) => cp.isInternal == filter.isInternal!)
            .toList();
      }

      // Apply search filter
      final searchQuery = ref.watch(counterPartySearchProvider);
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        counterParties = counterParties.where((cp) {
          return cp.name.toLowerCase().contains(query) ||
              (cp.email?.toLowerCase().contains(query) ?? false) ||
              (cp.phone?.contains(query) ?? false);
        }).toList();
      }

      // Apply sorting using UseCase
      counterParties = sortUseCase(counterParties, filter.sortBy, filter.ascending);

      return AsyncValue.data(counterParties);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

/// Optimized stats provider
final optimizedCounterPartyStatsProvider =
    Provider<AsyncValue<CounterPartyStats>>((ref) {
  final companyId = ref.watch(selectedCompanyIdProvider);

  if (companyId == null) {
    return AsyncValue.data(CounterPartyStats.empty());
  }
  final dataAsync = ref.watch(optimizedCounterPartyDataProvider(companyId));

  return dataAsync.when(
    data: (data) => AsyncValue.data(data.stats),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// ============================================================================
// Action Providers
// ============================================================================

/// Create counter party provider
final createCounterPartyProvider = FutureProvider.autoDispose
    .family<CounterParty, CreateCounterPartyParams>((ref, params) async {
  final repository = ref.watch(di.counterPartyRepositoryProvider);
  return await repository.createCounterParty(
    companyId: params.companyId,
    name: params.name,
    type: params.type,
    email: params.email,
    phone: params.phone,
    address: params.address,
    notes: params.notes,
    isInternal: params.isInternal,
    linkedCompanyId: params.linkedCompanyId,
  );
});

/// Update counter party provider
final updateCounterPartyProvider = FutureProvider.autoDispose
    .family<CounterParty, UpdateCounterPartyParams>((ref, params) async {
  final repository = ref.watch(di.counterPartyRepositoryProvider);
  return await repository.updateCounterParty(
    counterpartyId: params.counterpartyId,
    companyId: params.companyId,
    name: params.name,
    type: params.type,
    email: params.email,
    phone: params.phone,
    address: params.address,
    notes: params.notes,
    isInternal: params.isInternal,
    linkedCompanyId: params.linkedCompanyId,
  );
});

/// Delete counter party provider
final deleteCounterPartyProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, counterpartyId) async {
  final repository = ref.watch(di.counterPartyRepositoryProvider);
  return await repository.deleteCounterParty(counterpartyId);
});

/// Get unlinked companies provider
final unlinkedCompaniesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(di.counterPartyRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = ref.watch(selectedCompanyIdProvider);

  debugPrint('🏢 [unlinkedCompaniesProvider] companyId: $companyId');
  debugPrint('🏢 [unlinkedCompaniesProvider] appState.user: ${appState.user}');

  if (companyId == null || appState.user.isEmpty) {
    debugPrint('⚠️ [unlinkedCompaniesProvider] Early return: companyId=$companyId, user.isEmpty=${appState.user.isEmpty}');
    return [];
  }

  // Safe type checking instead of unsafe cast
  final userId = appState.user['user_id'];
  debugPrint('🏢 [unlinkedCompaniesProvider] userId: $userId (type: ${userId.runtimeType})');

  if (userId is! String) {
    debugPrint('⚠️ [unlinkedCompaniesProvider] userId is not String: ${userId.runtimeType}');
    return [];
  }

  final result = await repository.getUnlinkedCompanies(
    userId: userId,
    companyId: companyId,
  );
  debugPrint('✅ [unlinkedCompaniesProvider] Got ${result.length} companies');
  return result;
});

/// Manual refresh functionality
final counterPartyRefreshProvider = Provider<void Function()>((ref) {
  return () {
    final companyId = ref.read(selectedCompanyIdProvider);
    if (companyId != null) {
      ref.invalidate(optimizedCounterPartyDataProvider(companyId));
    }
  };
});

/// Cache management provider
final counterPartyCacheProvider = Provider<CounterPartyCacheManager>((ref) {
  return CounterPartyCacheManager(ref);
});

class CounterPartyCacheManager {
  final Ref ref;

  CounterPartyCacheManager(this.ref);

  bool isCacheFresh(String companyId) {
    final dataAsync = ref.read(optimizedCounterPartyDataProvider(companyId));
    return dataAsync.maybeWhen(
      data: (data) => !data.isStale,
      orElse: () => false,
    );
  }

  void refreshIfStale(String companyId) {
    if (!isCacheFresh(companyId)) {
      ref.invalidate(optimizedCounterPartyDataProvider(companyId));
    }
  }

  void clearCache() {
    ref.invalidate(optimizedCounterPartyDataProvider);
  }
}

// ============================================================================
// Parameter Classes
// ============================================================================
// Now using Freezed classes from counter_party_params.dart
