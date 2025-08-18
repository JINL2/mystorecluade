import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../providers/app_state_provider.dart';
import '../../../../data/services/supabase_service.dart';

// Provider to watch categoryFeatures from app state
final templateCategoryFeaturesProvider = Provider<dynamic>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.categoryFeatures;
});

// Provider to watch user data from app state
final templateUserProvider = Provider<dynamic>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.user;
});

// Provider to watch selected company from app state
final templateCompanyChoosenProvider = Provider<String>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.companyChoosen;
});

// Provider to watch selected store from app state
final templateStoreChoosenProvider = Provider<String>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.storeChoosen;
});

// Provider for fetching transaction templates from Supabase
final transactionTemplatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabaseService = ref.read(supabaseServiceProvider);
  final companyId = ref.watch(templateCompanyChoosenProvider);
  final storeId = ref.watch(templateStoreChoosenProvider);

  // If no company or store selected, return empty list
  if (companyId.isEmpty || storeId.isEmpty) {
    return [];
  }

  try {
    // Execute the query with simplified approach - template_id is already included
    final response = await supabaseService.client
        .from('transaction_templates')
        .select('template_id, name, template_description, counterparty_cash_location_id, counterparty_id, data, tags, permission, visibility_level, updated_by')
        .eq('company_id', companyId)
        .eq('store_id', storeId)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    // Safely handle the response
    if (response == null) {
      return [];
    }

    // Try to cast to List
    if (response is List) {
      final List<Map<String, dynamic>> templates = [];
      
      for (var item in response) {
        try {
          if (item is Map<String, dynamic>) {
            templates.add(item);
          } else if (item is Map) {
            templates.add(Map<String, dynamic>.from(item));
          }
        } catch (e) {
          // Skip items that can't be converted
          continue;
        }
      }
      
      return templates;
    }
    
    // If response is not a List, return empty
    return [];
    
  } catch (e) {
    // Log error in debug mode only
    assert(() {
      print('Transaction Templates Error: $e');
      return true;
    }());
    
    // Return empty list to prevent crash
    return [];
  }
});