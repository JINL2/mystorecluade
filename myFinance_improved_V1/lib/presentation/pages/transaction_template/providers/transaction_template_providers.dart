import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/presentation/providers/auth_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import '../models/transaction_template_model.dart';

/// Provider for user data with companies (integrates with app state)
/// This is exactly the same as homepage providers to maintain consistency
final userCompaniesProvider = FutureProvider<dynamic>((ref) async {
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  // Watch app state to rebuild when data changes
  final appState = ref.watch(appStateProvider);
  
  if (user == null) {
    throw Exception('User not authenticated');
  }
  
  // Check if we need to refresh (no cached data)
  final needsRefresh = !appStateNotifier.hasUserData;
  
  // Check if we have cached data and don't need to refresh
  if (appStateNotifier.hasUserData && !needsRefresh) {
    print('TransactionTemplate UserCompaniesProvider: Using cached data');
    return appState.user;
  }
  
  // Fetch fresh data from API using RPC function
  print('TransactionTemplate UserCompaniesProvider: Fetching fresh data from API for user: ${user.id}');
  
  // Call get_user_companies_and_stores(user_id) RPC
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  print('TransactionTemplate UserCompaniesProvider: Fetched ${companies.length} companies');
  
  // Auto-select first company if none selected
  if (appState.companyChoosen.isEmpty && companies.isNotEmpty) {
    await appStateNotifier.setCompanyChoosen(companies.first['company_id']);
  }
  
  return response;
});

/// Provider for categories with features filtered by permissions
/// This is exactly the same as homepage providers to maintain consistency
final categoriesWithFeaturesProvider = FutureProvider<dynamic>((ref) async {
  // Watch app state to rebuild when data changes
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  print('TransactionTemplate CategoriesProvider: App state companyChoosen: ${appState.companyChoosen}');
  
  // Check if we need to refresh (no cached data)
  final needsRefresh = !appStateNotifier.hasCategoryFeatures;
  
  // Check if we have cached categories and don't need to refresh
  if (appStateNotifier.hasCategoryFeatures && !needsRefresh) {
    print('TransactionTemplate CategoriesProvider: Using cached categories');
    return appState.categoryFeatures;
  }
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    print('TransactionTemplate CategoriesProvider: No selected company, returning empty list');
    return [];
  }
  
  print('TransactionTemplate CategoriesProvider: Selected company: ${selectedCompany['company_name']}');
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  print('TransactionTemplate CategoriesProvider: User permissions count: ${permissions.length}');
  
  // Fetch all categories with features using RPC
  final supabase = Supabase.instance.client;
  final categories = await supabase.rpc('get_categories_with_features');
  print('TransactionTemplate CategoriesProvider: Fetched ${(categories as List).length} categories from RPC');
  
  // Filter features based on user permissions
  final filteredCategories = [];
  for (final category in categories) {
    final features = category['features'] as List<dynamic>? ?? [];
    final filteredFeatures = features.where((feature) {
      return permissions.contains(feature['feature_id']);
    }).toList();
    
    print('TransactionTemplate CategoriesProvider: Category "${category['category_name']}" has ${filteredFeatures.length}/${features.length} permitted features');
    
    if (filteredFeatures.isNotEmpty) {
      filteredCategories.add({
        'category_id': category['category_id'],
        'category_name': category['category_name'],
        'features': filteredFeatures,
      });
    }
  }
  
  // Save to app state for persistence
  await appStateNotifier.setCategoryFeatures(filteredCategories);
  
  print('TransactionTemplate CategoriesProvider: Returning ${filteredCategories.length} filtered categories');
  return filteredCategories;
});

// Provider for fetching transaction templates from Supabase
final transactionTemplatesProvider = FutureProvider<List<TransactionTemplate>>((ref) async {
  // Get app state for company and store IDs
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  
  // Get current user for visibility filtering
  final currentUser = ref.watch(authStateProvider);
  
  // Return empty list if no company selected
  if (companyId.isEmpty) {
    print('TransactionTemplates: No company selected, returning empty list');
    return [];
  }
  
  if (currentUser == null) {
    print('TransactionTemplates: No user authenticated, returning empty list');
    return [];
  }
  
  try {
    final supabase = Supabase.instance.client;
    
    // Query transaction_templates table with filters
    final query = supabase
        .from('transaction_templates')
        .select('template_id, name, data, permission, tags, visibility_level, is_active, updated_by, company_id, store_id, counterparty_id, counterparty_cash_location_id')
        .eq('company_id', companyId)
        .eq('is_active', true); // Only get active templates
    
    // Add store filter if store is selected
    if (storeId.isNotEmpty) {
      // Get templates that are either for this specific store OR company-wide (null store_id)
      final response = await query.or('store_id.eq.$storeId,store_id.is.null');
      
      // Ensure response is a List
      final responseList = response is List ? response : [response];
      
      print('TransactionTemplates: Fetched ${responseList.length} templates for company: $companyId and store: $storeId');
      
      // Filter templates based on visibility level
      final filteredTemplates = responseList.where((item) {
        final template = item as Map<String, dynamic>;
        final visibilityLevel = template['visibility_level']?.toString() ?? 'public';
        final updatedBy = template['updated_by']?.toString() ?? '';
        
        // If template is public, show to everyone
        if (visibilityLevel == 'public') {
          return true;
        }
        
        // If template is private, only show to the creator
        if (visibilityLevel == 'private') {
          return updatedBy == currentUser.id;
        }
        
        // Default to not showing (shouldn't reach here)
        return false;
      }).toList();
      
      print('TransactionTemplates: After visibility filtering, showing ${filteredTemplates.length} templates');
      
      // Convert to TransactionTemplate models
      final templates = filteredTemplates
          .map((json) => TransactionTemplate.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return templates;
    } else {
      // If no store selected, get only company-wide templates (store_id is null)
      final response = await query.isFilter('store_id', null);
      
      // Ensure response is a List
      final responseList = response is List ? response : [response];
      
      print('TransactionTemplates: Fetched ${responseList.length} company-wide templates for company: $companyId');
      
      // Filter templates based on visibility level
      final filteredTemplates = responseList.where((item) {
        final template = item as Map<String, dynamic>;
        final visibilityLevel = template['visibility_level']?.toString() ?? 'public';
        final updatedBy = template['updated_by']?.toString() ?? '';
        
        // If template is public, show to everyone
        if (visibilityLevel == 'public') {
          return true;
        }
        
        // If template is private, only show to the creator
        if (visibilityLevel == 'private') {
          return updatedBy == currentUser.id;
        }
        
        // Default to not showing (shouldn't reach here)
        return false;
      }).toList();
      
      print('TransactionTemplates: After visibility filtering, showing ${filteredTemplates.length} templates');
      
      // Convert to TransactionTemplate models
      final templates = filteredTemplates
          .map((json) => TransactionTemplate.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return templates;
    }
  } catch (e) {
    print('TransactionTemplates: Error fetching templates: $e');
    throw Exception('Failed to fetch transaction templates: $e');
  }
});

// Provider for fetching all accounts
final accountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Query all accounts from the accounts table
    final response = await supabase
        .from('accounts')
        .select('account_id, account_name, category_tag')
        .order('account_name');
    
    print('Accounts: Fetched ${response.length} accounts');
    
    // Filter out fixedAsset accounts for transaction templates
    final filteredAccounts = response.where((account) {
      final categoryTag = account['category_tag']?.toString().toLowerCase() ?? '';
      return categoryTag != 'fixedasset';
    }).toList();
    
    print('Accounts: Filtered to ${filteredAccounts.length} accounts (excluded fixedAsset)');
    
    return List<Map<String, dynamic>>.from(filteredAccounts);
  } catch (e) {
    print('Accounts: Error fetching accounts: $e');
    throw Exception('Failed to fetch accounts: $e');
  }
});

// Provider for fetching cash locations
final cashLocationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty) {
      print('CashLocations: No company selected, returning empty list');
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
    
    print('CashLocations: Fetched ${response.length} cash locations');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('CashLocations: Error fetching cash locations: $e');
    throw Exception('Failed to fetch cash locations: $e');
  }
});

// Provider for fetching counterparties
final counterpartiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      print('Counterparties: No company selected, returning empty list');
      return [];
    }
    
    // Query counterparties filtered by company_id
    final response = await supabase
        .from('counterparties')
        .select('counterparty_id, name, is_internal, linked_company_id')
        .eq('company_id', companyId)
        .order('name');
    
    print('Counterparties: Fetched ${response.length} counterparties');
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Counterparties: Error fetching counterparties: $e');
    throw Exception('Failed to fetch counterparties: $e');
  }
});

// Provider for fetching cash locations by company ID (for counterparty cash locations)
final counterpartyCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, linkedCompanyId) async {
  try {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) {
      print('CounterpartyCashLocations: No linked company ID, returning empty list');
      return [];
    }
    
    final supabase = Supabase.instance.client;
    
    // Query cash locations filtered by the linked_company_id
    final response = await supabase
        .from('cash_locations')
        .select('cash_location_id, location_name, location_type')
        .eq('company_id', linkedCompanyId)
        .order('location_name');
    
    print('CounterpartyCashLocations: Fetched ${response.length} cash locations for company: $linkedCompanyId');
    
    // Add "None" option at the beginning (it should be first in the list)
    final locations = <Map<String, dynamic>>[
      {'cash_location_id': null, 'location_name': 'None', 'location_type': 'none'},
    ];
    
    // Add the rest of the locations
    locations.addAll(List<Map<String, dynamic>>.from(response));
    
    return locations;
  } catch (e) {
    print('CounterpartyCashLocations: Error fetching cash locations: $e');
    throw Exception('Failed to fetch counterparty cash locations: $e');
  }
});

// Provider for creating a new transaction template
final createTransactionTemplateProvider = Provider<Future<void> Function(Map<String, dynamic>)>((ref) {
  return (Map<String, dynamic> templateData) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    final user = ref.read(authStateProvider);
    
    if (companyId.isEmpty) {
      throw Exception('No company selected');
    }
    
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    try {
      final supabase = Supabase.instance.client;
      
      // Get current timestamp in required format
      final now = DateTime.now();
      final timestamp = now.toIso8601String().replaceAll('T', ' ').substring(0, 23);
      
      // Prepare the template data
      final data = {
        'name': templateData['name'],
        'data': templateData['data'], // JSON array structure
        'company_id': companyId,
        'store_id': storeId.isNotEmpty ? storeId : null,
        'permission': templateData['permission'], // UUID for manager or all
        'tags': templateData['tags'], // JSON structure with accounts, category, cash_locations
        'visibility_level': templateData['visibility_level'], // private or public
        'counterparty_id': templateData['counterparty_id'], // Store the main counterparty ID
        'counterparty_cash_location_id': templateData['counterparty_cash_location_id'], // Store counterparty cash location ID
        'is_active': true,
        'created_at': timestamp,
        'updated_at': timestamp,
        'updated_by': user.id,
      };
      
      await supabase.from('transaction_templates').insert(data);
      
      // Invalidate the templates provider to refresh the list
      ref.invalidate(transactionTemplatesProvider);
      
      print('TransactionTemplate: Created new template successfully');
    } catch (e) {
      print('TransactionTemplate: Error creating template: $e');
      throw Exception('Failed to create transaction template: $e');
    }
  };
});

// Provider for executing a transaction template (creating actual transactions)
final executeTransactionTemplateProvider = Provider<Future<void> Function(TransactionTemplate, double, {Map<String, dynamic>? debtInfo})>((ref) {
  return (TransactionTemplate template, double amount, {Map<String, dynamic>? debtInfo}) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    final user = ref.read(authStateProvider);
    
    if (companyId.isEmpty) {
      throw Exception('No company selected');
    }
    
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    try {
      final supabase = Supabase.instance.client;
      
      // Get current timestamp with proper PostgreSQL format
      final now = DateTime.now();
      final entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
      
      // Parse template data (array of transactions)
      final templateTransactions = template.data as List;
      final pLines = <Map<String, dynamic>>[];
      
      // Create journal lines from template
      for (final templateTx in templateTransactions) {
        final isDebit = templateTx['type'] == 'debit';
        final categoryTag = templateTx['category_tag']?.toString().toLowerCase() ?? '';
        
        // Prepare basic line data
        final line = <String, dynamic>{
          'account_id': templateTx['account_id'],
          'description': (templateTx['description'] != null && templateTx['description'].toString().isNotEmpty) 
              ? templateTx['description'] 
              : null,
          'debit': isDebit ? amount.toString() : '0',
          'credit': isDebit ? '0' : amount.toString(),
        };
        
        // Add cash location if account is cash type
        if (categoryTag == 'cash' && templateTx['cash_location_id'] != null) {
          line['cash'] = {
            'cash_location_id': templateTx['cash_location_id'],
          };
        }
        
        // Add counterparty if present (for payable/receivable accounts)
        if (templateTx['counterparty_id'] != null && templateTx['counterparty_id'] != '') {
          line['counterparty_id'] = templateTx['counterparty_id'];
        }
        
        // Add account mapping information if available (for internal counterparties)
        if ((categoryTag == 'payable' || categoryTag == 'receivable') && 
            debtInfo != null && 
            debtInfo['account_mapping'] != null) {
          final accountMapping = debtInfo['account_mapping'] as Map<String, dynamic>;
          // Store account mapping data with the transaction for reference
          line['account_mapping'] = {
            'my_account_id': accountMapping['my_account_id'],
            'linked_account_id': accountMapping['linked_account_id'],
            'direction': accountMapping['direction'],
          };
        }
        
        // Add debt information if this is a payable/receivable account with debt info
        if ((categoryTag == 'payable' || categoryTag == 'receivable') && 
            debtInfo != null && 
            templateTx['counterparty_id'] != null &&
            templateTx['counterparty_id'] != '') {
          final debt = {
            'direction': categoryTag,
            'category': debtInfo['category'] ?? 'other',
            'counterparty_id': templateTx['counterparty_id'],
            'original_amount': amount.toString(),
            'interest_rate': (debtInfo['interest_rate'] ?? 0.0).toString(),
            'interest_account_id': '',
            'interest_due_day': 0,
            'issue_date': debtInfo['issue_date'] ?? DateFormat('yyyy-MM-dd').format(now),
            'due_date': debtInfo['due_date'] ?? DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 30))),
            'description': debtInfo['description'] ?? '',
          };
          line['debt'] = debt;
        }
        
        pLines.add(line);
      }
      
      // Determine p_counterparty_id and p_if_cash_location_id from template and user input
      String? pCounterpartyId;
      String? pIfCashLocationId;
      
      // Use template's counterparty_id if available
      if (template.counterpartyId != null && template.counterpartyId!.isNotEmpty) {
        pCounterpartyId = template.counterpartyId;
      }
      
      // Use the counterparty cash location if provided (from user selection or template)
      if (debtInfo != null && debtInfo['counterparty_cash_location_id'] != null) {
        pIfCashLocationId = debtInfo['counterparty_cash_location_id'];
      } else if (template.counterpartyCashLocationId != null && template.counterpartyCashLocationId!.isNotEmpty) {
        pIfCashLocationId = template.counterpartyCashLocationId;
      }
      
      // Call the journal RPC with properly formatted parameters
      final response = await supabase.rpc(
        'insert_journal_with_everything',
        params: {
          'p_base_amount': amount,
          'p_company_id': companyId,
          'p_created_by': user.id,
          'p_description': null,  // Always send null for description since individual lines have their own descriptions
          'p_entry_date': entryDate,
          'p_lines': pLines,
          'p_counterparty_id': pCounterpartyId,
          'p_if_cash_location_id': pIfCashLocationId,
          'p_store_id': storeId.isNotEmpty ? storeId : null,
        },
      );
      
      print('ExecuteTemplate: Created journal entry from template "${template.name}" with amount: $amount');
      print('RPC Response: $response');
      
    } catch (e) {
      print('ExecuteTemplate: Error executing template: $e');
      throw Exception('Failed to execute transaction template: $e');
    }
  };
});