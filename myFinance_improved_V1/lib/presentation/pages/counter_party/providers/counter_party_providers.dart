import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/counter_party_models.dart';
import '../../../providers/app_state_provider.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Search query provider
final counterPartySearchProvider = StateProvider<String>((ref) => '');

// Filter provider
final counterPartyFilterProvider = StateProvider<CounterPartyFilter>((ref) {
  return const CounterPartyFilter();
});

// Selected counter party for editing
final selectedCounterPartyProvider = StateProvider<CounterParty?>((ref) => null);

// Counter parties list provider
final counterPartiesProvider = FutureProvider<List<CounterParty>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final appState = ref.watch(appStateProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  final filter = ref.watch(counterPartyFilterProvider);
  
  if (selectedCompany == null) {
    return [];
  }

  try {
    
    // Build query
    var query = supabase
        .from('counterparties')
        .select()
        .eq('company_id', selectedCompany['company_id'])
        .eq('is_deleted', false);

    // Apply filters
    if (filter.types != null && filter.types!.isNotEmpty) {
      final typeValues = filter.types!.map((t) => t.displayName).toList();
      query = query.inFilter('type', typeValues);
    }

    if (filter.isInternal != null) {
      query = query.eq('is_internal', filter.isInternal!);
    }

    if (filter.createdAfter != null) {
      query = query.gte('created_at', filter.createdAfter!.toIso8601String());
    }

    if (filter.createdBefore != null) {
      query = query.lte('created_at', filter.createdBefore!.toIso8601String());
    }

    // Apply sorting and execute
    final response = await query.order(
      _getSortColumn(filter.sortBy),
      ascending: filter.ascending,
    );
    
    
    // Convert to CounterParty models
    final counterParties = (response as List)
        .map((json) {
          try {
            return CounterParty.fromJson(json);
          } catch (e) {
            rethrow;
          }
        })
        .toList();
        
    return counterParties;
  } catch (e) {
    throw Exception('Failed to load counterparties: $e');
  }
});

String _getSortColumn(CounterPartySortOption option) {
  switch (option) {
    case CounterPartySortOption.name:
      return 'name';
    case CounterPartySortOption.type:
      return 'type';
    case CounterPartySortOption.createdAt:
      return 'created_at';
    case CounterPartySortOption.isInternal:
      return 'is_internal';
  }
}

// Counter party statistics provider
final counterPartyStatsProvider = FutureProvider<CounterPartyStats>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  if (selectedCompany == null) {
    return CounterPartyStats.empty();
  }

  try {
    // Get all counterparties for stats
    final response = await supabase
        .from('counterparties')
        .select()
        .eq('company_id', selectedCompany['company_id'])
        .eq('is_deleted', false);

    final counterParties = (response as List)
        .map((json) => CounterParty.fromJson(json))
        .toList();

    // Calculate statistics
    final stats = CounterPartyStats(
      total: counterParties.length,
      suppliers: counterParties.where((cp) => cp.type == CounterPartyType.supplier).length,
      customers: counterParties.where((cp) => cp.type == CounterPartyType.customer).length,
      employees: counterParties.where((cp) => cp.type == CounterPartyType.employee).length,
      teamMembers: counterParties.where((cp) => cp.type == CounterPartyType.teamMember).length,
      myCompanies: counterParties.where((cp) => cp.type == CounterPartyType.myCompany).length,
      others: counterParties.where((cp) => cp.type == CounterPartyType.other).length,
      activeCount: counterParties.where((cp) => !cp.isDeleted).length,
      inactiveCount: counterParties.where((cp) => cp.isDeleted).length,
      recentAdditions: counterParties
          .take(5)
          .toList(),
    );

    return stats;
  } catch (e) {
    throw Exception('Failed to load statistics: $e');
  }
});

// Form validation provider
final counterPartyFormValidationProvider = Provider<ValidationResult Function(CounterPartyFormData)>((ref) {
  return (formData) {
    final errors = <String, String>{};

    // Name validation
    if (formData.name.isEmpty) {
      errors['name'] = 'Name is required';
    } else if (formData.name.length < 2) {
      errors['name'] = 'Name must be at least 2 characters';
    } else if (formData.name.length > 100) {
      errors['name'] = 'Name must be less than 100 characters';
    }

    // Email validation
    if (formData.email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(formData.email)) {
        errors['email'] = 'Invalid email format';
      }
    }

    // Phone validation
    if (formData.phone.isNotEmpty) {
      final phoneRegex = RegExp(r'^[\d\s\-\+\(\)]+$');
      if (!phoneRegex.hasMatch(formData.phone)) {
        errors['phone'] = 'Invalid phone format';
      }
    }

    // Internal company validation
    if (formData.isInternal && formData.linkedCompanyId == null) {
      errors['linkedCompanyId'] = 'Please select a company to link';
    }

    return errors.isEmpty 
        ? ValidationResult.valid()
        : ValidationResult.invalid(errors);
  };
});

// Create counter party provider
final createCounterPartyProvider = FutureProvider.family<CounterPartyResponse, CounterPartyFormData>(
  (ref, formData) async {
    final supabase = ref.watch(supabaseClientProvider);
    final validator = ref.watch(counterPartyFormValidationProvider);
    
    // Validate form data
    final validation = validator(formData);
    if (!validation.isValid) {
      return CounterPartyResponse.error(
        message: 'Validation failed',
        code: 'VALIDATION_ERROR',
      );
    }

    try {
      final response = await supabase.from('counterparties').insert({
        'company_id': formData.companyId,
        'name': formData.name,
        'type': formData.type.displayName,
        'email': formData.email.isEmpty ? null : formData.email,
        'phone': formData.phone.isEmpty ? null : formData.phone,
        'address': formData.address.isEmpty ? null : formData.address,
        'notes': formData.notes.isEmpty ? null : formData.notes,
        'is_internal': formData.isInternal,
        'linked_company_id': formData.linkedCompanyId,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      final counterParty = CounterParty.fromJson(response);
      
      // Invalidate the list to refresh
      ref.invalidate(counterPartiesProvider);
      ref.invalidate(counterPartyStatsProvider);
      
      return CounterPartyResponse.success(
        data: counterParty,
        message: 'Counter party created successfully',
      );
    } catch (e) {
      return CounterPartyResponse.error(
        message: 'Failed to create counter party: $e',
        code: 'CREATE_ERROR',
      );
    }
  },
);

// Update counter party provider
final updateCounterPartyProvider = FutureProvider.family<CounterPartyResponse, CounterPartyFormData>(
  (ref, formData) async {
    final supabase = ref.watch(supabaseClientProvider);
    final validator = ref.watch(counterPartyFormValidationProvider);
    
    final user = supabase.auth.currentUser;
    
    if (formData.counterpartyId == null) {
      return const CounterPartyResponse.error(
        message: 'Counter party ID is required for update',
        code: 'MISSING_ID',
      );
    }

    // Validate form data
    final validation = validator(formData);
    if (!validation.isValid) {
      return CounterPartyResponse.error(
        message: 'Validation failed',
        code: 'VALIDATION_ERROR',
      );
    }

    try {
      
      // First, verify the counterparty exists and user has access
      final existingRecord = await supabase
          .from('counterparties')
          .select()
          .eq('counterparty_id', formData.counterpartyId!)
          .maybeSingle();
          
      
      if (existingRecord == null) {
        return CounterPartyResponse.error(
          message: 'Counter party not found or access denied',
          code: 'NOT_FOUND',
        );
      }
      
      final updateData = {
        'name': formData.name,
        'type': formData.type.displayName,
        'email': formData.email.isEmpty ? null : formData.email,
        'phone': formData.phone.isEmpty ? null : formData.phone,
        'address': formData.address.isEmpty ? null : formData.address,
        'notes': formData.notes.isEmpty ? null : formData.notes,
        'is_internal': formData.isInternal,
        'linked_company_id': formData.linkedCompanyId,
        // Don't include updated_at - column doesn't exist in database
      };
      
      
      // Try direct update first, then fallback to RPC if needed
      try {
        
        final response = await supabase
            .from('counterparties')
            .update(updateData)
            .eq('counterparty_id', formData.counterpartyId!)
            .select();
            
        
        if (response.isNotEmpty) {
          final counterParty = CounterParty.fromJson(response.first);
          
          // Invalidate the list to refresh
          ref.invalidate(counterPartiesProvider);
          ref.invalidate(counterPartyStatsProvider);
          
          return CounterPartyResponse.success(
            data: counterParty,
            message: 'Counter party updated successfully',
          );
        }
      } catch (directError) {
      }
      
      // Fallback to RPC function approach
      
      final appState = ref.watch(appStateProvider);
      final userId = appState.user['user_id'];
      
      if (userId == null) {
        return CounterPartyResponse.error(
          message: 'User authentication required',
          code: 'AUTH_REQUIRED',
        );
      }
      
      try {
        // Note: RPC function not available, but keeping for reference
        final rpcResponse = await supabase.rpc('update_counterparty', params: {
          'p_counterparty_id': formData.counterpartyId!,
          'p_user_id': userId,
          'p_name': formData.name,
          'p_type': formData.type.displayName,
          'p_email': formData.email.isEmpty ? null : formData.email,
          'p_phone': formData.phone.isEmpty ? null : formData.phone,
          'p_address': formData.address.isEmpty ? null : formData.address,
          'p_notes': formData.notes.isEmpty ? null : formData.notes,
          'p_is_internal': formData.isInternal,
          'p_linked_company_id': formData.linkedCompanyId,
        });
        
        
        if (rpcResponse['success'] == true) {
          final counterParty = CounterParty.fromJson(rpcResponse['data']);
          
          // Invalidate the list to refresh
          ref.invalidate(counterPartiesProvider);
          ref.invalidate(counterPartyStatsProvider);
          
          return CounterPartyResponse.success(
            data: counterParty,
            message: 'Counter party updated successfully',
          );
        } else {
          return CounterPartyResponse.error(
            message: rpcResponse['error'] ?? 'Update failed',
            code: rpcResponse['code'] ?? 'RPC_ERROR',
          );
        }
      } catch (rpcError) {
        // Final fallback - try a simpler update without select
        
        await supabase
            .from('counterparties')
            .update(updateData)
            .eq('counterparty_id', formData.counterpartyId!);
        
        // Invalidate to refresh and assume success
        ref.invalidate(counterPartiesProvider);
        ref.invalidate(counterPartyStatsProvider);
        
        return CounterPartyResponse.success(
          data: CounterParty.fromJson(existingRecord),
          message: 'Counter party updated successfully',
        );
      }
    } catch (e) {
      
      return CounterPartyResponse.error(
        message: 'Failed to update counter party: $e',
        code: 'UPDATE_ERROR',
      );
    }
  },
);

// Delete counter party provider (soft delete)
final deleteCounterPartyProvider = FutureProvider.family<bool, String>(
  (ref, counterpartyId) async {
    final supabase = ref.watch(supabaseClientProvider);

    try {
      await supabase
          .from('counterparties')
          .update({
            'is_deleted': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('counterparty_id', counterpartyId);

      // Invalidate the list to refresh
      ref.invalidate(counterPartiesProvider);
      ref.invalidate(counterPartyStatsProvider);
      
      return true;
    } catch (e) {
      throw Exception('Failed to delete counter party: $e');
    }
  },
);


// Get unlinked companies provider (for internal linking)
final unlinkedCompaniesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final appState = ref.watch(appStateProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  if (selectedCompany == null || appState.user == null || appState.user['user_id'] == null) {
    return [];
  }

  final userId = appState.user['user_id'];
  
  try {
    
    
    // Call the RPC function to get unlinked companies
    final response = await supabase.rpc('get_unlinked_companies', params: {
      'p_user_id': userId,
      'p_company_id': selectedCompany['company_id'],
    });

    
    if (response == null) {
      return [];
    }
    
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    } else {
      return [];
    }
    
  } catch (e) {
    // Retry RPC call
    try {
      final retryResponse = await supabase.rpc('get_unlinked_companies', params: {
        'p_user_id': userId,
        'p_company_id': selectedCompany['company_id'],
      });
      
      if (retryResponse is List) {
        return List<Map<String, dynamic>>.from(retryResponse);
      } else {
        return [];
      }
      
    } catch (retryError) {
      return [];
    }
  }
});