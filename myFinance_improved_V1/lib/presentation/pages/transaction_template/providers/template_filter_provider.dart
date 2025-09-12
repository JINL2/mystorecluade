import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../../data/services/supabase_service.dart';


// Template Filter Model
class TemplateFilter {
  final List<String>? accountIds;
  final String? counterpartyId;
  final String? cashLocationId;
  final String? searchQuery;
  final int limit;
  final int offset;

  const TemplateFilter({
    this.accountIds,
    this.counterpartyId,
    this.cashLocationId,
    this.searchQuery,
    this.limit = 50,
    this.offset = 0,
  });

  TemplateFilter copyWith({
    List<String>? accountIds,
    String? counterpartyId,
    String? cashLocationId,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    return TemplateFilter(
      accountIds: accountIds ?? this.accountIds,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      cashLocationId: cashLocationId ?? this.cashLocationId,
      searchQuery: searchQuery ?? this.searchQuery,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  bool get hasActiveFilters {
    return (accountIds != null && accountIds!.isNotEmpty) ||
           counterpartyId != null ||
           cashLocationId != null ||
           (searchQuery != null && searchQuery!.isNotEmpty);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateFilter &&
          runtimeType == other.runtimeType &&
          _listEquals(accountIds, other.accountIds) &&
          counterpartyId == other.counterpartyId &&
          cashLocationId == other.cashLocationId &&
          searchQuery == other.searchQuery &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode =>
      (accountIds?.join(',').hashCode ?? 0) ^
      counterpartyId.hashCode ^
      cashLocationId.hashCode ^
      searchQuery.hashCode ^
      limit.hashCode ^
      offset.hashCode;

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}


// Template Filter State Provider
class TemplateFilterStateNotifier extends StateNotifier<TemplateFilter> {
  TemplateFilterStateNotifier() : super(const TemplateFilter());

  void updateFilter(TemplateFilter filter) {
    state = filter;
  }

  void clearFilter() {
    state = const TemplateFilter();
  }

  void setAccountIds(List<String>? accountIds) {
    state = state.copyWith(accountIds: accountIds);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }
}

final templateFilterStateProvider = StateNotifierProvider<TemplateFilterStateNotifier, TemplateFilter>((ref) {
  return TemplateFilterStateNotifier();
});

// Filtered Templates Provider - automatically updates when filter changes
final filteredTransactionTemplatesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final filter = ref.watch(templateFilterStateProvider);
  final supabase = ref.read(supabaseServiceProvider);
  final appState = ref.watch(appStateProvider);
  final currentUser = ref.watch(authStateProvider);
  
  if (appState.companyChoosen.isEmpty || currentUser == null) {
    return [];
  }

  try {
    // Build base query with strict store filtering
    var query = supabase.client
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
          created_at,
          updated_at
        ''')
        .eq('company_id', appState.companyChoosen)
        .eq('is_active', true);
    
    // Apply strict store filtering - show ONLY current store templates
    if (appState.storeChoosen.isNotEmpty) {
      query = query.eq('store_id', appState.storeChoosen);
    } else {
      // If no store selected, return empty list (no templates available)
      return [];
    }

    // Apply account filter - filter templates that contain specified accounts in their data
    // We'll handle this in post-processing since it requires analyzing the template data

    // Apply counterparty filter
    if (filter.counterpartyId != null && filter.counterpartyId!.isNotEmpty) {
      query = query.eq('counterparty_id', filter.counterpartyId!);
    }

    // Execute query with ordering
    final response = await query.order('updated_at', ascending: false);
    List<Map<String, dynamic>> templates = List<Map<String, dynamic>>.from(response);

    // Get usage data for filtering and sorting
    Map<String, Map<String, dynamic>> usageData = {};
    try {
      final usageResponse = await supabase.client
          .from('top_templates_by_user')
          .select('top_templates')
          .eq('user_id', currentUser.id)
          .eq('company_id', appState.companyChoosen)
          .maybeSingle();
      
      if (usageResponse != null && usageResponse['top_templates'] != null) {
        final topTemplatesData = usageResponse['top_templates'] as List;
        for (final template in topTemplatesData) {
          final templateId = template['template_id'] as String?;
          if (templateId != null) {
            usageData[templateId] = {
              'usage_count': template['usage_count'] as int? ?? 0,
              'last_used': template['last_used'] as String?,
            };
          }
        }
      }
    } catch (e) {
      // Silent fail on usage data
    }

    // Apply post-query filters
    templates = templates.where((template) {

      // Apply account filter - check if template contains any of the selected accounts
      if (filter.accountIds != null && filter.accountIds!.isNotEmpty) {
        final templateData = template['data'] as List? ?? [];
        bool hasMatchingAccount = false;
        
        for (final entry in templateData) {
          final accountId = entry['account_id'] as String?;
          if (accountId != null && filter.accountIds!.contains(accountId)) {
            hasMatchingAccount = true;
            break;
          }
        }
        
        if (!hasMatchingAccount) return false;
      }


      // Apply search query
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        final name = (template['name'] as String? ?? '').toLowerCase();
        final description = (template['template_description'] as String? ?? '').toLowerCase();
        if (!name.contains(query) && !description.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Add usage data to templates for display
    for (var template in templates) {
      final templateId = template['template_id'] as String;
      final usage = usageData[templateId] ?? {'usage_count': 0, 'last_used': null};
      template['usage_count'] = usage['usage_count'];
      template['last_used'] = usage['last_used'];
    }

    // Sort by usage count (high to low) for better UX
    templates.sort((a, b) {
      final aUsage = a['usage_count'] as int? ?? 0;
      final bUsage = b['usage_count'] as int? ?? 0;
      return bUsage.compareTo(aUsage);
    });

    return templates;
  } catch (e) {
    return [];
  }
});

// Helper extension for filter state
extension TemplateFilterExtension on TemplateFilter {
  String get accountsDisplayName {
    if (accountIds == null || accountIds!.isEmpty) {
      return 'All Accounts';
    }
    if (accountIds!.length == 1) {
      return '1 Account';
    }
    return '${accountIds!.length} Accounts';
  }
}