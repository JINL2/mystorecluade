/// Supabase Template Repository - Repository implementation with caching
///
/// Purpose: Orchestrates template data operations and provides unified interface:
/// - Implements TemplateRepository interface from domain layer
/// - Coordinates between data service and cache repository
/// - Implements caching strategies for performance
/// - Handles data transformation and validation
/// - Provides error handling and retry logic
/// - Manages data consistency and synchronization
/// - Follows production pattern from transaction_template/data/repositories
///
/// Clean Architecture: DATA LAYER - Repository Implementation
library;
import 'package:myfinance_improved/core/services/supabase_service.dart';

import '../../domain/entities/template_entity.dart';
import '../../domain/repositories/template_repository.dart';
import '../cache/template_cache_repository.dart';
import '../datasources/template_data_source.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateDataSource _dataSource;
  final TemplateCacheRepository _cacheRepository;

  TemplateRepositoryImpl({
    required TemplateDataSource dataSource,
    required TemplateCacheRepository cacheRepository,
  }) : _dataSource = dataSource, _cacheRepository = cacheRepository;

  /// Factory constructor with default dependencies
  factory TemplateRepositoryImpl.create() {
    return TemplateRepositoryImpl(
      dataSource: TemplateDataSource(SupabaseService()),
      cacheRepository: TemplateCacheRepository(),
    );
  }

  @override
  Future<String> upsert({
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
    // Call RPC via DataSource
    final response = await _dataSource.upsertTemplate(
      templateId: templateId,
      name: name,
      data: data,
      companyId: companyId,
      visibilityLevel: visibilityLevel,
      permission: permission,
      userId: userId,
      localTime: localTime,
      timezone: timezone,
      templateDescription: templateDescription,
      tags: tags,
      storeId: storeId,
      counterpartyId: counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId,
      isActive: isActive,
      requiredAttachment: requiredAttachment,
    );

    if (!response.success) {
      throw Exception(response.message ?? response.error ?? 'Failed to upsert template');
    }

    final resultTemplateId = response.data?.templateId ?? templateId ?? '';

    // Invalidate cache
    if (templateId != null) {
      await _cacheRepository.invalidateTemplateCache(templateId);
    }
    await _cacheRepository.invalidateTemplatesCache(companyId, storeId ?? '');

    return resultTemplateId;
  }

  @override
  Future<TransactionTemplate?> findById(String templateId) async {
    // Check cache first
    final cachedTemplate = await _cacheRepository.getCachedTemplateById(templateId);
    if (cachedTemplate != null) {
      return cachedTemplate;
    }

    // Fetch from data source
    final template = await _dataSource.findById(templateId);
    
    // Cache the result if found
    if (template != null) {
      await _cacheRepository.cacheTemplate(template);
    }

    return template;
  }

  @override
  Future<List<TransactionTemplate>> findByContext({
    required String companyId,
    required String timezone,
    String? storeId,
    bool? isActive,
    String? visibilityLevel,
  }) async {
    // Check cache first
    final cachedTemplates = await _cacheRepository.getCachedTemplates(
      companyId: companyId,
      storeId: storeId ?? '',
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    if (cachedTemplates != null) {
      return cachedTemplates;
    }

    // Fetch via RPC
    final response = await _dataSource.getTemplatesForList(
      companyId: companyId,
      timezone: timezone,
      storeId: storeId,
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    final templates = _dataSource.mapTemplateListToDomain(response);

    // Cache the results
    await _cacheRepository.cacheTemplates(
      companyId: companyId,
      storeId: storeId ?? '',
      templates: templates,
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    return templates;
  }

  @override
  Future<bool> nameExists(String name, String companyId) async {
    // Name existence check always goes to database for consistency
    return await _dataSource.nameExists(name, companyId);
  }

  @override
  Future<List<TransactionTemplate>> findSimilar({
    required String templateName,
    required String companyId,
    required double similarityThreshold,
    required int limit,
  }) async {
    // Similarity search always goes to database
    final templates = await _dataSource.findSimilar(
      templateName: templateName,
      companyId: companyId,
      similarityThreshold: similarityThreshold,
      limit: limit,
    );

    // Cache individual templates
    for (final template in templates) {
      await _cacheRepository.cacheTemplate(template);
    }

    return templates;
  }

  @override
  Future<void> delete({
    required String templateId,
    required String userId,
    required String companyId,
    required String localTime,
    required String timezone,
  }) async {
    // Get template info before deletion for cache invalidation
    final template = await findById(templateId);

    // Delete via RPC
    final response = await _dataSource.deleteTemplate(
      templateId: templateId,
      userId: userId,
      companyId: companyId,
      localTime: localTime,
      timezone: timezone,
    );

    if (!response.success) {
      throw Exception(response.message ?? response.error ?? 'Failed to delete template');
    }

    // Invalidate cache
    await _cacheRepository.invalidateTemplateCache(templateId);

    // Invalidate lists cache if we have template info
    if (template != null) {
      await _cacheRepository.invalidateTemplatesCache(
        template.companyId,
        template.storeId,
      );
    }
  }

  @override
  Future<List<TransactionTemplate>> search({
    required String timezone,
    String? namePattern,
    String? companyId,
    String? storeId,
    String? createdBy,
    List<String>? categoryFilters,
    List<String>? accountFilters,
    int? limit,
    int? offset,
  }) async {
    if (companyId == null || companyId.isEmpty) {
      return [];
    }

    // Search via RPC - always fresh results
    final response = await _dataSource.getTemplatesForList(
      companyId: companyId,
      timezone: timezone,
      storeId: storeId,
      searchQuery: namePattern,
      categoryFilters: categoryFilters,
      accountFilters: accountFilters,
      limit: limit,
      offset: offset,
    );

    final templates = _dataSource.mapTemplateListToDomain(response);

    // Cache individual templates
    for (final template in templates) {
      await _cacheRepository.cacheTemplate(template);
    }

    return templates;
  }

  @override
  Future<int> countUserTemplates(String userId) async {
    // Count operations always go to database for consistency
    return await _dataSource.countUserTemplates(userId);
  }

  /// Refresh all cached data
  Future<void> refreshCache({
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    await _cacheRepository.invalidateAllCache();
    await findByContext(
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );
  }

}