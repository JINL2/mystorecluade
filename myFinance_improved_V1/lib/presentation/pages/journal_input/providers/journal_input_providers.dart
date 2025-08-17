import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';

// Provider for the journal entry model
final journalEntryProvider = ChangeNotifierProvider<JournalEntryModel>((ref) {
  return JournalEntryModel();
});

// Provider for fetching accounts
final journalAccountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Query all accounts from the accounts table
    final response = await supabase
        .from('accounts')
        .select('account_id, account_name, category_tag')
        .order('account_name');
    
    print('Journal Accounts: Fetched ${response.length} accounts');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Journal Accounts: Error fetching accounts: $e');
    throw Exception('Failed to fetch accounts: $e');
  }
});

// Provider for fetching cash locations
final journalCashLocationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty) {
      print('Journal CashLocations: No company selected, returning empty list');
      return [];
    }
    
    // Build query based on store selection
    var query = supabase
        .from('cash_locations')
        .select('cash_location_id, location_name, location_type')
        .eq('company_id', companyId);
    
    // Filter by store_id
    if (storeId.isNotEmpty) {
      query = query.eq('store_id', storeId);
    } else {
      query = query.isFilter('store_id', null);
    }
    
    final response = await query.order('location_name');
    
    print('Journal CashLocations: Fetched ${response.length} cash locations');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Journal CashLocations: Error fetching cash locations: $e');
    throw Exception('Failed to fetch cash locations: $e');
  }
});

// Provider for fetching counterparties (old - kept for backward compatibility)
final journalCounterpartiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      print('Journal Counterparties: No company selected, returning empty list');
      return [];
    }
    
    // Query counterparties filtered by company_id
    final response = await supabase
        .from('counterparties')
        .select('counterparty_id, name, is_internal, linked_company_id')
        .eq('company_id', companyId)
        .order('name');
    
    print('Journal Counterparties: Fetched ${response.length} counterparties');
    
    // Debug: Print first few counterparties to see data structure
    if (response.isNotEmpty) {
      print('Sample counterparty data:');
      for (var i = 0; i < (response.length > 3 ? 3 : response.length); i++) {
        final cp = response[i];
        print('  Counterparty ${i + 1}:');
        print('    name: ${cp['name']}');
        print('    is_internal: ${cp['is_internal']} (type: ${cp['is_internal'].runtimeType})');
        print('    linked_company_id: ${cp['linked_company_id']} (type: ${cp['linked_company_id']?.runtimeType})');
      }
    }
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Journal Counterparties: Error fetching counterparties: $e');
    throw Exception('Failed to fetch counterparties: $e');
  }
});

// Provider for fetching filtered counterparties based on account selection
final journalFilteredCounterpartiesProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, accountCategoryTag) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      print('Journal Filtered Counterparties: No company selected, returning empty list');
      return [];
    }
    
    // If account category is not payable/receivable, return all counterparties
    if (accountCategoryTag == null || 
        (accountCategoryTag.toLowerCase() != 'payable' && 
         accountCategoryTag.toLowerCase() != 'receivable')) {
      print('Journal Filtered Counterparties: Not payable/receivable, returning all counterparties');
      return ref.watch(journalCounterpartiesProvider).value ?? [];
    }
    
    print('Journal Filtered Counterparties: Filtering for payable/receivable account');
    
    // Step 1: Get mapped counterparty IDs from account_mappings
    final mappingsResponse = await supabase
        .from('account_mappings')
        .select('counterparty_id')
        .eq('my_company_id', companyId);
    
    final mappedCounterpartyIds = List<String>.from(
      mappingsResponse.map((row) => row['counterparty_id'] as String)
    );
    
    print('Journal Filtered Counterparties: Found ${mappedCounterpartyIds.length} mapped counterparties');
    
    // Step 2: Get all counterparties for the company
    final allCounterparties = await supabase
        .from('counterparties')
        .select('counterparty_id, name, is_internal, linked_company_id')
        .eq('company_id', companyId)
        .order('name');
    
    // Step 3: Filter counterparties based on the rules
    final filteredCounterparties = allCounterparties.where((counterparty) {
      final counterpartyId = counterparty['counterparty_id'] as String;
      final isInternal = counterparty['is_internal'];
      
      // Convert is_internal to boolean
      bool isInternalBool = false;
      if (isInternal is bool) {
        isInternalBool = isInternal;
      } else if (isInternal is String) {
        isInternalBool = isInternal.toLowerCase() == 'true';
      } else if (isInternal == 1 || isInternal == '1') {
        isInternalBool = true;
      }
      
      // Include if:
      // 1. External counterparty (is_internal = false), OR
      // 2. Internal counterparty that has mapping
      if (!isInternalBool) {
        // External counterparty - always include
        return true;
      } else {
        // Internal counterparty - only include if it has mapping
        return mappedCounterpartyIds.contains(counterpartyId);
      }
    }).toList();
    
    print('Journal Filtered Counterparties: Returning ${filteredCounterparties.length} filtered counterparties');
    print('  - External counterparties: ${filteredCounterparties.where((c) {
      final isInternal = c['is_internal'];
      if (isInternal is bool) return !isInternal;
      if (isInternal is String) return isInternal.toLowerCase() != 'true';
      return isInternal != 1 && isInternal != '1';
    }).length}');
    print('  - Mapped internal counterparties: ${filteredCounterparties.where((c) {
      final isInternal = c['is_internal'];
      if (isInternal is bool) return isInternal;
      if (isInternal is String) return isInternal.toLowerCase() == 'true';
      return isInternal == 1 || isInternal == '1';
    }).length}');
    
    return List<Map<String, dynamic>>.from(filteredCounterparties);
  } catch (e) {
    print('Journal Filtered Counterparties: Error fetching filtered counterparties: $e');
    throw Exception('Failed to fetch filtered counterparties: $e');
  }
});

// Provider for fetching cash locations by company ID (for counterparty cash locations without store)
final journalCounterpartyCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, linkedCompanyId) async {
  try {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) {
      print('Journal CounterpartyCashLocations: No linked company ID, returning empty list');
      return [];
    }
    
    final supabase = Supabase.instance.client;
    
    // Query ALL cash locations for the company (including those with and without store_id)
    // This gives flexibility when company has no stores or when we want company-level cash locations
    final response = await supabase
        .from('cash_locations')
        .select('cash_location_id, location_name, location_type, store_id')
        .eq('company_id', linkedCompanyId)
        .order('location_name');
    
    print('Journal CounterpartyCashLocations: Fetched ${response.length} cash locations for company: $linkedCompanyId');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Journal CounterpartyCashLocations: Error fetching cash locations: $e');
    throw Exception('Failed to fetch counterparty cash locations: $e');
  }
});

// Provider for fetching cash locations by store ID (for counterparty cash locations with store)
final journalCounterpartyStoreCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, storeId) async {
  try {
    if (storeId == null || storeId.isEmpty) {
      print('Journal CounterpartyStoreCashLocations: No store ID, returning empty list');
      return [];
    }
    
    final supabase = Supabase.instance.client;
    
    // Query cash locations filtered by the store_id
    final response = await supabase
        .from('cash_locations')
        .select('cash_location_id, location_name, location_type')
        .eq('store_id', storeId)
        .order('location_name');
    
    print('Journal CounterpartyStoreCashLocations: Fetched ${response.length} cash locations for store: $storeId');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Journal CounterpartyStoreCashLocations: Error fetching cash locations: $e');
    throw Exception('Failed to fetch counterparty store cash locations: $e');
  }
});

// Provider for fetching stores by company ID (for counterparty stores when internal)
final journalCounterpartyStoresProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, linkedCompanyId) async {
  try {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) {
      print('Journal CounterpartyStores: No linked company ID, returning empty list');
      return [];
    }
    
    final supabase = Supabase.instance.client;
    
    // Query stores filtered by the company_id (linked_company_id of the counterparty)
    final response = await supabase
        .from('stores')
        .select('store_id, store_name')
        .eq('company_id', linkedCompanyId)
        .order('store_name');
    
    print('Journal CounterpartyStores: Fetched ${response.length} stores for company: $linkedCompanyId');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Journal CounterpartyStores: Error fetching stores: $e');
    throw Exception('Failed to fetch counterparty stores: $e');
  }
});

// Provider for checking account mapping
final checkAccountMappingProvider = Provider<Future<Map<String, dynamic>?> Function(String, String, String)>((ref) {
  return (String companyId, String counterpartyId, String accountId) async {
    try {
      final supabase = Supabase.instance.client;
      
      // Query account_mappings table
      final response = await supabase
          .from('account_mappings')
          .select('my_account_id, linked_account_id, direction')
          .eq('my_company_id', companyId)
          .eq('counterparty_id', counterpartyId)
          .eq('my_account_id', accountId)
          .maybeSingle();
      
      if (response != null) {
        return {
          'my_account_id': response['my_account_id'],
          'linked_account_id': response['linked_account_id'],
          'direction': response['direction'],
        };
      }
      
      return null;
    } catch (e) {
      print('Error checking account mapping: $e');
      return null;
    }
  };
});

// Provider for submitting journal entry
final submitJournalEntryProvider = Provider<Future<void> Function(JournalEntryModel)>((ref) {
  return (JournalEntryModel journalEntry) async {
    final appState = ref.read(appStateProvider);
    final user = ref.read(authStateProvider);
    
    if (journalEntry.selectedCompanyId == null) {
      throw Exception('No company selected');
    }
    
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    if (!journalEntry.canSubmit()) {
      throw Exception('Journal entry is not balanced or incomplete');
    }
    
    try {
      final supabase = Supabase.instance.client;
      
      // Use device's current time at the moment of submission
      final currentDeviceTime = DateTime.now();
      final entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(currentDeviceTime);
      
      print('Journal Entry: Submitting with device time: $entryDate');
      
      // Prepare journal lines
      final pLines = journalEntry.transactionLines.map((line) => line.toJson()).toList();
      
      // Determine main counterparty (if any)
      String? mainCounterpartyId;
      for (final line in journalEntry.transactionLines) {
        if (line.counterpartyId != null && line.counterpartyId!.isNotEmpty) {
          mainCounterpartyId = line.counterpartyId;
          break;
        }
      }
      
      // Get company and store from appState to ensure they're always current
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      // Call the journal RPC with properly formatted parameters
      final response = await supabase.rpc(
        'insert_journal_with_everything',
        params: {
          'p_base_amount': journalEntry.totalDebits,
          'p_company_id': companyId.isNotEmpty ? companyId : journalEntry.selectedCompanyId,
          'p_created_by': user.id,
          'p_description': journalEntry.overallDescription,
          'p_entry_date': entryDate,
          'p_lines': pLines,
          'p_counterparty_id': mainCounterpartyId,
          'p_if_cash_location_id': journalEntry.counterpartyCashLocationId,
          'p_store_id': storeId.isNotEmpty ? storeId : null,
        },
      );
      
      print('Journal Entry: Created journal entry successfully');
      print('RPC Response: $response');
      
      // Clear the journal entry after successful submission
      journalEntry.clear();
      
    } catch (e) {
      print('Journal Entry: Error creating journal entry: $e');
      throw Exception('Failed to create journal entry: $e');
    }
  };
});