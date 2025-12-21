/// Counterparty Providers - State management for counterparty data
///
/// Purpose: Manages counterparty-related state and data access:
/// - Mapped counterparty retrieval with account filtering
/// - Counterparty selection lists with internal/external filtering
/// - Account requirement validation for counterparty selection
/// - Linked company store data access
/// - Counterparty data caching and retrieval
///
/// Usage: ref.watch(counterpartiesForSelectionProvider(accountId))
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../data/services/supabase_service.dart';
import '../../../../providers/app_state_provider.dart';
import '../../../../../data/models/selector_entities.dart';

// Provider to fetch mapped counterparty IDs from account_mappings
final mappedCounterpartiesProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, accountId) async {
  if (accountId == null) return [];
  
  final supabaseService = ref.read(supabaseServiceProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) return [];
  
  try {
    final response = await supabaseService.client
        .from('account_mappings')
        .select('counterparty_id, my_account_id')
        .eq('my_company_id', companyId);
    
    final List<dynamic> data = response;
    // Filter to get mappings where my_account_id matches the selected account
    return data
        .where((item) => item['my_account_id'] == accountId)
        .cast<Map<String, dynamic>>()
        .toList();
  } catch (e) {
    print('Error fetching mapped counterparties: $e');
    return [];
  }
});

// Provider to fetch counterparties for selection
final counterpartiesForSelectionProvider = FutureProvider.family<List<CounterpartyData>, String?>((ref, accountId) async {
  if (accountId == null) return [];
  
  final supabaseService = ref.read(supabaseServiceProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) return [];
  
  final mappedCounterparties = await ref.watch(mappedCounterpartiesProvider(accountId).future);
  final mappedIds = mappedCounterparties.map((m) => m['counterparty_id'] as String).toList();
  
  try {
    // Fetch all counterparties that are either:
    // 1. Not internal and not deleted
    // 2. Internal but mapped to this account
    final response = await supabaseService.client
        .from('counterparties')
        .select('counterparty_id, name, is_internal, linked_company_id')
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .order('is_internal', ascending: false) // Internal first
        .order('name'); // Then by name
    
    final List<dynamic> data = response;
    
    // Filter based on requirements and convert to CounterpartyData
    return data.where((counterparty) {
      final isInternal = counterparty['is_internal'] as bool? ?? false;
      final counterpartyId = counterparty['counterparty_id'] as String?;
      
      // Include if not internal OR if internal and mapped
      return !isInternal || (isInternal && mappedIds.contains(counterpartyId));
    }).map((item) => CounterpartyData(
      id: item['counterparty_id'] as String,
      name: item['name'] as String,
      type: 'Customer', // Default type for template context
      isInternal: item['is_internal'] as bool? ?? false,
      transactionCount: 0, // Not needed in template context
    )).toList();
  } catch (e) {
    print('Error fetching counterparties: $e');
    return [];
  }
});

// Provider to check if an account requires counterparty selection
final accountRequiresCounterpartyProvider = Provider.family<bool, Map<String, dynamic>?>((ref, account) {
  if (account == null) return false;
  
  final categoryTag = account['category_tag'] as String?;
  return categoryTag == 'payable' || categoryTag == 'receivable';
});

// Provider to fetch a specific counterparty by ID
final counterpartyByIdProvider = FutureProvider.family<CounterpartyData?, String?>((ref, counterpartyId) async {
  if (counterpartyId == null || counterpartyId.isEmpty) return null;
  
  final supabaseService = ref.read(supabaseServiceProvider);
  
  try {
    final response = await supabaseService.client
        .from('counterparties')
        .select('counterparty_id, name, is_internal, linked_company_id, counterparty_type')
        .eq('counterparty_id', counterpartyId)
        .single();
    
    return CounterpartyData(
      id: response['counterparty_id'] as String,
      name: response['name'] as String,
      type: response['counterparty_type'] as String? ?? 'Customer',
      isInternal: response['is_internal'] as bool? ?? false,
      transactionCount: 0, // Not needed in template context
    );
  } catch (e) {
    print('Error fetching counterparty by ID: $e');
    return null;
  }
});

// Provider to fetch a specific counterparty as Map (for backward compatibility)
final counterpartyMapByIdProvider = FutureProvider.family<Map<String, dynamic>?, String?>((ref, counterpartyId) async {
  if (counterpartyId == null || counterpartyId.isEmpty) return null;
  
  final supabaseService = ref.read(supabaseServiceProvider);
  
  try {
    final response = await supabaseService.client
        .from('counterparties')
        .select('counterparty_id, name, is_internal, linked_company_id')
        .eq('counterparty_id', counterpartyId)
        .single();
    
    return response;
  } catch (e) {
    print('Error fetching counterparty by ID: $e');
    return null;
  }
});

// Provider to fetch stores for a linked company
final storesForLinkedCompanyProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, linkedCompanyId) async {
  if (linkedCompanyId == null || linkedCompanyId.isEmpty) return [];
  
  final supabaseService = ref.read(supabaseServiceProvider);
  
  try {
    final response = await supabaseService.client
        .from('stores')
        .select('store_id, store_name')
        .eq('company_id', linkedCompanyId)
        .order('store_name');
    
    return response.cast<Map<String, dynamic>>();
  } catch (e) {
    print('Error fetching stores for linked company: $e');
    return [];
  }
});

// Note: counterpartiesProvider is available from the state layer
// Use: import 'template_user_and_entity_providers.dart';

// Provider for fetching cash locations by company ID (for counterparty cash locations)
final counterpartyCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, linkedCompanyId) async {
  try {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) {
      return [];
    }
    
    final supabaseService = ref.read(supabaseServiceProvider);
    
    // Use RPC to get cash locations for the counterparty company
    final response = await supabaseService.client.rpc(
      'get_cash_locations',
      params: {
        'p_company_id': linkedCompanyId,
      },
    );
    
    if (response == null) {
      return [
        {'cash_location_id': null, 'location_name': 'None', 'location_type': 'none'},
      ];
    }

    // Add "None" option at the beginning
    final locations = <Map<String, dynamic>>[
      {'cash_location_id': null, 'location_name': 'None', 'location_type': 'none'},
    ];

    // Convert RPC response format to expected format and add to locations
    final convertedLocations = (response as List).map((loc) => {
      'cash_location_id': loc['id'],
      'location_name': loc['name'],
      'location_type': loc['type'],
    }).toList();
    
    // Sort by location name
    convertedLocations.sort((a, b) => 
      (a['location_name'] as String).compareTo(b['location_name'] as String)
    );
    
    locations.addAll(convertedLocations);
    
    return locations;
  } catch (e) {
    throw Exception('Failed to fetch counterparty cash locations: $e');
  }
});