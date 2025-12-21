/// Template Data Service - Data layer for template operations
///
/// Purpose: Handles all data communications for transaction templates:
/// - Template creation and updates through Supabase
/// - Template retrieval and filtering
/// - Permission and visibility management
/// - Database transaction operations
/// - Error handling and response processing
///
/// Usage: TemplateDataService.createTemplate(templateData)
import '../../../../../data/services/supabase_service.dart';

class TemplateDataService {
  final SupabaseService _supabaseService;

  TemplateDataService(this._supabaseService);

  /// Create a new transaction template
  Future<void> createTemplate({
    required String name,
    required String? description,
    required String companyId,
    required String storeId,
    required String userId,
    required List<Map<String, dynamic>> data,
    required List<String> tags,
    required String visibilityLevel,
    required String permission,
    String? counterpartyId,
    String? counterpartyCashLocationId,
  }) async {
    final templateData = {
      'name': name,
      'template_description': description,
      'data': data,
      'permission': permission,
      'tags': tags,
      'visibility_level': visibilityLevel,
      'company_id': companyId,
      'store_id': storeId.isNotEmpty ? storeId : null,
      'counterparty_id': counterpartyId,
      'counterparty_cash_location_id': counterpartyCashLocationId,
      'updated_by': userId,
      'is_active': true,
    };

    await _supabaseService.client
        .from('transaction_templates')
        .insert(templateData);
  }

  /// Retrieve templates by company and store
  Future<List<Map<String, dynamic>>> getTemplates({
    required String companyId,
    required String storeId,
    bool? isActive,
    String? visibilityLevel,
  }) async {
    var query = _supabaseService.client
        .from('transaction_templates')
        .select()
        .eq('company_id', companyId)
        .eq('store_id', storeId);

    if (isActive != null) {
      query = query.eq('is_active', isActive);
    }

    if (visibilityLevel != null) {
      query = query.eq('visibility_level', visibilityLevel);
    }

    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Update template status
  Future<void> updateTemplateStatus({
    required String templateId,
    required bool isActive,
    required String userId,
  }) async {
    await _supabaseService.client
        .from('transaction_templates')
        .update({
          'is_active': isActive,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('template_id', templateId);
  }

  /// Delete template (soft delete by setting is_active to false)
  Future<void> deleteTemplate({
    required String templateId,
    required String userId,
  }) async {
    await updateTemplateStatus(
      templateId: templateId,
      isActive: false,
      userId: userId,
    );
  }

  /// Get template by ID
  Future<Map<String, dynamic>?> getTemplateById(String templateId) async {
    final response = await _supabaseService.client
        .from('transaction_templates')
        .select()
        .eq('template_id', templateId)
        .maybeSingle();

    return response;
  }

  /// Search templates by name or tags
  Future<List<Map<String, dynamic>>> searchTemplates({
    required String companyId,
    required String storeId,
    String? searchQuery,
    List<String>? categoryFilters,
    List<String>? accountFilters,
  }) async {
    var query = _supabaseService.client
        .from('transaction_templates')
        .select()
        .eq('company_id', companyId)
        .eq('store_id', storeId)
        .eq('is_active', true);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }

    final response = await query.order('created_at', ascending: false);
    List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(response);

    // Filter by categories and accounts if provided
    if (categoryFilters != null && categoryFilters.isNotEmpty) {
      results = results.where((template) {
        final tags = template['tags'] as Map<String, dynamic>? ?? {};
        final categories = List<String>.from((tags['categories'] as List<dynamic>?) ?? []);
        return categories.any((category) => categoryFilters.contains(category));
      }).toList();
    }

    if (accountFilters != null && accountFilters.isNotEmpty) {
      results = results.where((template) {
        final tags = template['tags'] as Map<String, dynamic>? ?? {};
        final accounts = List<String>.from((tags['accounts'] as List<dynamic>?) ?? []);
        return accounts.any((account) => accountFilters.contains(account));
      }).toList();
    }

    return results;
  }

  /// Update template data
  Future<void> updateTemplate({
    required String templateId,
    required String name,
    String? description,
    required List<Map<String, dynamic>> data,
    required List<String> tags,
    required String visibilityLevel,
    required String permission,
    required String userId,
    String? counterpartyId,
    String? counterpartyCashLocationId,
  }) async {
    final updateData = {
      'name': name,
      'template_description': description,
      'counterparty_id': counterpartyId,
      'counterparty_cash_location_id': counterpartyCashLocationId,
      'data': data,
      'tags': tags,
      'visibility_level': visibilityLevel,
      'permission': permission,
      'updated_at': DateTime.now().toIso8601String(),
      'updated_by': userId,
    };

    await _supabaseService.client
        .from('transaction_templates')
        .update(updateData)
        .eq('template_id', templateId);
  }
}