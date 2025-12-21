import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/counter_party_models.dart';
import '../../../providers/app_state_provider.dart';
import 'counter_party_providers.dart';

/// OPTIMIZED Counter Party Providers - Performance Focused
/// 
/// Key Optimizations:
/// 1. Single database query for both list and stats
/// 2. Efficient single-pass statistics calculation
/// 3. Reduced provider dependencies
/// 4. Built-in caching and invalidation strategy

// Combined data model for optimized fetching
class CounterPartyData {
  final List<CounterParty> counterParties;
  final CounterPartyStats stats;
  final DateTime fetchedAt;

  const CounterPartyData({
    required this.counterParties,
    required this.stats,
    required this.fetchedAt,
  });

  // Check if data is stale (older than 30 seconds)
  bool get isStale => DateTime.now().difference(fetchedAt).inSeconds > 30;
}

// Optimized base provider - Single source of truth
final optimizedCounterPartyDataProvider = FutureProvider.family<CounterPartyData, String>((ref, companyId) async {
  final supabase = Supabase.instance.client;
  
  try {
    // Single database query
    final response = await supabase
        .from('counterparties')
        .select()
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .order('created_at', ascending: false);

    final counterParties = (response as List)
        .map((json) {
          try {
            return CounterParty.fromJson(json);
          } catch (e) {
            // Silently skip invalid records to continue processing
            return null;
          }
        })
        .where((cp) => cp != null)
        .cast<CounterParty>()
        .toList();

    // Efficient single-pass statistics calculation
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

// Efficient statistics calculation - single pass through the list
CounterPartyStats _calculateStatsEfficiently(List<CounterParty> counterParties) {
  // Initialize counters
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

  // Single pass calculation
  for (final cp in counterParties) {
    total++;
    
    // Count by type
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

    // Count by status
    if (cp.isDeleted) {
      inactiveCount++;
    } else {
      activeCount++;
    }

    // Collect recent additions (first 5 since ordered by created_at desc)
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

// Efficient sorting function
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
        final comparison = a.isInternal.toString().compareTo(b.isInternal.toString());
        return ascending ? comparison : -comparison;
      });
      break;
  }
  
  return sortedList;
}

// Optimized counter parties provider - derived from base data
final optimizedCounterPartiesProvider = Provider<AsyncValue<List<CounterParty>>>((ref) {
  final selectedCompany = ref.watch(selectedCompanyProvider);
  final filter = ref.watch(counterPartyFilterProvider);
  
  if (selectedCompany == null) {
    return const AsyncValue.data([]);
  }

  final dataAsync = ref.watch(optimizedCounterPartyDataProvider(selectedCompany['company_id']));
  
  return dataAsync.when(
    data: (data) {
      var counterParties = data.counterParties;
      
      // Apply filters efficiently
      if (filter.types != null && filter.types!.isNotEmpty) {
        counterParties = counterParties.where((cp) => filter.types!.contains(cp.type)).toList();
      }

      if (filter.isInternal != null) {
        counterParties = counterParties.where((cp) => cp.isInternal == filter.isInternal!).toList();
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

// Optimized stats provider - derived from base data
final optimizedCounterPartyStatsProvider = Provider<AsyncValue<CounterPartyStats>>((ref) {
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  if (selectedCompany == null) {
    return AsyncValue.data(CounterPartyStats.empty());
  }

  final dataAsync = ref.watch(optimizedCounterPartyDataProvider(selectedCompany['company_id']));
  
  return dataAsync.when(
    data: (data) => AsyncValue.data(data.stats),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Manual refresh functionality
final counterPartyRefreshProvider = Provider<VoidCallback>((ref) {
  return () {
    final selectedCompany = ref.read(selectedCompanyProvider);
    if (selectedCompany != null) {
      // Invalidate the base provider to trigger fresh data fetch
      ref.invalidate(optimizedCounterPartyDataProvider(selectedCompany['company_id']));
    }
  };
});

// Cache management provider
final counterPartyCacheProvider = Provider<CounterPartyCacheManager>((ref) {
  return CounterPartyCacheManager(ref);
});

class CounterPartyCacheManager {
  final Ref ref;
  
  CounterPartyCacheManager(this.ref);
  
  // Check if cache is fresh enough
  bool isCacheFresh(String companyId) {
    final dataAsync = ref.read(optimizedCounterPartyDataProvider(companyId));
    return dataAsync.maybeWhen(
      data: (data) => !data.isStale,
      orElse: () => false,
    );
  }
  
  // Force refresh if cache is stale
  void refreshIfStale(String companyId) {
    if (!isCacheFresh(companyId)) {
      ref.invalidate(optimizedCounterPartyDataProvider(companyId));
    }
  }
  
  // Clear all cache
  void clearCache() {
    // This will invalidate all instances of the family provider
    ref.invalidate(optimizedCounterPartyDataProvider);
  }
}