// =====================================================
// QUICK ACCESS HELPER
// Helper functions for quick access functionality and analytics tracking
// =====================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/app/providers/quick_access_provider.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/core/services/supabase_service.dart';

/// Shared quick access functionality for enhanced selectors
class QuickAccessHelper {
  /// Load quick access accounts for a context (Type-safe)
  static Future<List<QuickAccessAccount>> loadQuickAccessAccounts(
    WidgetRef ref, {
    String? contextType,
    int maxQuickItems = 5,
  }) async {
    try {
      final quickAccessAccounts = await ref.read(
        quickAccessAccountsProvider(
          contextType: contextType,
          limit: maxQuickItems,
        ).future,
      );
      return quickAccessAccounts;
    } catch (e) {
      debugPrint('❌ Failed to load quick access accounts: $e');
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
      },);
    } catch (e) {
      // Silent fail
    }
  }

  /// Track quick account usage with QuickAccessAccount model
  static Future<void> trackQuickAccountUsage(
    WidgetRef ref,
    QuickAccessAccount quickAccount, {
    required String? contextType,
    String selectionType = 'single_select',
  }) async {
    if (contextType == null) return;

    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) return;

      await ref.read(supabaseServiceProvider).client.rpc(
        'log_account_usage',
        params: {
          'p_account_id': quickAccount.accountId,
          'p_account_name': quickAccount.accountName,
          'p_company_id': appState.companyChoosen,
          'p_account_type': quickAccount.accountType,
          'p_usage_type': 'selected',
          'p_metadata': {
            'context': contextType,
            'selection_source': 'quick_access',
            'selection_type': selectionType,
            'usage_count': quickAccount.usageCount,
            'usage_score': quickAccount.usageScore,
          },
        },
      );
    } catch (e) {
      debugPrint('⚠️ Failed to track quick account usage: $e');
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
      },);
    } catch (e) {
      // Silent fail
    }
  }
}
