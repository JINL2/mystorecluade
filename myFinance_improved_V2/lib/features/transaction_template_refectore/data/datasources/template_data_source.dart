/// Template Data Source - Direct Supabase interaction for template operations
///
/// Purpose: Handles all database communications for transaction templates:
/// - Template creation, retrieval, update, deletion through Supabase
/// - Direct SQL queries to transaction_templates table
/// - Data transformation between domain entities and database format
/// - Error handling and response processing
/// - Follows Clean Architecture DataSource pattern
///
/// Clean Architecture: DATA LAYER - DataSource (Infrastructure)
import '../../domain/entities/template_entity.dart';
import 'package:myfinance_improved/core/services/supabase_service.dart';
import '../dtos/template_dto.dart';
import '../mappers/template_mapper.dart';

class TemplateDataSource {
  final SupabaseService _supabaseService;

  TemplateDataSource(this._supabaseService);

  /// Save transaction template (upsert: insert or update)
  Future<void> save(TransactionTemplate template) async {
    final templateData = template.toDto().toJson();

    await _supabaseService.client
        .from('transaction_templates')
        .upsert(templateData);
  }

  /// Update existing template
  Future<void> update(TransactionTemplate template) async {
    final updateData = template.toDto().toJson();

    await _supabaseService.client
        .from('transaction_templates')
        .update(updateData)
        .eq('template_id', template.templateId);
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

  /// Find templates by company and store
  Future<List<TransactionTemplate>> findByCompanyAndStore({
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

    final templates = response
        .map<TransactionTemplate>((row) => _mapToEntity(row))
        .toList();

    return templates;
  }

  /// Check if template name exists for company
  Future<bool> nameExists(String name, String companyId) async {
    final response = await _supabaseService.client
        .from('transaction_templates')
        .select('template_id')
        .eq('company_id', companyId)
        .eq('name', name)
        .eq('is_active', true)
        .maybeSingle();

    return response != null;
  }

  /// Find template by name
  Future<TransactionTemplate?> findByName(String name, String companyId) async {
    final response = await _supabaseService.client
        .from('transaction_templates')
        .select()
        .eq('company_id', companyId)
        .eq('name', name)
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) return null;

    return _mapToEntity(response);
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

  /// Delete template (soft delete by setting is_active to false)
  Future<void> delete(String templateId) async {
    await _supabaseService.client
        .from('transaction_templates')
        .update({
          'is_active': false,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('template_id', templateId);
  }

  /// Search templates by name or tags
  Future<List<TransactionTemplate>> searchTemplates({
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
    List<TransactionTemplate> results = response
        .map<TransactionTemplate>((row) => _mapToEntity(row))
        .toList();

    // Filter by categories and accounts if provided
    if (categoryFilters != null && categoryFilters.isNotEmpty) {
      results = results.where((template) {
        final tags = template.tags;
        final categories = List<String>.from((tags['categories'] as List<dynamic>?) ?? []);
        return categories.any((category) => categoryFilters.contains(category));
      }).toList();
    }

    if (accountFilters != null && accountFilters.isNotEmpty) {
      results = results.where((template) {
        final tags = template.tags;
        final accounts = List<String>.from((tags['accounts'] as List<dynamic>?) ?? []);
        return accounts.any((account) => accountFilters.contains(account));
      }).toList();
    }

    return results;
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

  /// Find templates created by a specific user
  Future<List<TransactionTemplate>> findByCreatedBy(String userId) async {
    final response = await _supabaseService.client
        .from('transaction_templates')
        .select()
        .eq('created_by', userId)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response
        .map<TransactionTemplate>((row) => _mapToEntity(row))
        .toList();
  }

  /// Map database row to domain entity using type-safe DTO
  TransactionTemplate _mapToEntity(Map<String, dynamic> row) {
    final dto = TemplateDto.fromJson(row);
    return dto.toDomain();
  }
}
