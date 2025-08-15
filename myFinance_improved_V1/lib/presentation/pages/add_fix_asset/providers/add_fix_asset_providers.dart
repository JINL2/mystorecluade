import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/presentation/providers/auth_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';

/// Provider for user data with companies (reuses app state)
final userCompaniesProvider = FutureProvider<dynamic>((ref) async {
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final appState = ref.watch(appStateProvider);
  
  if (user == null) {
    throw UnauthorizedException();
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
    throw UnauthorizedException();
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

/// Add Fix Asset specific providers

// Provider for submitting a new fixed asset
final submitFixedAssetProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, assetData) async {
  final appState = ref.watch(appStateProvider);
  final user = ref.watch(authStateProvider);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  
  if (companyId.isEmpty || storeId.isEmpty) {
    throw Exception('Company and store must be selected');
  }
  
  // Prepare asset data with company and store information
  final completeAssetData = {
    ...assetData,
    'company_id': companyId,
    'store_id': storeId,
    'created_by': user.id,
    'created_at': DateTime.now().toIso8601String(),
    'status': 'active',
  };
  
  try {
    final supabase = Supabase.instance.client;
    
    // Insert into fixed_assets table (assuming this table exists)
    await supabase
        .from('fixed_assets')
        .insert(completeAssetData);
    
    return true;
  } catch (e) {
    throw Exception('Failed to add fixed asset: $e');
  }
});

// Provider for fetching existing fixed assets for the selected company/store
final fixedAssetsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, selectedStoreId) async {
  final appState = ref.watch(appStateProvider);
  final user = ref.watch(authStateProvider);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    return [];
  }
  
  try {
    final supabase = Supabase.instance.client;
    
    // Build query for fixed assets with required columns
    var query = supabase
        .from('fixed_assets')
        .select('asset_id, asset_name, acquisition_date, acquisition_cost, useful_life_years, salvage_value')
        .eq('company_id', companyId);
    
    // Add store filter based on selection
    if (selectedStoreId == null) {
      // Headquarters selected - filter for null store_id
      query = query.isFilter('store_id', null);
    } else if (selectedStoreId.isNotEmpty) {
      // Specific store selected
      query = query.eq('store_id', selectedStoreId);
    }
    
    final response = await query.order('acquisition_date', ascending: false);
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    // If table doesn't exist or other error, return empty list
    return [];
  }
});

// Provider for asset categories (if needed)
final assetCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Fetch asset categories if such a table exists
    final response = await supabase
        .from('asset_categories')
        .select()
        .order('name', ascending: true);
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    // If table doesn't exist, return some default categories
    return [
      {'id': '1', 'name': 'Equipment'},
      {'id': '2', 'name': 'Furniture'},
      {'id': '3', 'name': 'Vehicles'},
      {'id': '4', 'name': 'Electronics'},
      {'id': '5', 'name': 'Property'},
      {'id': '6', 'name': 'Other'},
    ];
  }
});

/// Provider for fetching company's base currency
final companyBaseCurrencyProvider = FutureProvider<String?>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    return null;
  }
  
  try {
    final supabase = Supabase.instance.client;
    
    // Query companies table to get base_currency_id
    final response = await supabase
        .from('companies')
        .select('base_currency_id')
        .eq('company_id', companyId)
        .single();
    
    return response['base_currency_id'] as String?;
  } catch (e) {
    return null;
  }
});

/// Provider for fetching currency symbol from currency_types table
final currencySymbolProvider = FutureProvider.family<String, String>((ref, currencyId) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Query currency_types table to get symbol
    final response = await supabase
        .from('currency_types')
        .select('symbol')
        .eq('currency_id', currencyId)
        .single();
    
    return response['symbol'] as String? ?? '\$';
  } catch (e) {
    return '\$'; // Default to $ if error
  }
});

/// Exception class
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'User is not authenticated']);
  
  @override
  String toString() => message;
}