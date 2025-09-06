import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/presentation/providers/auth_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import 'package:myfinance_improved/data/services/store_service.dart';

// Re-export the providers from app_state_provider for convenience
export 'package:myfinance_improved/presentation/providers/app_state_provider.dart' 
    show selectedCompanyProvider, selectedStoreProvider;

/// Provider for user data with companies (reuses app state)
final userCompaniesProvider = FutureProvider<dynamic>((ref) async {
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final appState = ref.watch(appStateProvider);
  
  if (user == null) {
    // Return null instead of throwing exception when user is not authenticated
    return null;
  }
  
  // Check if we have cached data
  if (appStateNotifier.hasUserData) {
    return appState.user;
  }
  
  // Fetch fresh data from API using RPC function
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  
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
    // Return null instead of throwing exception when user is not authenticated
    return null;
  }
  
  // ALWAYS fetch fresh data from API
  final supabase = Supabase.instance.client;
  final response = await supabase.rpc('get_user_companies_and_stores', params: {'p_user_id': user.id});
  
  // Save to app state for persistence
  await appStateNotifier.setUser(response);
  
  final companies = response['companies'] as List<dynamic>? ?? [];
  
  // Auto-select first company if none selected
  final appState = ref.read(appStateProvider);
  if (appState.companyChoosen.isEmpty && companies.isNotEmpty) {
    await appStateNotifier.setCompanyChoosen(companies.first['company_id']);
  }
  
  return response;
});

/// Provider for categories with features filtered by permissions
final categoriesWithFeaturesProvider = FutureProvider<dynamic>((ref) async {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  // Check if we have cached categories
  if (appStateNotifier.hasCategoryFeatures) {
    return appState.categoryFeatures;
  }
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    return [];
  }
  
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  
  // Fetch all categories with features using RPC
  final supabase = Supabase.instance.client;
  final categories = await supabase.rpc('get_categories_with_features');
  
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
  
  // ALWAYS fetch fresh categories from API using RPC
  final supabase = Supabase.instance.client;
  final categories = await supabase.rpc('get_categories_with_features');
  
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

/// Store Shift specific providers will be added here
/// For now, we maintain the same app state structure as homepage

/// Provider to fetch shifts for a selected store
final storeShiftsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final selectedStore = ref.watch(selectedStoreProvider);
  
  // If no store is selected, return empty list
  if (selectedStore == null || appState.storeChoosen.isEmpty) {
    return [];
  }
  
  final storeId = appState.storeChoosen;
  
  try {
    final supabase = Supabase.instance.client;
    
    // Query store_shifts table with filters
    final response = await supabase
        .from('store_shifts')
        .select('shift_id, shift_name, start_time, end_time, is_active')
        .eq('store_id', storeId)
        .eq('is_active', true)
        .order('start_time', ascending: true);
    
    final shifts = List<Map<String, dynamic>>.from(response as List);
    
    return shifts;
  } catch (e) {
    throw Exception('Failed to load shifts: $e');
  }
});

/// Provider to fetch detailed store information
final storeDetailsProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final appState = ref.watch(appStateProvider);
  final selectedStore = ref.watch(selectedStoreProvider);
  
  // If no store is selected, return null
  if (selectedStore == null || appState.storeChoosen.isEmpty) {
    return null;
  }
  
  final storeService = ref.read(storeServiceProvider);
  final storeData = await storeService.getStoreById(appState.storeChoosen);
  
  return storeData;
});

/// Provider to manage store operating hours
final storeOperatingHoursProvider = StateProvider.autoDispose<Map<String, Map<String, String>>>((ref) {
  // Default operating hours structure
  return {
    'Monday': {'open': '09:00', 'close': '22:00'},
    'Tuesday': {'open': '09:00', 'close': '22:00'},
    'Wednesday': {'open': '09:00', 'close': '22:00'},
    'Thursday': {'open': '09:00', 'close': '22:00'},
    'Friday': {'open': '09:00', 'close': '23:00'},
    'Saturday': {'open': '10:00', 'close': '23:00'},
    'Sunday': {'open': '10:00', 'close': '21:00'},
  };
});

/// Provider to manage store update loading state
final storeUpdateLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Exception class
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'User is not authenticated']);
}