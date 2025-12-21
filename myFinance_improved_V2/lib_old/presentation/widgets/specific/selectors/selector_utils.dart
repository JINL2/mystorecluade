// =====================================================
// SELECTOR UTILITIES
// Shared utilities for all selector widgets
// =====================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/selector_entities.dart';
import '../../../../data/services/supabase_service.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/quick_access_provider.dart';

/// Account type label utilities
class AccountTypeUtils {
  static String getAccountTypeLabel(String? accountType, String? fallbackLabel, {bool isPlural = true}) {
    if (accountType == null) return fallbackLabel ?? (isPlural ? 'Accounts' : 'Account');
    
    final suffix = isPlural ? 's' : '';
    switch (accountType.toLowerCase()) {
      case 'asset':
        return 'Asset Account$suffix';
      case 'liability':
        return 'Liability Account$suffix';
      case 'equity':
        return 'Equity Account$suffix';
      case 'income':
        return 'Income Account$suffix';
      case 'expense':
        return 'Expense Account$suffix';
      default:
        return '${accountType.capitalize()} Account$suffix';
    }
  }

  static String getAccountTypeHint(String? accountType, String? fallbackHint, {bool isPlural = true}) {
    if (accountType == null) return fallbackHint ?? (isPlural ? 'Select Accounts' : 'Select Account');
    
    final label = getAccountTypeLabel(accountType, null, isPlural: isPlural);
    return 'Select ${isPlural ? label.toLowerCase() : label}';
  }
}

/// Shared quick access functionality for enhanced selectors
class QuickAccessHelper {
  /// Load quick access accounts for a context
  static Future<List<Map<String, dynamic>>> loadQuickAccessAccounts(
    WidgetRef ref, {
    String? contextType,
    int maxQuickItems = 5,
  }) async {
    try {
      final quickAccessAsync = await ref.read(
        quickAccessAccountsProvider(
          contextType: contextType,
          limit: maxQuickItems,
        ).future,
      );
      return quickAccessAsync;
    } catch (e) {
      return [];
    }
  }

  /// Track account usage for analytics
  static Future<void> trackAccountUsage(
    WidgetRef ref,
    AccountData account,
    String selectionSource, {
    required String? contextType,
    String selectionType = 'single_select',
  }) async {
    if (contextType == null) return;
    
    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) return;

      await ref.read(supabaseServiceProvider).client.rpc('log_account_usage', params: {
        'p_account_id': account.id,
        'p_account_name': account.name,
        'p_company_id': appState.companyChoosen,
        'p_account_type': account.type,
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': contextType,
          'category_tag': account.categoryTag,
          'selection_source': selectionSource,
          'selection_type': selectionType,
        },
      });
    } catch (e) {
      // Silent fail
    }
  }

  /// Track quick account usage with minimal data
  static Future<void> trackQuickAccountUsage(
    WidgetRef ref,
    Map<String, dynamic> quickAccount, {
    required String? contextType,
    String selectionType = 'single_select',
  }) async {
    if (contextType == null) return;
    
    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) return;

      await ref.read(supabaseServiceProvider).client.rpc('log_account_usage', params: {
        'p_account_id': quickAccount['account_id'],
        'p_account_name': quickAccount['account_name'] ?? 'Quick Access Account',
        'p_company_id': appState.companyChoosen,
        'p_account_type': quickAccount['account_type'],
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': contextType,
          'selection_source': 'quick_access',
          'selection_type': selectionType,
        },
      });
    } catch (e) {
      // Silent fail
    }
  }

  /// Track account usage with minimal data when account details not available
  static Future<void> trackAccountUsageMinimal(
    WidgetRef ref,
    String accountId, {
    required String? contextType,
    String selectionType = 'single_select',
  }) async {
    if (contextType == null) return;
    
    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) return;

      await ref.read(supabaseServiceProvider).client.rpc('log_account_usage', params: {
        'p_account_id': accountId,
        'p_account_name': 'Unknown Account',
        'p_company_id': appState.companyChoosen,
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': contextType,
          'selection_source': 'autonomous_selector',
          'selection_type': selectionType,
          'note': 'minimal_tracking',
        },
      });
    } catch (e) {
      // Silent fail
    }
  }
}

/// String utilities
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}