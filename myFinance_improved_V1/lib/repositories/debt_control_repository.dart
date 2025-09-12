import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_control_models.dart';

class DebtControlRepository {
  final SupabaseClient _client;

  DebtControlRepository(this._client);

  Future<DebtControlResponse> getDebtControlData({
    required String companyId,
    String? storeId,
    String perspective = 'company',
    String filter = 'all',
    bool showAll = false,
  }) async {
    try {
      // Validate inputs
      if (!['company', 'store'].contains(perspective)) {
        throw ArgumentError('Invalid perspective: $perspective');
      }
      
      if (!['all', 'internal', 'external'].contains(filter)) {
        throw ArgumentError('Invalid filter: $filter');
      }
      
      if (perspective == 'store' && storeId == null) {
        throw ArgumentError('Store ID required for store perspective');
      }
      
      // Call v2 function and extract the appropriate perspective
      final response = await _client.rpc(
        'get_debt_control_data_v2',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_filter': filter,
          'p_show_all': showAll, // Include counterparties with zero balance
        },
      );

      if (response == null) {
        throw Exception('No response from server');
      }
      
      // Extract the appropriate perspective from v2 response
      final v2Data = response as Map<String, dynamic>;
      final perspectiveData = perspective == 'store' && storeId != null
        ? v2Data['store'] 
        : v2Data['company'];
        
      if (perspectiveData == null) {
        throw Exception('No data for selected perspective');
      }

      return DebtControlResponse.fromJson(perspectiveData as Map<String, dynamic>);
      
    } catch (e) {
      print('DebtControlRepository Error: $e');
      throw Exception('Failed to fetch debt control data: $e');
    }
  }
  
  // Convenience methods
  Future<DebtControlResponse> getCompanyDebtData({
    required String companyId,
    String filter = 'all',
  }) async {
    return getDebtControlData(
      companyId: companyId,
      perspective: 'company',
      filter: filter,
    );
  }
  
  Future<DebtControlResponse> getStoreDebtData({
    required String companyId,
    required String storeId,
    String filter = 'all',
  }) async {
    return getDebtControlData(
      companyId: companyId,
      storeId: storeId,
      perspective: 'store',
      filter: filter,
    );
  }
}