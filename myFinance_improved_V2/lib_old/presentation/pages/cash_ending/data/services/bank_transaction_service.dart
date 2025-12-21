import 'package:supabase_flutter/supabase_flutter.dart';

/// Bank transaction service for fetching recent bank transactions
/// FROM PRODUCTION LINES 2207-2275
class BankTransactionService {
  
  /// Fetch recent bank transactions from database
  /// CRITICAL: FROM PRODUCTION LINES 2207-2273
  /// Gets the most recent bank transaction for the selected location
  Future<Map<String, dynamic>> fetchRecentBankTransactions({
    required String? selectedStoreId,
    required String? selectedBankLocationId,
    required String companyId,
  }) async {
    if (selectedStoreId == null || selectedBankLocationId == null) {
      return {
        'isLoadingBankTransactions': false,
        'recentBankTransactions': [],
      };
    }
    
    try {
      // Query bank_amount table with filters - get only the most recent one
      final query = Supabase.instance.client
          .from('bank_amount')
          .select('location_id, currency_id, total_amount, created_by, created_at, record_date')
          .eq('company_id', companyId)
          .eq('location_id', selectedBankLocationId);
      
      // Handle store_id filter - only add if not headquarter
      if (selectedStoreId != 'headquarter' && selectedStoreId != null) {
        query.eq('store_id', selectedStoreId);
      } else if (selectedStoreId == 'headquarter') {
        query.isFilter('store_id', null);
      }
      
      final response = await query
          .order('created_at', ascending: false)
          .limit(1); // Get only the most recent transaction
      
      if (response != null && response.isNotEmpty) {
        // Fetch user information for the transaction
        final transaction = Map<String, dynamic>.from(response[0]);
        final userId = transaction['created_by'];
        
        if (userId != null) {
          // Query users table to get user name
          final userResponse = await Supabase.instance.client
              .from('users')
              .select('first_name, last_name')
              .eq('user_id', userId)
              .single();
          
          if (userResponse != null) {
            // Add user name to transaction data
            transaction['user_first_name'] = userResponse['first_name'] ?? '';
            transaction['user_last_name'] = userResponse['last_name'] ?? '';
            transaction['user_full_name'] = '${userResponse['first_name'] ?? ''} ${userResponse['last_name'] ?? ''}'.trim();
          }
        }
        
        return {
          'recentBankTransactions': [transaction], // Store as single-item list
          'isLoadingBankTransactions': false,
        };
      } else {
        return {
          'recentBankTransactions': [],
          'isLoadingBankTransactions': false,
        };
      }
      
    } catch (e) {
      return {
        'isLoadingBankTransactions': false,
        'recentBankTransactions': [],
        'error': 'Error fetching bank transactions: ${e.toString()}',
      };
    }
  }
}