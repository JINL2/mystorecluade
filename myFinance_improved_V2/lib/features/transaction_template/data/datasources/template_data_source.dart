/// Template Data Source - Supabase interaction for template operations
///
/// Purpose: Handles all database communications for transaction templates:
/// - Template creation, retrieval, update, deletion through Supabase
/// - RPC calls for template list/search (transaction_template_get_list)
/// - RPC call for template usage analysis (get_template_for_usage)
/// - Data transformation between domain entities and database format
/// - Error handling and response processing
/// - Follows Clean Architecture DataSource pattern
///
/// Note: Transaction creation is handled by TemplateRpcService using insert_journal_with_everything_utc
///
/// Clean Architecture: DATA LAYER - DataSource (Infrastructure)
library;
import 'package:myfinance_improved/core/services/supabase_service.dart';

import '../../domain/entities/template_entity.dart';
import '../dtos/template_dto.dart';
import '../dtos/template_list_response_dto.dart';
import '../dtos/template_usage_response_dto.dart';
import '../dtos/upsert_template_response_dto.dart';
import '../dtos/delete_template_response_dto.dart';
import '../mappers/template_mapper.dart';

class TemplateDataSource {
  final SupabaseService _supabaseService;

  TemplateDataSource(this._supabaseService);

  // ═══════════════════════════════════════════════════════════════════════════
  // RPC Methods for Template Upsert (Create/Update)
  // Replaces direct table queries: save(), update()
  // ═══════════════════════════════════════════════════════════════════════════

  /// Upsert template via RPC (replaces save() & update())
  ///
  /// Calls RPC: transaction_template_upsert_template
  /// - If templateId is null: INSERT (create new template)
  /// - If templateId is provided: UPDATE (modify existing template)
  Future<UpsertTemplateResponseDto> upsertTemplate({
    String? templateId,
    required String name,
    required List<Map<String, dynamic>> data,
    required String companyId,
    required String visibilityLevel,
    required String permission,
    required String userId,
    required String localTime,
    required String timezone,
    String? templateDescription,
    Map<String, dynamic>? tags,
    String? storeId,
    String? counterpartyId,
    String? counterpartyCashLocationId,
    bool? isActive,
    bool? requiredAttachment,
  }) async {
    final response = await _supabaseService.client.rpc<Map<String, dynamic>>(
      'transaction_template_upsert_template',
      params: {
        if (templateId != null) 'p_template_id': templateId,
        'p_name': name,
        'p_data': data,
        'p_company_id': companyId,
        'p_visibility_level': visibilityLevel,
        'p_permission': permission,
        'p_user_id': userId,
        'p_local_time': localTime,
        'p_timezone': timezone,
        if (templateDescription != null) 'p_template_description': templateDescription,
        if (tags != null) 'p_tags': tags,
        if (storeId != null && storeId.isNotEmpty) 'p_store_id': storeId,
        if (counterpartyId != null) 'p_counterparty_id': counterpartyId,
        if (counterpartyCashLocationId != null) 'p_counterparty_cash_location_id': counterpartyCashLocationId,
        if (isActive != null) 'p_is_active': isActive,
        if (requiredAttachment != null) 'p_required_attachment': requiredAttachment,
      },
    );

    return UpsertTemplateResponseDto.fromJson(response);
  }

  /// Find template by ID
  Future<TransactionTemplate?> findById(String templateId) async {
    final response = await _supabaseService.client
        .from('transaction_templates')
        .select()
        .eq('template_id', templateId)
        .maybeSingle();

    if (response == null) return null;

    return _mapToEntity(response);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RPC Methods for Template List/Search
  // Replaces direct table queries: findByCompanyAndStore, searchTemplates
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get templates list via RPC (replaces findByCompanyAndStore & searchTemplates)
  ///
  /// Calls RPC: transaction_template_get_list
  /// Returns: List of templates with pagination support
  Future<TemplateListResponseDto> getTemplatesForList({
    required String companyId,
    required String timezone,
    String? storeId,
    String? searchQuery,
    bool? isActive,
    String? visibilityLevel,
    List<String>? categoryFilters,
    List<String>? accountFilters,
    int? limit,
    int? offset,
  }) async {
    final response = await _supabaseService.client.rpc<Map<String, dynamic>>(
      'transaction_template_get_list',
      params: {
        'p_company_id': companyId,
        'p_timezone': timezone,
        if (storeId != null && storeId.isNotEmpty) 'p_store_id': storeId,
        if (searchQuery != null && searchQuery.isNotEmpty) 'p_search_query': searchQuery,
        if (isActive != null) 'p_is_active': isActive,
        if (visibilityLevel != null) 'p_visibility_level': visibilityLevel,
        if (categoryFilters != null && categoryFilters.isNotEmpty) 'p_category_filters': categoryFilters,
        if (accountFilters != null && accountFilters.isNotEmpty) 'p_account_filters': accountFilters,
        if (limit != null) 'p_limit': limit,
        if (offset != null) 'p_offset': offset,
      },
    );

    return TemplateListResponseDto.fromJson(response);
  }

  /// Convert RPC response to domain entities
  List<TransactionTemplate> mapTemplateListToDomain(TemplateListResponseDto response) {
    if (!response.success || response.data == null) {
      return [];
    }

    return response.data!.templates.map((item) => TransactionTemplate(
      templateId: item.templateId,
      name: item.name,
      templateDescription: item.templateDescription,
      data: item.data,
      tags: item.tags,
      visibilityLevel: item.visibilityLevel,
      permission: item.permission,
      companyId: item.companyId,
      storeId: item.storeId ?? '',
      counterpartyId: item.counterpartyId,
      counterpartyCashLocationId: item.counterpartyCashLocationId,
      createdBy: item.createdBy,
      createdAt: DateTime.parse(item.createdAt),
      updatedAt: DateTime.parse(item.updatedAt),
      updatedBy: item.updatedBy,
      isActive: item.isActive,
      requiredAttachment: item.requiredAttachment,
    )).toList();
  }

  /// Check if template name exists for company
  Future<bool> nameExists(String name, String companyId) async {
    final trimmedName = name.trim();
    final response = await _supabaseService.client
        .from('transaction_templates')
        .select('template_id')
        .eq('company_id', companyId)
        .eq('name', trimmedName)
        .eq('is_active', true)
        .maybeSingle();

    return response != null;
  }

  /// Search templates with similarity matching
  Future<List<TransactionTemplate>> findSimilar({
    required String templateName,
    required String companyId,
    required double similarityThreshold,
    required int limit,
  }) async {
    // For now, implement simple name-based similarity
    // In production, this could use PostgreSQL's similarity functions
    final response = await _supabaseService.client
        .from('transaction_templates')
        .select()
        .eq('company_id', companyId)
        .eq('is_active', true)
        .ilike('name', '%${templateName.split(' ').first}%')
        .limit(limit);

    return response
        .map<TransactionTemplate>((row) => _mapToEntity(row))
        .toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RPC Methods for Template Delete
  // Replaces direct table queries: delete()
  // ═══════════════════════════════════════════════════════════════════════════

  /// Delete template via RPC (soft delete)
  ///
  /// Calls RPC: transaction_template_delete_template
  /// Sets is_active = false, updated_by, updated_at, updated_at_utc
  Future<DeleteTemplateResponseDto> deleteTemplate({
    required String templateId,
    required String userId,
    required String companyId,
    required String localTime,
    required String timezone,
  }) async {
    final response = await _supabaseService.client.rpc<Map<String, dynamic>>(
      'transaction_template_delete_template',
      params: {
        'p_template_id': templateId,
        'p_user_id': userId,
        'p_company_id': companyId,
        'p_local_time': localTime,
        'p_timezone': timezone,
      },
    );

    return DeleteTemplateResponseDto.fromJson(response);
  }

  /// Count templates created by a specific user
  Future<int> countUserTemplates(String userId) async {
    final response = await _supabaseService.client
        .from('transaction_templates')
        .select('template_id')
        .eq('created_by', userId)
        .eq('is_active', true);

    return response.length;
  }

  /// Map database row to domain entity using type-safe DTO
  TransactionTemplate _mapToEntity(Map<String, dynamic> row) {
    final dto = TemplateDto.fromJson(row);
    return dto.toDomain();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RPC Methods for Template Usage
  // Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get template analysis for usage modal
  ///
  /// Calls RPC: get_template_for_usage
  /// Returns: UI configuration, analysis, defaults for template usage modal
  Future<TemplateUsageResponseDto> getTemplateForUsage({
    required String templateId,
    required String companyId,
    String? storeId,
  }) async {
    final response = await _supabaseService.client.rpc(
      'get_template_for_usage',
      params: {
        'p_template_id': templateId,
        'p_company_id': companyId,
        if (storeId != null) 'p_store_id': storeId,
      },
    );

    if (response == null) {
      return const TemplateUsageResponseDto(
        success: false,
        error: 'null_response',
        message: 'RPC returned null response',
      );
    }

    return TemplateUsageResponseDto.fromJson(response as Map<String, dynamic>);
  }

}
