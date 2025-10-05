/// Entity Providers - State management for core entity data
///
/// Purpose: Manages core entity state and data access:
/// - Account data retrieval with filtering for template usage
/// - Cash location data with store-aware filtering
/// - Entity caching for improved performance
/// - Company and store context awareness
/// - Error handling and fallback mechanisms
///
/// Usage: ref.watch(accountsProvider), ref.watch(cashLocationsProvider)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../data/services/supabase_service.dart';
import '../../../../providers/app_state_provider.dart';
import 'template_user_and_entity_providers.dart';

// Provider for fetching all accounts (excluding fixedAsset)
final accountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabaseService = ref.read(supabaseServiceProvider);
    
    // Query all accounts from the accounts table
    final response = await supabaseService.client
        .from('accounts')
        .select('account_id, account_name, category_tag')
        .order('account_name');
    
    // Filter out fixedAsset accounts for transaction templates
    final filteredAccounts = response.where((account) {
      final categoryTag = account['category_tag']?.toString().toLowerCase() ?? '';
      return categoryTag != 'fixedasset';
    }).toList();
    
    return List<Map<String, dynamic>>.from(filteredAccounts);
  } catch (e) {
    throw Exception('Failed to fetch accounts: $e');
  }
});

// Note: cashLocationsProvider is available from the state layer
// Use: import 'template_user_and_entity_providers.dart';

// Note: accountByIdProvider is available globally
// Use: import '../../../../providers/entities/account_provider.dart';

// Note: cashLocationByIdProvider is available globally  
// Use: import '../../../../providers/entities/cash_location_provider.dart';

// Provider for filtered accounts by category
final accountsByCategoryProvider = Provider.family<List<Map<String, dynamic>>, String?>((ref, categoryTag) {
  final accountsAsync = ref.watch(accountsProvider);
  
  return accountsAsync.when(
    data: (accounts) {
      if (categoryTag == null || categoryTag.isEmpty) {
        return accounts;
      }
      
      return accounts.where((account) {
        final accountCategory = account['category_tag']?.toString().toLowerCase() ?? '';
        return accountCategory == categoryTag.toLowerCase();
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for cash accounts only
final cashAccountsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(accountsByCategoryProvider('cash'));
});

// Provider for payable accounts only
final payableAccountsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(accountsByCategoryProvider('payable'));
});

// Provider for receivable accounts only
final receivableAccountsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(accountsByCategoryProvider('receivable'));
});

// Provider for entity statistics
final entityStatsProvider = Provider<Map<String, int>>((ref) {
  final accountsAsync = ref.watch(accountsProvider);
  final cashLocationsAsync = ref.watch(cashLocationsProvider);
  
  return accountsAsync.when(
    data: (accounts) {
      final stats = <String, int>{
        'total_accounts': accounts.length,
        'cash_accounts': accounts.where((a) => a['category_tag'] == 'cash').length,
        'payable_accounts': accounts.where((a) => a['category_tag'] == 'payable').length,
        'receivable_accounts': accounts.where((a) => a['category_tag'] == 'receivable').length,
        'other_accounts': accounts.where((a) => 
          !['cash', 'payable', 'receivable'].contains(a['category_tag'])
        ).length,
      };
      
      cashLocationsAsync.whenData((locations) {
        stats['cash_locations'] = locations.length;
      });
      
      return stats;
    },
    loading: () => {'total_accounts': 0, 'cash_locations': 0},
    error: (_, __) => {'total_accounts': 0, 'cash_locations': 0, 'error': 1},
  );
});

// Provider to check if entities are loaded
final entitiesLoadedProvider = Provider<bool>((ref) {
  final accountsAsync = ref.watch(accountsProvider);
  final cashLocationsAsync = ref.watch(cashLocationsProvider);
  
  return accountsAsync.hasValue && cashLocationsAsync.hasValue;
});