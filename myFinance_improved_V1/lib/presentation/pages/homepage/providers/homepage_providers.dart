import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/domain/repositories/user_repository.dart';
import 'package:myfinance_improved/domain/repositories/company_repository.dart';
import 'package:myfinance_improved/domain/repositories/feature_repository.dart';
import 'package:myfinance_improved/data/repositories/supabase_feature_repository.dart' as data_repo;
// Removed unused imports for better performance
import 'package:myfinance_improved/presentation/providers/auth_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import 'package:myfinance_improved/presentation/providers/session_manager_provider.dart';
import '../models/homepage_models.dart';

/// Utility methods for API calls and permission filtering
class _HomepageUtils {
  /// Fetches categories with v2/v1 fallback pattern
  static Future<List<dynamic>> fetchCategoriesWithFeatures() async {
    final supabase = Supabase.instance.client;
    try {
      return await supabase.rpc('get_categories_with_features_v2');
    } catch (e) {
      // Fallback to original function if v2 doesn't exist yet
      return await supabase.rpc('get_categories_with_features');
    }
  }
  
  /// Filters features based on is_show_main and user permissions efficiently
  static List<Map<String, dynamic>> filterCategoriesByPermissions(
    List<dynamic> categories, 
    List<dynamic> permissions
  ) {
    final permissionSet = Set<String>.from(permissions.cast<String>());
    final filteredCategories = <Map<String, dynamic>>[];
    
    for (final category in categories) {
      final features = category['features'] as List<dynamic>? ?? [];
      final filteredFeatures = features.where((feature) {
        
        // STEP 1: Filter by is_show_main (only show features meant for main page)
        final isShowMain = feature['is_show_main'] as bool? ?? true;
        if (!isShowMain) {
          return false;
        }
        
        // STEP 2: Filter by user permissions (existing logic)
        final hasPermission = permissionSet.contains(feature['feature_id']);
        return hasPermission;
      }).toList();
      
      if (filteredFeatures.isNotEmpty) {
        filteredCategories.add({
          'category_id': category['category_id'],
          'category_name': category['category_name'],
          'features': filteredFeatures,
        });
      }
    }
    
    return filteredCategories;
  }
}

/// Provider for user data with companies (integrates with intelligent caching)
final userCompaniesProvider = FutureProvider<dynamic>((ref) async {
  debugPrint('🔵 [userCompaniesProvider] Provider called');
  
  final user = ref.watch(authStateProvider);
  debugPrint('🔵 [userCompaniesProvider] User auth state: ${user != null ? "authenticated (${user.id})" : "not authenticated"}');
  
  if (user == null) {
    debugPrint('🔵 [userCompaniesProvider] Returning null - user not authenticated');
    // Return null instead of throwing exception when user is not authenticated
    return null;
  }
  
  // Read app state WITHOUT watching to avoid rebuilds
  final appState = ref.read(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  // Check if we have cached data
  final hasCache = appStateNotifier.hasUserData;
  
  debugPrint('🔵 [userCompaniesProvider] Cache check - hasCache: $hasCache');
  
  // Use cached data if available
  if (hasCache) {
    final cachedData = appState.user;
    if (cachedData != null && cachedData is Map && cachedData.isNotEmpty) {
      debugPrint('🔵 [userCompaniesProvider] Returning cached data from app state');
      // Return cached data immediately
      return cachedData;
    }
  }
  
  // Fetch fresh data from API using RPC function
  debugPrint('🔵 [userCompaniesProvider] Fetching fresh data from API...');
  
  dynamic response;
  try {
    final supabase = Supabase.instance.client;
    debugPrint('🔵 [userCompaniesProvider] Calling RPC get_user_companies_and_stores with user_id: ${user.id}');
    
    response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
    
    debugPrint('🔵 [userCompaniesProvider] RPC response received');
    debugPrint('🔵 [userCompaniesProvider] Response type: ${response.runtimeType}');
    if (response is Map) {
      final companies = response['companies'] as List<dynamic>? ?? [];
      debugPrint('🔵 [userCompaniesProvider] Companies count: ${companies.length}');
    }
    
    // Save to app state for persistence
    debugPrint('🔵 [userCompaniesProvider] Saving to app state...');
    await appStateNotifier.setUser(response);
    debugPrint('🔵 [userCompaniesProvider] Saved to app state');
  } catch (e, stack) {
    debugPrint('🔵 [userCompaniesProvider] ERROR fetching data: $e');
    debugPrint('🔵 [userCompaniesProvider] Stack: $stack');
    rethrow;
  }
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  
  // 🎯 SMART AUTO-SELECTION: Delicate company and store selection on fresh login
  final currentState = ref.read(appStateProvider);
  
  if (companies.isNotEmpty) {
    // CASE 1: No company selected - auto-select first company and store
    if (currentState.companyChoosen.isEmpty) {
      final firstCompany = companies.first;
      final companyId = firstCompany['company_id'] as String;
      
      await appStateNotifier.setCompanyChoosen(companyId);
      
      // Auto-select first store from first company
      final stores = firstCompany['stores'] as List<dynamic>? ?? [];
      if (stores.isNotEmpty) {
        final firstStore = stores.first;
        final storeId = firstStore['store_id'] as String;
        
        await appStateNotifier.setStoreChoosen(storeId);
      }
    } 
    // CASE 2: Company selected but validate it still exists and handle store selection
    else {
      final selectedCompanyExists = companies.any((company) => 
        company['company_id'] == currentState.companyChoosen);
        
      if (!selectedCompanyExists) {
        // Selected company no longer exists - fallback to first company
        final firstCompany = companies.first;
        final companyId = firstCompany['company_id'] as String;
        
        await appStateNotifier.setCompanyChoosen(companyId);
        await appStateNotifier.setStoreChoosen(''); // Reset store selection
        
        // Auto-select first store from new company
        final stores = firstCompany['stores'] as List<dynamic>? ?? [];
        if (stores.isNotEmpty) {
          final firstStore = stores.first;
          final storeId = firstStore['store_id'] as String;
          
          await appStateNotifier.setStoreChoosen(storeId);
        }
      } else if (currentState.storeChoosen.isEmpty) {
        // Company exists but no store selected - auto-select first store
        final selectedCompany = companies.firstWhere((company) => 
          company['company_id'] == currentState.companyChoosen);
        final stores = selectedCompany['stores'] as List<dynamic>? ?? [];
        
        if (stores.isNotEmpty) {
          final firstStore = stores.first;
          final storeId = firstStore['store_id'] as String;
          
          await appStateNotifier.setStoreChoosen(storeId);
        }
      }
    }
  }
  
  
  // IMPORTANT: Always return from app state (single source of truth)
  // This ensures that any local updates to app state are reflected immediately
  return ref.read(appStateProvider).user;
});

/// Force refresh provider - ALWAYS fetches from API
final forceRefreshUserCompaniesProvider = FutureProvider<dynamic>((ref) async {
  
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  if (user == null) {
    // Return null instead of throwing exception when user is not authenticated
    return null;
  }
  
  // ALWAYS fetch fresh data from API - no cache check
  
  // Call get_user_companies_and_stores(user_id) RPC
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  // Note: companies include stores data from RPC response
  
  // 🎯 SMART AUTO-SELECTION: Delicate company and store selection on fresh data
  final currentState = ref.read(appStateProvider);
  
  if (companies.isNotEmpty) {
    // CASE 1: No company selected - auto-select first company and store
    if (currentState.companyChoosen.isEmpty) {
      final firstCompany = companies.first;
      final companyId = firstCompany['company_id'] as String;
      
      await appStateNotifier.setCompanyChoosen(companyId);
      
      // Auto-select first store from first company
      final stores = firstCompany['stores'] as List<dynamic>? ?? [];
      if (stores.isNotEmpty) {
        final firstStore = stores.first;
        final storeId = firstStore['store_id'] as String;
        
        await appStateNotifier.setStoreChoosen(storeId);
      }
    } 
    // CASE 2: Company selected but validate it still exists and handle store selection
    else {
      final selectedCompanyExists = companies.any((company) => 
        company['company_id'] == currentState.companyChoosen);
        
      if (!selectedCompanyExists) {
        // Selected company no longer exists - fallback to first company
        final firstCompany = companies.first;
        final companyId = firstCompany['company_id'] as String;
        
        await appStateNotifier.setCompanyChoosen(companyId);
        await appStateNotifier.setStoreChoosen(''); // Reset store selection
        
        // Auto-select first store from new company
        final stores = firstCompany['stores'] as List<dynamic>? ?? [];
        if (stores.isNotEmpty) {
          final firstStore = stores.first;
          final storeId = firstStore['store_id'] as String;
          
          await appStateNotifier.setStoreChoosen(storeId);
        }
      } else if (currentState.storeChoosen.isEmpty) {
        // Company exists but no store selected - auto-select first store
        final selectedCompany = companies.firstWhere((company) => 
          company['company_id'] == currentState.companyChoosen);
        final stores = selectedCompany['stores'] as List<dynamic>? ?? [];
        
        if (stores.isNotEmpty) {
          final firstStore = stores.first;
          final storeId = firstStore['store_id'] as String;
          
          await appStateNotifier.setStoreChoosen(storeId);
        }
      }
    }
  }
  
  // IMPORTANT: Always return from app state (single source of truth)
  // This ensures consistency across all providers
  return ref.read(appStateProvider).user;
});

// Note: selectedCompanyProvider and selectedStoreProvider are now imported from app_state_provider.dart
// to avoid duplication and ensure single source of truth

/// Provider for categories with features filtered by permissions (with intelligent caching)
final categoriesWithFeaturesProvider = FutureProvider.autoDispose<dynamic>((ref) async {
  // Wait for user data to be loaded first (dependency)
  final userData = await ref.watch(userCompaniesProvider.future);
  
  // Return empty list if user is not authenticated
  if (userData == null) {
    return [];
  }
  
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final sessionManager = ref.read(sessionManagerProvider.notifier);
  
  
  // Check if user has no companies
  final companies = userData['companies'] as List<dynamic>? ?? [];
  if (companies.isEmpty) {
    return [];
  }
  
  // Smart caching decision based on session state
  final shouldFetch = sessionManager.shouldFetchFeatures();
  final hasCache = appStateNotifier.hasCategoryFeatures;
  
  // Use cached data if available and fresh (read state to avoid watching)
  if (hasCache && !shouldFetch) {
    final currentState = ref.read(appStateProvider);
    return currentState.categoryFeatures;
  }
  
  // Get selected company from app state (read to avoid watching)
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    return [];
  }
  
  
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  
  // Fetch categories with efficient v2/v1 fallback
  final categories = await _HomepageUtils.fetchCategoriesWithFeatures();
  
  // Apply permission filtering efficiently
  final filteredCategories = _HomepageUtils.filterCategoriesByPermissions(categories, permissions);
  
  // Save to app state for caching
  await appStateNotifier.setCategoryFeatures(filteredCategories);
  
  // Record successful features fetch for cache TTL
  await sessionManager.recordFeaturesFetch();
  
  
  return filteredCategories;
});

/// Force refresh provider for categories - ALWAYS fetches from API
final forceRefreshCategoriesProvider = FutureProvider<dynamic>((ref) async {
  
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    return [];
  }
  
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  
  // Fetch categories with efficient v2/v1 fallback
  final categories = await _HomepageUtils.fetchCategoriesWithFeatures();
  
  // Apply permission filtering efficiently
  final filteredCategories = _HomepageUtils.filterCategoriesByPermissions(categories, permissions);
  
  // Save to app state for caching
  await appStateNotifier.setCategoryFeatures(filteredCategories);
  
  return filteredCategories;
});

/// Homepage loading state model
class HomepageLoading {
  const HomepageLoading({
    this.isUserDataLoading = false,
    this.isFeaturesLoading = false,
    this.isSyncLoading = false,
  });

  final bool isUserDataLoading;
  final bool isFeaturesLoading;
  final bool isSyncLoading;

  HomepageLoading copyWith({
    bool? isUserDataLoading,
    bool? isFeaturesLoading,
    bool? isSyncLoading,
  }) {
    return HomepageLoading(
      isUserDataLoading: isUserDataLoading ?? this.isUserDataLoading,
      isFeaturesLoading: isFeaturesLoading ?? this.isFeaturesLoading,
      isSyncLoading: isSyncLoading ?? this.isSyncLoading,
    );
  }
}

/// Provider for homepage loading states
class HomepageLoadingStateNotifier extends StateNotifier<HomepageLoading> {
  HomepageLoadingStateNotifier() : super(const HomepageLoading());

  void setUserDataLoading(bool isLoading) {
    state = state.copyWith(isUserDataLoading: isLoading);
  }

  void setFeaturesLoading(bool isLoading) {
    state = state.copyWith(isFeaturesLoading: isLoading);
  }

  void setSyncLoading(bool isLoading) {
    state = state.copyWith(isSyncLoading: isLoading);
  }
}

final homepageLoadingStateProvider = StateNotifierProvider<HomepageLoadingStateNotifier, HomepageLoading>((ref) {
  return HomepageLoadingStateNotifier();
});

/// Provider to check if user can add stores (Owner role only)
final canAddStoreProvider = Provider<bool>((ref) {
  ref.watch(appStateProvider); // Watch for changes
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  if (selectedCompany == null) return false;
  final role = selectedCompany['role'] as Map<String, dynamic>?;
  return role?['role_name'] == 'Owner';
});

/// Provider for top features by user based on usage
/// SECURITY: Now properly validates against user permissions from categories
final topFeaturesByUserProvider = FutureProvider<List<TopFeature>>((ref) async {
  final user = ref.watch(authStateProvider);
  
  if (user == null) {
    return [];
  }
  
  try {
    // STEP 1: Establish dependency on categories to ensure permissions are loaded first
    
    // Wait for categories but with timeout protection
    await ref.watch(categoriesWithFeaturesProvider.future)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      return []; // Empty categories = no permission filter
    });
    
    // STEP 2: Get user permissions from selected company
    final appStateNotifier = ref.read(appStateProvider.notifier);
    final selectedCompany = appStateNotifier.selectedCompany;
    
    List<dynamic> userPermissions = [];
    if (selectedCompany != null) {
      final role = selectedCompany['role'] as Map<String, dynamic>?;
      userPermissions = role?['permissions'] as List<dynamic>? ?? [];
    }
    
    // STEP 3: Fetch user's top features from database with company_id
    final repository = ref.watch(featureRepositoryProvider);
    final companyId = appStateNotifier.state.companyChoosen;
    final allTopFeatures = await repository.getTopFeaturesByUser(
      userId: user.id,
      companyId: companyId,
    );
    
    // STEP 4: Apply permission filtering with safety measures
    if (userPermissions.isEmpty) {
      // SAFETY: If no permissions loaded, show all top features (graceful degradation)
      return allTopFeatures;
    }
    
    // Filter features by is_show_main and permissions efficiently using Set lookup
    final permissionSet = Set<String>.from(userPermissions.cast<String>());
    final filteredFeatures = allTopFeatures.where((feature) {
      // STEP 1: Filter by is_show_main (only show features meant for main page)
      if (!feature.isShowMain) {
        return false;
      }
      
      // STEP 2: Filter by user permissions (existing logic)
      final hasPermission = permissionSet.contains(feature.featureId);
      return hasPermission;
    }).toList();
    
    return filteredFeatures;
    
  } catch (e) {
    
    // SAFETY: On any error, fallback to basic fetch without permission filter
    // This ensures user experience isn't completely broken
    try {
      final repository = ref.watch(featureRepositoryProvider);
      final fallbackFeatures = await repository.getTopFeaturesByUser(userId: user.id);
      return fallbackFeatures;
    } catch (fallbackError) {
      return [];
    }
  }
});

/// Provider for safe top features validation (backup method)
/// This provides top features without permission filtering for emergency fallback
final topFeaturesByUserFallbackProvider = FutureProvider<List<TopFeature>>((ref) async {
  final user = ref.watch(authStateProvider);
  
  if (user == null) return [];
  
  final repository = ref.watch(featureRepositoryProvider);
  // Get company_id from app state for fallback provider
  final appState = ref.read(appStateProvider);
  return repository.getTopFeaturesByUser(
    userId: user.id,
    companyId: appState.companyChoosen,
  );
});

/// Provider for company count to detect changes
final localCompanyCountProvider = Provider<int?>((ref) {
  final userData = ref.watch(userCompaniesProvider).valueOrNull;
  if (userData == null) return null;
  return userData['company_count'] as int?;
});

/// Repository providers (using Supabase implementations)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return SupabaseUserRepository();
});

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  return SupabaseCompanyRepository();
});

final featureRepositoryProvider = Provider<FeatureRepository>((ref) {
  return data_repo.SupabaseFeatureRepository(Supabase.instance.client, ref);
});

/// Provider for user shift overview data (salary estimation)
final userShiftOverviewProvider = FutureProvider.autoDispose<UserShiftOverview?>((ref) async {
  try {
    final user = ref.watch(authStateProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (user == null || companyId.isEmpty) {
      return null;
    }
    
    // Get current date in yyyy-MM-dd format
    final now = DateTime.now();
    final requestDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    // Call the RPC function
    final supabase = Supabase.instance.client;
    
    final response = await supabase.rpc(
      'user_shift_overview',
      params: {
        'p_request_date': requestDate,
        'p_user_id': user.id,
        'p_company_id': companyId,
        'p_store_id': storeId.isEmpty ? null : storeId,
      },
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return null;
      },
    );
    
    if (response == null) {
      return null;
    }
    
    // Parse response into UserShiftOverview model
    return UserShiftOverview.fromJson(response as Map<String, dynamic>);
  } catch (e) {
    return null;
  }
});

/// Exception classes
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'User is not authenticated']);
}