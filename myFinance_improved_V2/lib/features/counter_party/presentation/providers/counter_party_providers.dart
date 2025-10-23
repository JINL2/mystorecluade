import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/counter_party_data_source.dart';
import '../../data/repositories/counter_party_repository_impl.dart';
import '../../domain/entities/counter_party.dart';
import '../../domain/entities/counter_party_stats.dart';
import '../../domain/repositories/counter_party_repository.dart';
import '../../domain/value_objects/counter_party_filter.dart';
import '../../domain/value_objects/counter_party_type.dart';

// ============================================================================
// Repository Providers
// ============================================================================

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Data source provider
final counterPartyDataSourceProvider = Provider<CounterPartyDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CounterPartyDataSource(client);
});

/// Repository provider
final counterPartyRepositoryProvider = Provider<CounterPartyRepository>((ref) {
  final dataSource = ref.watch(counterPartyDataSourceProvider);
  return CounterPartyRepositoryImpl(dataSource);
});

// ============================================================================
// State Providers
// ============================================================================

/// Search query provider
final counterPartySearchProvider = StateProvider<String>((ref) => '');

/// Filter provider
final counterPartyFilterProvider = StateProvider<CounterPartyFilter>((ref) {
  return const CounterPartyFilter();
});

// ============================================================================
// Data Providers
// ============================================================================

/// Combined data model for optimized fetching
class CounterPartyData {
  final List<CounterParty> counterParties;
  final CounterPartyStats stats;
  final DateTime fetchedAt;

  const CounterPartyData({
    required this.counterParties,
    required this.stats,
    required this.fetchedAt,
  });

  bool get isStale => DateTime.now().difference(fetchedAt).inSeconds > 30;
}

/// Optimized base provider - Single source of truth
final optimizedCounterPartyDataProvider =
    FutureProvider.family<CounterPartyData, String>((ref, companyId) async {
  final repository = ref.watch(counterPartyRepositoryProvider);

  try {
    // Single database query
    final counterParties = await repository.getCounterParties(
      companyId: companyId,
      filter: const CounterPartyFilter(
        sortBy: CounterPartySortOption.createdAt,
        ascending: false,
      ),
    );

    // Efficient statistics calculation
    final stats = _calculateStatsEfficiently(counterParties);

    return CounterPartyData(
      counterParties: counterParties,
      stats: stats,
      fetchedAt: DateTime.now(),
    );
  } catch (e) {
    throw Exception('Failed to load counter party data: $e');
  }
});

/// Efficient statistics calculation
CounterPartyStats _calculateStatsEfficiently(List<CounterParty> counterParties) {
  int total = 0;
  int suppliers = 0;
  int customers = 0;
  int employees = 0;
  int teamMembers = 0;
  int myCompanies = 0;
  int others = 0;
  int activeCount = 0;
  int inactiveCount = 0;
  final List<CounterParty> recentAdditions = [];

  for (final cp in counterParties) {
    total++;

    switch (cp.type) {
      case CounterPartyType.supplier:
        suppliers++;
        break;
      case CounterPartyType.customer:
        customers++;
        break;
      case CounterPartyType.employee:
        employees++;
        break;
      case CounterPartyType.teamMember:
        teamMembers++;
        break;
      case CounterPartyType.myCompany:
        myCompanies++;
        break;
      case CounterPartyType.other:
        others++;
        break;
    }

    if (cp.isDeleted) {
      inactiveCount++;
    } else {
      activeCount++;
    }

    if (recentAdditions.length < 5) {
      recentAdditions.add(cp);
    }
  }

  return CounterPartyStats(
    total: total,
    suppliers: suppliers,
    customers: customers,
    employees: employees,
    teamMembers: teamMembers,
    myCompanies: myCompanies,
    others: others,
    activeCount: activeCount,
    inactiveCount: inactiveCount,
    recentAdditions: recentAdditions,
  );
}

/// Apply sorting efficiently
List<CounterParty> _applySorting(
  List<CounterParty> counterParties,
  CounterPartySortOption sortBy,
  bool ascending,
) {
  final sortedList = List<CounterParty>.from(counterParties);

  switch (sortBy) {
    case CounterPartySortOption.name:
      sortedList.sort((a, b) {
        final comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        return ascending ? comparison : -comparison;
      });
      break;

    case CounterPartySortOption.type:
      sortedList.sort((a, b) {
        final comparison = a.type.displayName.compareTo(b.type.displayName);
        return ascending ? comparison : -comparison;
      });
      break;

    case CounterPartySortOption.createdAt:
      sortedList.sort((a, b) {
        final comparison = a.createdAt.compareTo(b.createdAt);
        return ascending ? comparison : -comparison;
      });
      break;

    case CounterPartySortOption.isInternal:
      sortedList.sort((a, b) {
        final comparison =
            a.isInternal.toString().compareTo(b.isInternal.toString());
        return ascending ? comparison : -comparison;
      });
      break;
  }

  return sortedList;
}

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

      // Apply sorting
      counterParties = _applySorting(counterParties, filter.sortBy, filter.ascending);

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
  final repository = ref.watch(counterPartyRepositoryProvider);
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
  final repository = ref.watch(counterPartyRepositoryProvider);
  return await repository.updateCounterParty(
    counterpartyId: params.counterpartyId,
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
  final repository = ref.watch(counterPartyRepositoryProvider);
  return await repository.deleteCounterParty(counterpartyId);
});

/// Get unlinked companies provider
final unlinkedCompaniesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(counterPartyRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = ref.watch(selectedCompanyIdProvider);

  if (companyId == null || appState.user.isEmpty) {
    return [];
  }

  final userId = appState.user['user_id'] as String;

  return await repository.getUnlinkedCompanies(
    userId: userId,
    companyId: companyId,
  );
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

class CreateCounterPartyParams {
  final String companyId;
  final String name;
  final CounterPartyType type;
  final String? email;
  final String? phone;
  final String? address;
  final String? notes;
  final bool isInternal;
  final String? linkedCompanyId;

  CreateCounterPartyParams({
    required this.companyId,
    required this.name,
    required this.type,
    this.email,
    this.phone,
    this.address,
    this.notes,
    this.isInternal = false,
    this.linkedCompanyId,
  });
}

class UpdateCounterPartyParams {
  final String counterpartyId;
  final String name;
  final CounterPartyType type;
  final String? email;
  final String? phone;
  final String? address;
  final String? notes;
  final bool isInternal;
  final String? linkedCompanyId;

  UpdateCounterPartyParams({
    required this.counterpartyId,
    required this.name,
    required this.type,
    this.email,
    this.phone,
    this.address,
    this.notes,
    this.isInternal = false,
    this.linkedCompanyId,
  });
}

class UnlinkedCompaniesParams {
  final String userId;
  final String companyId;

  UnlinkedCompaniesParams({
    required this.userId,
    required this.companyId,
  });
}
