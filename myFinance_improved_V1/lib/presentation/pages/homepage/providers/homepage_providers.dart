import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/domain/repositories/user_repository.dart';
import 'package:myfinance_improved/domain/repositories/company_repository.dart';
import 'package:myfinance_improved/domain/repositories/feature_repository.dart';
import 'package:myfinance_improved/domain/entities/company.dart';
import 'package:myfinance_improved/domain/entities/store.dart';
import 'package:myfinance_improved/presentation/providers/auth_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import '../models/homepage_models.dart';

/// Provider for user data with companies (integrates with app state)
final userCompaniesProvider = FutureProvider<dynamic>((ref) async {
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  // Watch app state to rebuild when data changes
  final appState = ref.watch(appStateProvider);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  // Check if we need to refresh (no cached data)
  final needsRefresh = !appStateNotifier.hasUserData;
  
  // Check if we have cached data and don't need to refresh
  if (appStateNotifier.hasUserData && !needsRefresh) {
    return appState.user;
  }
  
  // Fetch fresh data from API using RPC function
  
  // Call get_user_companies_and_stores(user_id) RPC
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  for (final company in companies) {
    final stores = company['stores'] as List<dynamic>? ?? [];
  }
  
  // Auto-select first company if none selected
  if (appState.companyChoosen.isEmpty && companies.isNotEmpty) {
    await appStateNotifier.setCompanyChoosen(companies.first['company_id']);
  }
  
  return response;
});

/// Force refresh provider - ALWAYS fetches from API
final forceRefreshUserCompaniesProvider = FutureProvider<dynamic>((ref) async {
  
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  // ALWAYS fetch fresh data from API - no cache check
  
  // Call get_user_companies_and_stores(user_id) RPC
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  for (final company in companies) {
    final stores = company['stores'] as List<dynamic>? ?? [];
  }
  
  // Auto-select first company if none selected
  final appState = ref.read(appStateProvider);
  if (appState.companyChoosen.isEmpty && companies.isNotEmpty) {
    await appStateNotifier.setCompanyChoosen(companies.first['company_id']);
  }
  
  return response;
});

// Note: selectedCompanyProvider and selectedStoreProvider are now imported from app_state_provider.dart
// to avoid duplication and ensure single source of truth

/// Provider for categories with features filtered by permissions
final categoriesWithFeaturesProvider = FutureProvider<dynamic>((ref) async {
  // Watch app state to rebuild when data changes
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  
  // Check if we need to refresh (no cached data)
  final needsRefresh = !appStateNotifier.hasCategoryFeatures;
  
  // Check if we have cached categories and don't need to refresh
  if (appStateNotifier.hasCategoryFeatures && !needsRefresh) {
    return appState.categoryFeatures;
  }
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    return [];
  }
  
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  
  // Try to fetch categories with features using RPC v2, fallback to v1
  final supabase = Supabase.instance.client;
  dynamic categories;
  try {
    categories = await supabase.rpc('get_categories_with_features_v2');
  } catch (e) {
    // Fallback to original function if v2 doesn't exist yet
    categories = await supabase.rpc('get_categories_with_features');
  }
  
  // Filter features based on user permissions
  final filteredCategories = [];
  for (final category in categories) {
    final features = category['features'] as List<dynamic>? ?? [];
    final filteredFeatures = features.where((feature) {
      return permissions.contains(feature['feature_id']);
    }).toList();
    
    if (filteredFeatures.isNotEmpty) {
      filteredCategories.add({
        'category_id': category['category_id'],
        'category_name': category['category_name'],
        'features': filteredFeatures,
      });
    }
  }
  
  // Save to app state for caching
  await appStateNotifier.setCategoryFeatures(filteredCategories);
  
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
  
  // Try to fetch fresh categories from API using RPC v2, fallback to v1
  final supabase = Supabase.instance.client;
  dynamic categories;
  try {
    categories = await supabase.rpc('get_categories_with_features_v2');
  } catch (e) {
    // Fallback to original function if v2 doesn't exist yet
    categories = await supabase.rpc('get_categories_with_features');
  }
  
  // Filter features based on user permissions
  final filteredCategories = [];
  for (final category in categories) {
    final features = category['features'] as List<dynamic>? ?? [];
    final filteredFeatures = features.where((feature) {
      return permissions.contains(feature['feature_id']);
    }).toList();
    
    
    if (filteredFeatures.isNotEmpty) {
      filteredCategories.add({
        'category_id': category['category_id'],
        'category_name': category['category_name'],
        'features': filteredFeatures,
      });
    }
  }
  
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
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  if (selectedCompany == null) return false;
  final role = selectedCompany['role'] as Map<String, dynamic>?;
  return role?['role_name'] == 'Owner';
});

/// Provider for top features by user based on usage
final topFeaturesByUserProvider = FutureProvider<List<TopFeature>>((ref) async {
  final user = ref.watch(authStateProvider);
  
  if (user == null) {
    return [];
  }
  
  final repository = ref.watch(featureRepositoryProvider);
  return repository.getTopFeaturesByUser(userId: user.id);
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
  return SupabaseFeatureRepository();
});

/// Exception classes
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'User is not authenticated']);
}