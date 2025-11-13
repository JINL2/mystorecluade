// =====================================================
// QUICK ACCESS PROVIDER
// Simple provider to fetch user's most used accounts and templates from database
// =====================================================

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/services/supabase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_access_provider.g.dart';

// =====================================================
// QUICK ACCESS ACCOUNTS PROVIDER
// =====================================================
@riverpod
class QuickAccessAccounts extends _$QuickAccessAccounts {
  @override
  Future<List<Map<String, dynamic>>> build({
    String? contextType,
    int limit = 8,
  }) async {
    final supabase = ref.read(supabaseServiceProvider);
    final appState = ref.read(appStateProvider);

    // Return empty if no company selected
    if (appState.companyChoosen.isEmpty) return [];

    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) return [];

      // Call database RPC function to get user's most used accounts
      final response = await supabase.client.rpc('get_user_quick_access_accounts', params: {
        'p_user_id': userId,
        'p_company_id': appState.companyChoosen,
        'p_limit': limit,
      },);

      if (response == null) return [];

      // Return raw data from database - no processing needed
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error fetching quick access accounts: $e');
      return [];
    }
  }

  /// Refresh the quick access data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Convenience providers for different contexts
@riverpod
Future<List<Map<String, dynamic>>> transactionQuickAccess(TransactionQuickAccessRef ref) {
  return ref.watch(quickAccessAccountsProvider(contextType: 'transaction').future);
}

@riverpod
Future<List<Map<String, dynamic>>> templateQuickAccess(TemplateQuickAccessRef ref) {
  return ref.watch(quickAccessAccountsProvider(contextType: 'template').future);
}

@riverpod
Future<List<Map<String, dynamic>>> journalQuickAccess(JournalQuickAccessRef ref) {
  return ref.watch(quickAccessAccountsProvider(contextType: 'journal_entry').future);
}

// =====================================================
// QUICK ACCESS TEMPLATES PROVIDER
// =====================================================
@riverpod
class QuickAccessTemplates extends _$QuickAccessTemplates {
  @override
  Future<List<Map<String, dynamic>>> build({
    String? contextType,
    int limit = 6,
  }) async {
    final supabase = ref.read(supabaseServiceProvider);
    final appState = ref.read(appStateProvider);

    // Return empty if no company selected
    if (appState.companyChoosen.isEmpty) return [];

    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) return [];

      // Call database RPC function to get user's most used templates
      final response = await supabase.client.rpc('get_user_quick_access_templates', params: {
        'p_user_id': userId,
        'p_company_id': appState.companyChoosen,
        'p_limit': limit,
      },);

      if (response == null) return [];

      // Return raw data from database - no processing needed
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error fetching quick access templates: $e');
      return [];
    }
  }

  /// Refresh the quick access data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Template convenience providers for different contexts
@riverpod
Future<List<Map<String, dynamic>>> templateTransactionQuickAccess(TemplateTransactionQuickAccessRef ref) {
  return ref.watch(quickAccessTemplatesProvider(contextType: 'transaction').future);
}

@riverpod
Future<List<Map<String, dynamic>>> templateCreationQuickAccess(TemplateCreationQuickAccessRef ref) {
  return ref.watch(quickAccessTemplatesProvider(contextType: 'creation').future);
}
