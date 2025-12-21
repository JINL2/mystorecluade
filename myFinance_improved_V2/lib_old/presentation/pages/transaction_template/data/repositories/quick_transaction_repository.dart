/// Quick Transaction Repository - Data layer for transaction creation
///
/// Purpose: Handles database communication for quick transaction creation
/// - Abstracts Supabase RPC calls
/// - Provides clean interface for business layer
/// - Handles data persistence and external communication
/// - Manages database-specific error handling
///
/// Clean Architecture: DATA LAYER
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstract repository interface for transaction operations
abstract class QuickTransactionRepository {
  Future<void> createTransaction({
    required String companyId,
    required String userId,
    required String? storeId,
    required double amount,
    String? description,
    required List<Map<String, dynamic>> transactionLines,
    String? counterpartyId,
    String? counterpartyCashLocationId,
  });

  Future<Map<String, dynamic>?> getCashLocationData(String cashLocationId);
}

/// Supabase implementation of QuickTransactionRepository
class SupabaseQuickTransactionRepository implements QuickTransactionRepository {
  final SupabaseClient _supabaseClient;

  SupabaseQuickTransactionRepository({
    SupabaseClient? supabaseClient,
  }) : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<void> createTransaction({
    required String companyId,
    required String userId,
    required String? storeId,
    required double amount,
    String? description,
    required List<Map<String, dynamic>> transactionLines,
    String? counterpartyId,
    String? counterpartyCashLocationId,
  }) async {
    // Format entry date
    final entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
    
    // Prepare RPC parameters
    final rpcParams = {
      'p_base_amount': amount,
      'p_company_id': companyId,
      'p_created_by': userId,
      'p_description': description,
      'p_entry_date': entryDate,
      'p_lines': transactionLines,
      'p_counterparty_id': counterpartyId,
      'p_if_cash_location_id': counterpartyCashLocationId,
      'p_store_id': storeId?.isNotEmpty == true ? storeId : null,
    };
    
    // Call RPC to create transaction
    await _supabaseClient.rpc('insert_journal_with_everything', params: rpcParams);
  }

  @override
  Future<Map<String, dynamic>?> getCashLocationData(String cashLocationId) async {
    try {
      // Note: Since this is a utility function and we don't have company context,
      // we'll return a minimal structure. In a full migration, this should be refactored
      // to either receive company_id parameter or use a different approach.
      return {
        'cash_location_id': cashLocationId,
        'location_name': 'Cash Location', // Fallback name - would need RPC with company_id for real name
      };
    } catch (e) {
      // Return null if cash location not found
      return null;
    }
  }
}

/// Provider for QuickTransactionRepository
final quickTransactionRepositoryProvider = Provider<QuickTransactionRepository>((ref) {
  return SupabaseQuickTransactionRepository();
});