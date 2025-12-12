import 'package:myfinance_improved/data/services/supabase_service.dart';

class TransactionTemplateService {
  final SupabaseService _supabaseService;

  TransactionTemplateService(this._supabaseService);

  Future<void> createTemplate({
    required String name,
    required String? description,
    required String companyId,
    required String storeId,
    required String userId,
    required List<Map<String, dynamic>> data,
    required Map<String, dynamic> tags,
    required String visibilityLevel,
    required String permission,
    String? counterpartyId,
    String? counterpartyCashLocationId,
  }) async {
    final now = DateTime.now().toIso8601String();
    
    // Convert permission to UUID
    String permissionId;
    if (permission == 'Manager') {
      permissionId = 'c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14';
    } else {
      permissionId = 'cffb000f-498b-4296-af84-4ce9bbd8bed7';
    }
    
    final templateData = {
      'name': name,
      'template_description': description,
      'company_id': companyId,
      'store_id': storeId,
      'counterparty_id': counterpartyId,
      'counterparty_cash_location_id': counterpartyCashLocationId,
      'data': data,
      'tags': tags,
      'visibility_level': visibilityLevel.toLowerCase(),
      'permission': permissionId,
      'is_active': true,
      'created_at': now,
      'updated_at': now,
      'updated_by': userId,
    };

    await _supabaseService.client
        .from('transaction_templates')
        .insert(templateData);
  }
}