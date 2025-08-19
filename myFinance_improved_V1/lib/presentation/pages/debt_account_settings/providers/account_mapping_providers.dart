import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/account_mapping_models.dart';
import '../../../providers/app_state_provider.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// State notifier for managing account mappings with immediate UI updates
class AccountMappingsNotifier extends StateNotifier<AsyncValue<List<AccountMapping>>> {
  final Ref ref;
  final String counterpartyId;
  
  AccountMappingsNotifier(this.ref, this.counterpartyId) : super(const AsyncValue.loading()) {
    loadMappings();
  }
  
  Future<void> loadMappings() async {
    state = const AsyncValue.loading();
    try {
      final mappings = await _fetchMappings();
      state = AsyncValue.data(mappings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<List<AccountMapping>> _fetchMappings() async {
    final supabase = ref.read(supabaseClientProvider);
    
    final response = await supabase.rpc(
      'get_account_mappings_with_company',
      params: {'p_counterparty_id': counterpartyId},
    );

    final mappings = (response as List).map((json) {
      final adaptedJson = Map<String, dynamic>.from(json);
      adaptedJson['is_active'] = true;
      
      if (adaptedJson['created_at'] != null && adaptedJson['created_at'] is String) {
        adaptedJson['created_at'] = DateTime.parse(adaptedJson['created_at'] as String).toIso8601String();
      }
      
      return AccountMapping.fromJson(adaptedJson);
    }).toList();
    
    return mappings;
  }
  
  // Add mapping and update state immediately
  void addMapping(AccountMapping mapping) {
    state.whenData((mappings) {
      state = AsyncValue.data([...mappings, mapping]);
    });
  }
  
  // Update mapping and update state immediately
  void updateMapping(AccountMapping updatedMapping) {
    state.whenData((mappings) {
      final updatedList = mappings.map((m) => 
        m.mappingId == updatedMapping.mappingId ? updatedMapping : m
      ).toList();
      state = AsyncValue.data(updatedList);
    });
  }
  
  // Remove mapping and update state immediately
  void removeMapping(String mappingId) {
    final currentState = state;
    if (currentState is AsyncData<List<AccountMapping>>) {
      final currentMappings = currentState.value;
      final updatedList = currentMappings.where((m) => m.mappingId != mappingId).toList();
      state = AsyncValue.data(updatedList);
    }
  }
  
  // Refresh from server
  Future<void> refresh() async {
    await loadMappings();
  }
}

// Provider for the state notifier
final accountMappingsProvider = StateNotifierProvider.family<
  AccountMappingsNotifier,
  AsyncValue<List<AccountMapping>>,
  String
>((ref, counterpartyId) {
  return AccountMappingsNotifier(ref, counterpartyId);
});

// Legacy provider for backward compatibility - now just reads from state notifier
final accountMappingsListProvider = FutureProvider.family<List<AccountMapping>, String>((ref, counterpartyId) async {
  // Simply watch the state notifier
  final state = ref.watch(accountMappingsProvider(counterpartyId));
  return state.when(
    data: (mappings) => mappings,
    loading: () => [],
    error: (_, __) => [],
  );
});

// Available DEBT accounts for current company using RPC
final availableAccountsProvider = FutureProvider<List<AccountInfo>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  if (selectedCompany == null) {
    return [];
  }

  try {
    
    // Use RPC function to get only debt accounts
    final response = await supabase.rpc(
      'get_debt_accounts_for_company',
      params: {'p_company_id': selectedCompany['company_id']},
    );
    

    return (response as List)
        .where((json) => json['is_debt_account'] == true) // Extra safety check
        .map((json) => AccountInfo.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to load debt accounts: $e');
  }
});

// Available DEBT accounts for linked company using RPC
final linkedCompanyAccountsProvider = FutureProvider.family<List<AccountInfo>, String>((ref, linkedCompanyId) async {
  final supabase = ref.watch(supabaseClientProvider);

  try {
    
    // Use RPC function to get only debt accounts for linked company
    final response = await supabase.rpc(
      'get_debt_accounts_for_company',
      params: {'p_company_id': linkedCompanyId},
    );
    

    return (response as List)
        .where((json) => json['is_debt_account'] == true) // Extra safety check
        .map((json) => AccountInfo.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to load linked company accounts: $e');
  }
});

// Available internal companies (for linking)
final availableInternalCompaniesProvider = FutureProvider<List<CompanyInfo>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  if (selectedCompany == null) {
    return [];
  }

  try {
    // Get companies that the current user has access to (excluding current company)
    final appState = ref.read(appStateProvider);
    final userCompanies = appState.user['companies'] as List<dynamic>? ?? [];
    
    final availableCompanies = userCompanies
        .where((company) => company['company_id'] != selectedCompany['company_id'])
        .map((company) => CompanyInfo(
          companyId: company['company_id'],
          companyName: company['company_name'],
          companyCode: company['company_code'],
        ))
        .toList();

    return availableCompanies;
  } catch (e) {
    throw Exception('Failed to load internal companies: $e');
  }
});

// Form validation provider
final accountMappingFormValidationProvider = Provider<MappingValidationResult Function(AccountMappingFormData)>((ref) {
  return (formData) {
    final errors = <String, String>{};

    // My account validation
    if (formData.myAccountId == null || formData.myAccountId!.isEmpty) {
      errors['myAccountId'] = 'Please select your account';
    }

    // Linked company validation
    if (formData.linkedCompanyId == null || formData.linkedCompanyId!.isEmpty) {
      errors['linkedCompanyId'] = 'Please select linked company';
    }

    // Linked account validation
    if (formData.linkedAccountId == null || formData.linkedAccountId!.isEmpty) {
      errors['linkedAccountId'] = 'Please select linked account';
    }

    // Self-mapping validation
    if (formData.myAccountId == formData.linkedAccountId) {
      errors['linkedAccountId'] = 'Linked account cannot be the same as your account';
    }

    return errors.isEmpty 
        ? MappingValidationResult.valid()
        : MappingValidationResult.invalid(errors);
  };
});

// Create account mapping provider using RPC
final createAccountMappingProvider = FutureProvider.family<AccountMappingResponse, AccountMappingFormData>(
  (ref, formData) async {
    final supabase = ref.watch(supabaseClientProvider);
    final validator = ref.watch(accountMappingFormValidationProvider);
    
    // Validate form data
    final validation = validator(formData);
    if (!validation.isValid) {
      return AccountMappingResponse.error(
        message: 'Validation failed',
        code: 'VALIDATION_ERROR',
      );
    }

    try {
      
      // Use RPC function to create mapping with validation
      final response = await supabase.rpc(
        'create_account_mapping',
        params: {
          'p_my_company_id': formData.myCompanyId,
          'p_my_account_id': formData.myAccountId,
          'p_counterparty_id': formData.counterpartyId,
          'p_linked_account_id': formData.linkedAccountId,
          'p_direction': 'bidirectional', // Default direction
        },
      );
      
      // RPC returns {success: bool, message: string, mapping_id: uuid}
      final result = response as List;
      if (result.isEmpty) {
        return AccountMappingResponse.error(
          message: 'Failed to create mapping',
          code: 'CREATE_ERROR',
        );
      }
      
      final rpcResult = result.first;
      if (rpcResult['success'] != true) {
        return AccountMappingResponse.error(
          message: rpcResult['message'] ?? 'Failed to create mapping',
          code: 'CREATE_ERROR',
        );
      }
      
      // Refresh mappings to get the new one with all details
      await ref.read(accountMappingsProvider(formData.counterpartyId!).notifier).refresh();
      
      // Get the updated list
      final state = ref.read(accountMappingsProvider(formData.counterpartyId!));
      final mappings = state.value ?? [];
      final newMapping = mappings.firstWhere(
        (m) => m.mappingId == rpcResult['mapping_id'],
        orElse: () => throw Exception('Created mapping not found'),
      );
      
      return AccountMappingResponse.success(
        data: newMapping,
        message: rpcResult['message'] ?? 'Account mapping created successfully',
      );
    } catch (e) {
      return AccountMappingResponse.error(
        message: 'Failed to create account mapping: $e',
        code: 'CREATE_ERROR',
      );
    }
  },
);

// Update account mapping provider using RPC
final updateAccountMappingProvider = FutureProvider.family<AccountMappingResponse, AccountMappingFormData>(
  (ref, formData) async {
    final supabase = ref.watch(supabaseClientProvider);
    final validator = ref.watch(accountMappingFormValidationProvider);
    
    if (formData.mappingId == null) {
      return AccountMappingResponse.error(
        message: 'Mapping ID is required for update',
        code: 'MISSING_ID',
      );
    }

    // Validate form data
    final validation = validator(formData);
    if (!validation.isValid) {
      return AccountMappingResponse.error(
        message: 'Validation failed',
        code: 'VALIDATION_ERROR',
      );
    }

    try {
      
      // Use RPC function to update mapping
      final response = await supabase.rpc(
        'update_account_mapping',
        params: {
          'p_mapping_id': formData.mappingId,
          'p_my_account_id': formData.myAccountId,
          'p_linked_account_id': formData.linkedAccountId,
          'p_direction': 'bidirectional', // Default direction
        },
      );
      
      // RPC returns {success: bool, message: string}
      final result = response as List;
      if (result.isEmpty) {
        return AccountMappingResponse.error(
          message: 'Failed to update mapping',
          code: 'UPDATE_ERROR',
        );
      }
      
      final rpcResult = result.first;
      if (rpcResult['success'] != true) {
        return AccountMappingResponse.error(
          message: rpcResult['message'] ?? 'Failed to update mapping',
          code: 'UPDATE_ERROR',
        );
      }
      
      // Refresh mappings to get the updated one
      await ref.read(accountMappingsProvider(formData.counterpartyId!).notifier).refresh();
      
      // Get the updated list
      final state = ref.read(accountMappingsProvider(formData.counterpartyId!));
      final mappings = state.value ?? [];
      final updatedMapping = mappings.firstWhere(
        (m) => m.mappingId == formData.mappingId,
        orElse: () => throw Exception('Updated mapping not found'),
      );
      
      return AccountMappingResponse.success(
        data: updatedMapping,
        message: rpcResult['message'] ?? 'Account mapping updated successfully',
      );
    } catch (e) {
      return AccountMappingResponse.error(
        message: 'Failed to update account mapping: $e',
        code: 'UPDATE_ERROR',
      );
    }
  },
);

// Delete account mapping provider using RPC with immediate UI update
final deleteAccountMappingProvider = FutureProvider.family<bool, DeleteMappingParams>(
  (ref, params) async {
    final supabase = ref.watch(supabaseClientProvider);

    try {
      
      // Delete from database first
      final response = await supabase.rpc(
        'delete_account_mapping',
        params: {'p_mapping_id': params.mappingId},
      );
      
      // RPC returns {success: bool, message: string}
      final result = response as List;
      if (result.isEmpty) {
        throw Exception('Failed to delete mapping');
      }
      
      final rpcResult = result.first;
      if (rpcResult['success'] != true) {
        throw Exception(rpcResult['message'] ?? 'Failed to delete mapping');
      }
      
      
      // After successful deletion, update the UI
      ref.read(accountMappingsProvider(params.counterpartyId).notifier).removeMapping(params.mappingId);
      
      return true;
    } catch (e) {
      throw Exception('Failed to delete account mapping: $e');
    }
  },
);

// Helper class for delete parameters - exported for use in pages
class DeleteMappingParams {
  final String mappingId;
  final String counterpartyId;
  
  const DeleteMappingParams({
    required this.mappingId,
    required this.counterpartyId,
  });
}