/// Template Providers - State management for transaction templates using repository pattern
///
/// Purpose: Manages template state using the new data layer architecture:
/// - Template retrieval with repository caching integration
/// - Usage-based sorting with recency algorithms
/// - Template enrichment with entity data
/// - Error handling and fallback mechanisms
/// - Integration with new business layer use cases
///
/// Usage: ref.watch(transactionTemplatesProvider), ref.watch(sortedTransactionTemplatesProvider)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../providers/app_state_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../data/repositories/template_repository.dart';
import 'template_filter_provider.dart';

// Provider for fetching transaction templates using repository pattern
final transactionTemplatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  final currentUser = ref.watch(authStateProvider);
  final templateRepository = ref.read(templateRepositoryProvider);
  
  // If no company selected or user not authenticated, return empty list
  if (companyId.isEmpty || currentUser == null) {
    return [];
  }

  try {
    // Get templates using repository with caching
    final templates = await templateRepository.getTemplates(
      companyId: companyId,
      storeId: storeId,
      isActive: true,
    );
    
    // Filter templates based on visibility level and user permissions
    final filteredTemplates = templates.where((template) {
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
    
    return filteredTemplates;
  } catch (e) {
    // Return empty list to prevent crash
    return [];
  }
});

// Provider for templates sorted by usage frequency with enrichment
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
  
  // Get all templates from repository
  final templatesAsync = await ref.watch(transactionTemplatesProvider.future);
  
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

  // Fetch cash locations using RPC
  Map<String, String> cashLocationNames = {};
  try {
    final cashLocations = await supabase.rpc(
      'get_cash_locations',
      params: {
        'p_company_id': companyId,
      },
    );
    
    if (cashLocations != null) {
      for (var loc in (cashLocations as List)) {
        final id = loc['id'] as String?;
        final name = loc['name'] as String?;
        if (id != null && name != null) {
          cashLocationNames[id] = name;
        }
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

// Provider for template by ID using repository
final templateByIdProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, templateId) async {
  final templateRepository = ref.read(templateRepositoryProvider);
  
  try {
    return await templateRepository.getTemplateById(templateId);
  } catch (e) {
    return null;
  }
});

// Provider for template statistics using repository
final templateStatsFromRepositoryProvider = FutureProvider<Map<String, int>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  final templateRepository = ref.read(templateRepositoryProvider);
  
  if (companyId.isEmpty || storeId.isEmpty) {
    return {
      'total': 0,
      'active': 0,
      'inactive': 0,
      'public': 0,
      'private': 0,
    };
  }

  try {
    return await templateRepository.getTemplateStats(
      companyId: companyId,
      storeId: storeId,
    );
  } catch (e) {
    return {
      'total': 0,
      'active': 0,
      'inactive': 0,
      'public': 0,
      'private': 0,
    };
  }
});

// Provider for refreshing template cache
final refreshTemplatesProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    final templateRepository = ref.read(templateRepositoryProvider);
    
    if (companyId.isNotEmpty && storeId.isNotEmpty) {
      await templateRepository.refreshCache(
        companyId: companyId,
        storeId: storeId,
      );
      
      // Invalidate providers to trigger refresh
      ref.invalidate(transactionTemplatesProvider);
      ref.invalidate(sortedTransactionTemplatesProvider);
      ref.invalidate(filteredTransactionTemplatesProvider);
    }
  };
});