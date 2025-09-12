import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/data/services/supabase_service.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';

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
final counterpartiesForSelectionProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, accountId) async {
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
        .order('name');
    
    final List<dynamic> data = response;
    
    // Filter based on requirements
    return data.where((counterparty) {
      final isInternal = counterparty['is_internal'] as bool? ?? false;
      final counterpartyId = counterparty['counterparty_id'] as String?;
      
      // Include if not internal OR if internal and mapped
      return !isInternal || (isInternal && mappedIds.contains(counterpartyId));
    }).cast<Map<String, dynamic>>().toList();
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
final counterpartyByIdProvider = FutureProvider.family<Map<String, dynamic>?, String?>((ref, counterpartyId) async {
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