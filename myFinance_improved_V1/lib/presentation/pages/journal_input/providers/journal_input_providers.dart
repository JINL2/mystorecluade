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
    
    if (response == null) {
      // Handle null response gracefully
      return [];
    }
    
    final accounts = List<Map<String, dynamic>>.from(response);
    return accounts;
  } catch (e) {
    print('Error fetching accounts: $e');
    // Return empty list instead of throwing to prevent UI crash
    // The UI will show the error state
    throw Exception('Network error: Please check your connection and try again');
  }
});


// Provider for fetching counterparties (old - kept for backward compatibility)
final journalCounterpartiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      return [];
    }
    
    // Query counterparties filtered by company_id
    final response = await supabase
        .from('counterparties')
        .select('counterparty_id, name, is_internal, linked_company_id')
        .eq('company_id', companyId)
        .order('name');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    throw Exception('Failed to fetch counterparties: $e');
  }
});

// Note: Counterparty filtering is now handled by AutonomousCounterpartySelector widget

// Provider for fetching cash locations by company ID (for counterparty cash locations without store)
final journalCounterpartyCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, linkedCompanyId) async {
  try {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) {
      return [];
    }
    
    final supabase = Supabase.instance.client;
    
    // Use RPC to get ALL cash locations for the company (no store filter)
    final response = await supabase.rpc(
      'get_cash_locations',
      params: {
        'p_company_id': linkedCompanyId,
      },
    );
    
    // Convert RPC response to the expected format for backward compatibility
    final locations = (response as List).map((item) {
      return {
        'cash_location_id': item['id'],
        'location_name': item['name'],
        'location_type': item['type'],
        'store_id': item['storeId'],
      };
    }).toList();
    
    return locations;
  } catch (e) {
    throw Exception('Failed to fetch counterparty cash locations: $e');
  }
});

final journalCounterpartyStoreCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, storeId) async {
  try {
    if (storeId == null || storeId.isEmpty) {
      return [];
    }
    
    final supabase = Supabase.instance.client;
    final appState = ref.watch(appStateProvider);
    
    // Use RPC to get ALL cash locations for the company
    final response = await supabase.rpc(
      'get_cash_locations',
      params: {
        'p_company_id': appState.companyChoosen,
      },
    );
    
    // Convert RPC response to the expected format for backward compatibility
    // Filter to show only locations for the specific store
    final locations = (response as List)
        .where((item) => item['storeId'] == storeId)
        .map((item) {
      return {
        'cash_location_id': item['id'],
        'location_name': item['name'],
        'location_type': item['type'],
      };
    }).toList();
    
    return locations;
  } catch (e) {
    throw Exception('Failed to fetch counterparty store cash locations: $e');
  }
});

// Provider for fetching stores by company ID (for counterparty stores when internal)
final journalCounterpartyStoresProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, linkedCompanyId) async {
  try {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) {
      return [];
    }
    
    final supabase = Supabase.instance.client;
    
    // Query stores filtered by the company_id (linked_company_id of the counterparty)
    final response = await supabase
        .from('stores')
        .select('store_id, store_name')
        .eq('company_id', linkedCompanyId)
        .order('store_name');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
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
      await supabase.rpc(
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
      
      // Clear the journal entry after successful submission
      journalEntry.clear();
      
    } catch (e) {
      throw Exception('Failed to create journal entry: $e');
    }
  };
});