import 'package:supabase_flutter/supabase_flutter.dart';

/// Cash history service for loading recent cash endings
/// FROM PRODUCTION LINES 4459-4629
class CashHistoryService {
  
  /// Load recent cash endings from database
  /// CRITICAL: FROM PRODUCTION LINES 4459-4628
  /// Fetches and groups the most recent cash ending transaction
  Future<Map<String, dynamic>> loadRecentCashEndings({
    required String locationId,
    required String companyId,
    required String? selectedStoreId,
    required List<Map<String, dynamic>> currencyTypes,
    required List<Map<String, dynamic>> companyCurrencies,
  }) async {
    try {
      
      if (companyId.isEmpty || selectedStoreId == null || locationId.isEmpty) {
        return {
          'recentCashEndings': [],
          'isLoadingRecentEndings': false,
        };
      }
      
      // Query cashier_amount_lines table - get all rows for this location
      // We need to group them by record_date and created_at to get the most recent transaction
      
      // First, let's try a simpler query to see if we get any data at all
      final testResponse = await Supabase.instance.client
          .from('cashier_amount_lines')
          .select('*')
          .eq('location_id', locationId);
      
      if (testResponse != null && testResponse.isNotEmpty) {
      }
      
      // Build the query based on whether it's headquarter or a regular store
      var query = Supabase.instance.client
          .from('cashier_amount_lines')
          .select('currency_id, record_date, denomination_id, quantity, created_at, created_by, company_id, store_id, location_id')
          .eq('company_id', companyId)
          .eq('location_id', locationId);
      
      // For headquarter, store_id should be null in the database
      if (selectedStoreId == 'headquarter') {
        query = query.isFilter('store_id', null);
      } else {
        query = query.eq('store_id', selectedStoreId);
      }
      
      final response = await query.order('created_at', ascending: false);
      
      if (response != null && response.isNotEmpty) {
      }
      
      if (response != null && response.isNotEmpty) {
        // Group by created_at to get the most recent transaction
        // All rows with the same created_at belong to the same cash ending
        final latestCreatedAt = response[0]['created_at'];
        final latestRecordDate = response[0]['record_date'];
        final createdBy = response[0]['created_by'];
        
        // Filter all rows that belong to this transaction
        final transactionRows = response.where((row) => 
          row['created_at'] == latestCreatedAt
        ).toList();
        
        
        // Get user's full name from users table
        String fullName = 'Unknown User';
        if (createdBy != null) {
          final userResponse = await Supabase.instance.client
              .from('users')
              .select('first_name, last_name')
              .eq('user_id', createdBy)
              .single();
          
          if (userResponse != null) {
            final firstName = userResponse['first_name'] ?? '';
            final lastName = userResponse['last_name'] ?? '';
            fullName = '$firstName $lastName'.trim();
          }
        }
        
        // Group transaction rows by currency_id
        Map<String, List<Map<String, dynamic>>> transactionByCurrency = {};
        for (var row in transactionRows) {
          final currencyId = row['currency_id'];
          if (!transactionByCurrency.containsKey(currencyId)) {
            transactionByCurrency[currencyId] = [];
          }
          transactionByCurrency[currencyId]!.add({
            'denomination_id': row['denomination_id'],
            'quantity': row['quantity'],
          });
        }
        
        // Load currency and denomination data for all currencies in the transaction
        Map<String, List<Map<String, dynamic>>> denominationData = {};
        Map<String, Map<String, dynamic>> currencyData = {};
        
        for (var currencyId in transactionByCurrency.keys) {
          // Fetch denominations for this currency - only get active (non-deleted) denominations
          final denomResponse = await Supabase.instance.client
              .from('currency_denominations')
              .select('*')
              .eq('currency_id', currencyId)
              .eq('is_deleted', false)
              .order('value', ascending: false);
          
          if (denomResponse != null) {
            denominationData[currencyId] = List<Map<String, dynamic>>.from(denomResponse);
          }
          
          // Get currency info from currencyTypes table data (loaded when page loads)
          
          // Find the currency in currencyTypes by matching currency_id
          final currencyInfo = currencyTypes.firstWhere(
            (c) => c['currency_id'] == currencyId,
            orElse: () {
              // Fallback to companyCurrencies if not found in currencyTypes
              return companyCurrencies.firstWhere(
                (c) => c['currency_id'] == currencyId,
                orElse: () => {
                  'currency_id': currencyId,
                  'symbol': '\$',  // Only use default if not found anywhere
                  'currency_code': 'USD'
                },
              );
            },
          );
          
          
          if (currencyInfo.isNotEmpty) {
            currencyData[currencyId] = currencyInfo;
          }
        }
        
        // Build the currencies array in the format expected by the display widget
        List<Map<String, dynamic>> currencies = [];
        for (var entry in transactionByCurrency.entries) {
          currencies.add({
            'currency_id': entry.key,
            'denominations': entry.value,
          });
        }
        
        return {
          'recentCashEndings': [{
            'created_at': latestCreatedAt,
            'record_date': latestRecordDate,
            'created_by': createdBy,
            'user_full_name': fullName,
            'parsed_currencies': currencies,
            'denomination_data': denominationData,
            'currency_data': currencyData,
            'transaction_rows': transactionRows,
          }],
          'isLoadingRecentEndings': false,
        };
        
      } else {
        return {
          'recentCashEndings': [],
          'isLoadingRecentEndings': false,
        };
      }
    } catch (e) {
      return {
        'recentCashEndings': [],
        'isLoadingRecentEndings': false,
        'error': 'Error loading cash endings: ${e.toString()}',
      };
    }
  }
}