import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../providers/app_state_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../../data/services/template_cache_service.dart';

// Provider to watch user data from app state with authentication and caching
final templateUserProvider = Provider<dynamic>((ref) async {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final user = ref.watch(authStateProvider);
  
  if (user == null) {
    throw Exception('User not authenticated');
  }
  
  // Check if we need to refresh (no cached data)
  final needsRefresh = !appStateNotifier.hasUserData;
  
  // Check if we have cached data and don't need to refresh
  if (appStateNotifier.hasUserData && !needsRefresh) {
    return appState.user;
  }
  
  // Fetch fresh data from API using RPC function
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', 
    params: {'p_user_id': user.id}
  );
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  
  // Auto-select first company if none selected
  if (appState.companyChoosen.isEmpty && companies.isNotEmpty) {
    await appStateNotifier.setCompanyChoosen(companies.first['company_id']);
  }
  
  return response;
});

// Provider to watch categoryFeatures from app state with permission filtering
final templateCategoryFeaturesProvider = Provider<dynamic>((ref) async {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  // Check if we need to refresh (no cached data)
  final needsRefresh = !appStateNotifier.hasCategoryFeatures;
  
  // Check if we have cached categories and don't need to refresh
  if (appStateNotifier.hasCategoryFeatures && !needsRefresh) {
    return appState.categoryFeatures;
  }
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    return [];
  }
  
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  
  // Fetch all categories with features using RPC
  final supabase = Supabase.instance.client;
  final categories = await supabase.rpc('get_categories_with_features');
  
  // Filter features based on user permissions
  final filteredCategories = [];
  for (final category in categories) {
    final features = category['features'] as List<dynamic>? ?? [];
    final filteredFeatures = features.where((feature) {
      return permissions.contains(feature['feature_id']);
    }).toList();
    
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
  
  return filteredCategories;
});

// Provider to watch selected company from app state
final templateCompanyChoosenProvider = Provider<String>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.companyChoosen;
});

// Provider to watch selected store from app state
final templateStoreChoosenProvider = Provider<String>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.storeChoosen;
});

// Provider for fetching transaction templates from Supabase with visibility filtering
final transactionTemplatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  
  // Get current user for visibility filtering
  final currentUser = ref.watch(authStateProvider);
  
  // If no company selected or user not authenticated, return empty list
  if (companyId.isEmpty || currentUser == null) {
    return [];
  }

  try {
    final supabase = Supabase.instance.client;
    
    // Build query with store filtering
    List<dynamic> response;
    if (storeId.isNotEmpty) {
      // Get templates that are either for this specific store OR company-wide (null store_id)
      response = await supabase
          .from('transaction_templates')
          .select('''
            template_id, 
            name, 
            template_description,
            data, 
            permission, 
            tags, 
            visibility_level, 
            is_active, 
            updated_by, 
            company_id, 
            store_id, 
            counterparty_id, 
            counterparty_cash_location_id,
            created_at
          ''')
          .eq('company_id', companyId)
          .eq('is_active', true)
          .or('store_id.eq.$storeId,store_id.is.null')
          .order('created_at', ascending: false);
    } else {
      // If no store selected, get only company-wide templates (store_id is null)
      response = await supabase
          .from('transaction_templates')
          .select('''
            template_id, 
            name, 
            template_description,
            data, 
            permission, 
            tags, 
            visibility_level, 
            is_active, 
            updated_by, 
            company_id, 
            store_id, 
            counterparty_id, 
            counterparty_cash_location_id,
            created_at
          ''')
          .eq('company_id', companyId)
          .eq('is_active', true)
          .isFilter('store_id', null)
          .order('created_at', ascending: false);
    }
    
    // Response is always a List from Supabase
    final responseList = response;
    
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
    
    // Convert to proper Map<String, dynamic> format
    final templates = <Map<String, dynamic>>[];
    for (var item in filteredTemplates) {
      try {
        if (item is Map<String, dynamic>) {
          templates.add(item);
        } else if (item is Map) {
          templates.add(Map<String, dynamic>.from(item));
        }
      } catch (e) {
        // Skip items that can't be converted
        continue;
      }
    }
    
    return templates;
    
  } catch (e) {
    // Return empty list to prevent crash
    return [];
  }
});

// Provider for templates sorted by usage frequency
final sortedTransactionTemplatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final userId = supabase.auth.currentUser?.id;
  
  if (companyId.isEmpty || userId == null) {
    return [];
  }
  
  // First, get user's top templates from the view (fetch once and reuse)
  List<String> topTemplateIds = [];
  List<dynamic> topTemplatesData = [];
  try {
    final topTemplatesResponse = await supabase
        .from('top_templates_by_user')
        .select('top_templates')
        .eq('user_id', userId)
        .eq('company_id', companyId)
        .maybeSingle();
    
    if (topTemplatesResponse != null && topTemplatesResponse['top_templates'] != null) {
      topTemplatesData = topTemplatesResponse['top_templates'] as List;
      topTemplateIds = topTemplatesData
          .map((t) => t['template_id'] as String?)
          .where((id) => id != null)
          .cast<String>()
          .toList();
    }
  } catch (e) {
    // Silent fail
  }
  
  // Get all templates (including those not in top)
  final templatesAsync = await ref.watch(transactionTemplatesProvider.future);
  
  // Pre-cache frequently used templates for better performance
  if (topTemplateIds.isNotEmpty) {
    final cacheService = TemplateCacheService();
    cacheService.preCacheTemplates(topTemplateIds.take(10).toList());
  }
  
  // Get counterparties and cash locations for enrichment
  
  // Fetch counterparties
  Map<String, String> counterpartyNames = {};
  try {
    final counterparties = await supabase
        .from('counterparties')
        .select('counterparty_id, name')
        .eq('company_id', companyId);
    
    for (var cp in counterparties) {
      final id = cp['counterparty_id'] as String?;
      final name = cp['name'] as String?;
      if (id != null && name != null) {
        counterpartyNames[id] = name;
      }
    }
  } catch (e) {
    // Silent fail
  }
  
  // Fetch cash locations
  Map<String, String> cashLocationNames = {};
  try {
    final cashLocations = await supabase
        .from('cash_locations')
        .select('cash_location_id, location_name')
        .eq('company_id', companyId);
    
    for (var loc in cashLocations) {
      final id = loc['cash_location_id'] as String?;
      final name = loc['location_name'] as String?;
      if (id != null && name != null) {
        cashLocationNames[id] = name;
      }
    }
  } catch (e) {
    // Silent fail
  }
  
  // Create a map of template_id to usage data from already fetched top templates
  final usageMap = <String, Map<String, dynamic>>{};
  for (final template in topTemplatesData) {
    final templateId = template['template_id'] as String?;
    final usageCount = template['usage_count'] as int? ?? 0;
    final lastUsed = template['last_used'] as String?;
    if (templateId != null) {
      usageMap[templateId] = {
        'usage_count': usageCount,
        'last_used': lastUsed,
      };
    }
  }
  
  // Create a list of templates with usage count, recency score, and enriched data
  final templatesWithUsage = <Map<String, dynamic>>[];
  for (final template in templatesAsync) {
    final templateId = template['template_id'] as String?;
    final usageData = templateId != null ? usageMap[templateId] : null;
    final usageCount = usageData?['usage_count'] as int? ?? 0;
    final lastUsedStr = usageData?['last_used'] as String?;
    
    // Calculate recency bonus based on last used date
    int recencyBonus = 0;
    if (lastUsedStr != null) {
      final lastUsed = DateTime.tryParse(lastUsedStr);
      if (lastUsed != null) {
        final now = DateTime.now();
        final daysSinceUsed = now.difference(lastUsed).inDays;
        
        // Apply recency bonus as per TRANSACTION_TEMPLATES_GUIDE.md
        if (daysSinceUsed <= 7) {
          recencyBonus = 15; // Last 7 days
        } else if (daysSinceUsed <= 30) {
          recencyBonus = 8;  // Last 30 days
        } else if (daysSinceUsed <= 90) {
          recencyBonus = 3;  // Last 90 days
        } else {
          recencyBonus = 1;  // Older than 90 days
        }
      }
    }
    
    // Calculate total usage score (usage count + recency bonus)
    final usageScore = usageCount + recencyBonus;
    
    // Add usage data to template
    final templateWithUsage = Map<String, dynamic>.from(template);
    templateWithUsage['usage_count'] = usageCount;
    templateWithUsage['usage_score'] = usageScore;
    templateWithUsage['last_used'] = lastUsedStr;
    
    // Enrich with counterparty name
    final counterpartyId = template['counterparty_id'] as String?;
    if (counterpartyId != null && counterpartyNames.containsKey(counterpartyId)) {
      templateWithUsage['counterparty_name'] = counterpartyNames[counterpartyId];
    }
    
    // Enrich with counterparty cash location name
    final counterpartyCashLocId = template['counterparty_cash_location_id'] as String?;
    if (counterpartyCashLocId != null && cashLocationNames.containsKey(counterpartyCashLocId)) {
      templateWithUsage['counterparty_cash_location_name'] = cashLocationNames[counterpartyCashLocId];
    }
    
    // Enrich template data entries with names
    final data = template['data'] as List? ?? [];
    final enrichedData = <Map<String, dynamic>>[];
    for (var entry in data) {
      final enrichedEntry = Map<String, dynamic>.from(entry as Map<String, dynamic>);
      
      // Add cash location name if it's a cash account
      final categoryTag = entry['category_tag'] as String? ?? '';
      if (categoryTag == 'cash') {
        final cashLocId = entry['cash_location_id'] as String?;
        if (cashLocId != null && cashLocationNames.containsKey(cashLocId)) {
          enrichedEntry['cash_location_name'] = cashLocationNames[cashLocId];
        }
      }
      
      // Add counterparty name if it's payable/receivable
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        final cpId = entry['counterparty_id'] as String? ?? counterpartyId;
        if (cpId != null && counterpartyNames.containsKey(cpId)) {
          enrichedEntry['counterparty_name'] = counterpartyNames[cpId];
        }
        
        // Also add counterparty cash location name if available
        final cpCashLocId = entry['counterparty_cash_location_id'] as String?;
        if (cpCashLocId != null && cashLocationNames.containsKey(cpCashLocId)) {
          enrichedEntry['counterparty_cash_location_name'] = cashLocationNames[cpCashLocId];
        }
      }
      
      enrichedData.add(enrichedEntry);
    }
    templateWithUsage['data'] = enrichedData;
    
    templatesWithUsage.add(templateWithUsage);
  }
  
  // Sort templates: prioritize top templates from view, then by usage score
  templatesWithUsage.sort((a, b) {
    final aId = a['template_id'] as String?;
    final bId = b['template_id'] as String?;
    
    // First priority: templates from top_templates_by_user view
    final aIsTop = topTemplateIds.contains(aId);
    final bIsTop = topTemplateIds.contains(bId);
    
    if (aIsTop && !bIsTop) return -1;
    if (!aIsTop && bIsTop) return 1;
    
    // If both are top templates, sort by their order in the view
    if (aIsTop && bIsTop && aId != null && bId != null) {
      final aIndex = topTemplateIds.indexOf(aId);
      final bIndex = topTemplateIds.indexOf(bId);
      if (aIndex != bIndex) {
        return aIndex.compareTo(bIndex);
      }
    }
    
    // For non-top templates, sort by usage score
    final aScore = a['usage_score'] as int? ?? 0;
    final bScore = b['usage_score'] as int? ?? 0;
    
    if (aScore != bScore) {
      return bScore.compareTo(aScore);
    }
    
    // Finally, sort by creation date (newer first)
    final aCreated = DateTime.tryParse(a['created_at']?.toString() ?? '') ?? DateTime.now();
    final bCreated = DateTime.tryParse(b['created_at']?.toString() ?? '') ?? DateTime.now();
    return bCreated.compareTo(aCreated);
  });
  
  return templatesWithUsage;
});

// Provider for fetching all accounts (excluding fixedAsset)
final accountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Query all accounts from the accounts table
    final response = await supabase
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

// Provider for fetching cash locations
final cashLocationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty) {
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
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
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

// Provider for fetching cash locations by company ID (for counterparty cash locations)
final counterpartyCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, linkedCompanyId) async {
  try {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) {
      return [];
    }
    
    final supabase = Supabase.instance.client;
    
    // Query cash locations filtered by the linked_company_id
    final response = await supabase
        .from('cash_locations')
        .select('cash_location_id, location_name, location_type')
        .eq('company_id', linkedCompanyId)
        .order('location_name');
    
    // Add "None" option at the beginning
    final locations = <Map<String, dynamic>>[
      {'cash_location_id': null, 'location_name': 'None', 'location_type': 'none'},
    ];
    
    // Add the rest of the locations
    locations.addAll(List<Map<String, dynamic>>.from(response));
    
    return locations;
  } catch (e) {
    throw Exception('Failed to fetch counterparty cash locations: $e');
  }
});

// Function to create a transaction template
Future<void> createTransactionTemplate({
  required WidgetRef ref,
  required String name,
  required String? description,
  required List<Map<String, dynamic>> data,
  required String permission,
  required List<String> tags,
  required String visibilityLevel,
  String? counterpartyId,
  String? counterpartyCashLocationId,
}) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.read(appStateProvider);
    final user = ref.read(authStateProvider);
    
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty) {
      throw Exception('No company selected');
    }
    
    await supabase.from('transaction_templates').insert({
      'name': name,
      'template_description': description,
      'data': data,
      'permission': permission,
      'tags': tags,
      'visibility_level': visibilityLevel,
      'company_id': companyId,
      'store_id': storeId.isNotEmpty ? storeId : null,
      'counterparty_id': counterpartyId,
      'counterparty_cash_location_id': counterpartyCashLocationId,
      'updated_by': user.id,
      'is_active': true,
    });
    
  } catch (e) {
    throw Exception('Failed to create transaction template: $e');
  }
}

// Function to execute a transaction template
Future<void> executeTransactionTemplate({
  required WidgetRef ref,
  required TransactionTemplate template,
  required double amount,
  Map<String, dynamic>? debtInfo,
}) async {
  try {
    final supabase = Supabase.instance.client;
    final appState = ref.read(appStateProvider);
    final user = ref.read(authStateProvider);
    
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
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
    await supabase.rpc(
      'insert_journal_with_everything',
      params: {
        'p_base_amount': amount,
        'p_company_id': companyId,
        'p_created_by': user.id,
        'p_description': null,
        'p_entry_date': entryDate,
        'p_lines': pLines,
        'p_counterparty_id': pCounterpartyId,
        'p_if_cash_location_id': pIfCashLocationId,
        'p_store_id': storeId.isNotEmpty ? storeId : null,
      },
    );
    
  } catch (e) {
    throw Exception('Failed to execute transaction template: $e');
  }
}

// TransactionTemplate model class (assuming it exists elsewhere)
class TransactionTemplate {
  final String templateId;
  final String name;
  final String? templateDescription;
  final dynamic data;
  final String? permission;
  final List<String>? tags;
  final String? visibilityLevel;
  final String? counterpartyId;
  final String? counterpartyCashLocationId;
  final String? companyId;
  final String? storeId;
  final String? updatedBy;
  final bool isActive;
  
  TransactionTemplate({
    required this.templateId,
    required this.name,
    this.templateDescription,
    required this.data,
    this.permission,
    this.tags,
    this.visibilityLevel,
    this.counterpartyId,
    this.counterpartyCashLocationId,
    this.companyId,
    this.storeId,
    this.updatedBy,
    this.isActive = true,
  });
  
  factory TransactionTemplate.fromJson(Map<String, dynamic> json) {
    return TransactionTemplate(
      templateId: json['template_id'],
      name: json['name'],
      templateDescription: json['template_description'],
      data: json['data'],
      permission: json['permission'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      visibilityLevel: json['visibility_level'],
      counterpartyId: json['counterparty_id'],
      counterpartyCashLocationId: json['counterparty_cash_location_id'],
      companyId: json['company_id'],
      storeId: json['store_id'],
      updatedBy: json['updated_by'],
      isActive: json['is_active'] ?? true,
    );
  }
}