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
import '../../domain/entities/template_entity.dart';
import '../../domain/repositories/template_repository.dart';
import '../services/template_data_service.dart';
import '../cache/template_cache_repository.dart';
import 'package:myfinance_improved/data/services/supabase_service.dart';

class SupabaseTemplateRepository implements TemplateRepository {
  final TemplateDataService _dataService;
  final TemplateCacheRepository _cacheRepository;

  SupabaseTemplateRepository({
    required TemplateDataService dataService,
    required TemplateCacheRepository cacheRepository,
  }) : _dataService = dataService, _cacheRepository = cacheRepository;

  /// Factory constructor with default dependencies
  factory SupabaseTemplateRepository.create() {
    return SupabaseTemplateRepository(
      dataService: TemplateDataService(SupabaseService()),
      cacheRepository: TemplateCacheRepository(),
    );
  }

  @override
  Future<void> save(TransactionTemplate template) async {
    // Save to database
    await _dataService.save(template);

    // Update cache
    await _cacheRepository.cacheTemplate(template);

    // Invalidate lists cache to ensure consistency
    await _cacheRepository.invalidateTemplatesCache(
      template.companyId, 
      template.storeId,
    );
  }

  @override
  Future<void> update(TransactionTemplate template) async {
    // Update in database
    await _dataService.update(template);

    // Update cache
    await _cacheRepository.cacheTemplate(template);

    // Invalidate lists cache to ensure consistency
    await _cacheRepository.invalidateTemplatesCache(
      template.companyId, 
      template.storeId,
    );
  }

  @override
  Future<TransactionTemplate?> findById(String templateId) async {
    // Check cache first
    final cachedTemplate = await _cacheRepository.getCachedTemplateById(templateId);
    if (cachedTemplate != null) {
      return cachedTemplate;
    }

    // Fetch from data service
    final template = await _dataService.findById(templateId);
    
    // Cache the result if found
    if (template != null) {
      await _cacheRepository.cacheTemplate(template);
    }

    return template;
  }

  @override
  Future<List<TransactionTemplate>> findByContext({
    required String companyId,
    String? storeId,
    bool? isActive,
    String? visibilityLevel,
  }) async {
    print('🟠 DEBUG: SupabaseTemplateRepository.findByContext - companyId=$companyId, storeId=$storeId');

    // Delegate to existing findByCompanyAndStore method
    // Handle optional storeId by providing empty string as default
    final result = await findByCompanyAndStore(
      companyId: companyId,
      storeId: storeId ?? '', // Convert optional to required
      isActive: isActive,
      visibilityLevel: visibilityLevel,
      forceRefresh: false, // Use default value
    );

    print('🟠 DEBUG: SupabaseTemplateRepository.findByContext - Returning ${result.length} templates');
    return result;
  }

  /// Legacy method - kept for backward compatibility
  /// Use findByContext() which matches the domain interface
  Future<List<TransactionTemplate>> findByCompanyAndStore({
    required String companyId,
    required String storeId,
    bool? isActive,
    String? visibilityLevel,
    bool forceRefresh = false,
  }) async {
    print('🟠 DEBUG: Repository.findByCompanyAndStore - forceRefresh=$forceRefresh');

    // Check cache first unless force refresh is requested
    if (!forceRefresh) {
      final cachedTemplates = await _cacheRepository.getCachedTemplates(
        companyId: companyId,
        storeId: storeId,
        isActive: isActive,
        visibilityLevel: visibilityLevel,
      );

      if (cachedTemplates != null) {
        print('🟠 DEBUG: Repository - Cache HIT, returning ${cachedTemplates.length} templates');
        return cachedTemplates;
      } else {
        print('🟠 DEBUG: Repository - Cache MISS, fetching from database');
      }
    }

    // Fetch from data service
    print('🔵 DEBUG: Repository - Calling DataService.findByCompanyAndStore()');
    final templates = await _dataService.findByCompanyAndStore(
      companyId: companyId,
      storeId: storeId,
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    print('🟠 DEBUG: Repository - DataService returned ${templates.length} templates');

    // Cache the results
    await _cacheRepository.cacheTemplates(
      companyId: companyId,
      storeId: storeId,
      templates: templates,
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    return templates;
  }

  @override
  Future<bool> nameExists(String name, String companyId) async {
    // Name existence check always goes to database for consistency
    return await _dataService.nameExists(name, companyId);
  }

  @override
  Future<TransactionTemplate?> findByName(String name, String companyId) async {
    // For specific lookups, check database directly for consistency
    final template = await _dataService.findByName(name, companyId);
    
    // Cache the result if found
    if (template != null) {
      await _cacheRepository.cacheTemplate(template);
    }

    return template;
  }

  @override
  Future<List<TransactionTemplate>> findSimilar({
    required String templateName,
    required String companyId,
    required double similarityThreshold,
    required int limit,
  }) async {
    // Similarity search always goes to database
    final templates = await _dataService.findSimilar(
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
  Future<void> delete(String templateId) async {
    // Get template info before deletion for cache invalidation
    final template = await findById(templateId);
    
    // Delete from database
    await _dataService.delete(templateId);

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
  Future<void> deleteTemplate({
    required String templateId,
    required String userId,
    required String companyId,
    required String storeId,
  }) async {
    // Add context validation if needed
    // For now, delegate to the simple delete method
    await delete(templateId);
  }

  @override
  Future<List<TransactionTemplate>> search({
    String? namePattern,
    String? companyId,
    String? storeId,
    String? createdBy,
    int? limit,
    int? offset,
  }) async {
    // Map domain interface parameters to implementation
    // Note: Some parameters (createdBy, limit, offset) cannot be fully mapped to current implementation
    return await searchTemplates(
      companyId: companyId ?? '',
      storeId: storeId ?? '',
      searchQuery: namePattern,
      categoryFilters: null, // Not available in domain interface
      accountFilters: null,  // Not available in domain interface
    );
  }

  /// Legacy method - kept for backward compatibility
  /// Use search() which matches the domain interface
  Future<List<TransactionTemplate>> searchTemplates({
    required String companyId,
    required String storeId,
    String? searchQuery,
    List<String>? categoryFilters,
    List<String>? accountFilters,
  }) async {
    // Search operations always go to database for fresh results
    final templates = await _dataService.searchTemplates(
      companyId: companyId,
      storeId: storeId,
      searchQuery: searchQuery,
      categoryFilters: categoryFilters,
      accountFilters: accountFilters,
    );

    // Cache individual templates
    for (final template in templates) {
      await _cacheRepository.cacheTemplate(template);
    }

    return templates;
  }

  @override
  Future<List<TransactionTemplate>> findByCreatedBy(String userId) async {
    // Fetch from data service
    final templates = await _dataService.findByCreatedBy(userId);
    
    // Cache individual templates
    for (final template in templates) {
      await _cacheRepository.cacheTemplate(template);
    }
    
    return templates;
  }

  @override
  Future<int> countUserTemplates(String userId) async {
    // Count operations always go to database for consistency
    return await _dataService.countUserTemplates(userId);
  }

  /// Refresh all cached data
  Future<void> refreshCache({
    required String companyId,
    required String storeId,
  }) async {
    await _cacheRepository.invalidateAllCache();
    await findByCompanyAndStore(
      companyId: companyId,
      storeId: storeId,
      forceRefresh: true,
    );
  }

}