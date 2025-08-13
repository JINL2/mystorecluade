import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Company service provider
final companyServiceProvider = Provider<CompanyService>((ref) {
  return CompanyService();
});

// Company types provider
final companyTypesProvider = FutureProvider<List<CompanyType>>((ref) async {
  final service = ref.read(companyServiceProvider);
  return service.getCompanyTypes();
});

// Currencies provider
final currenciesProvider = FutureProvider<List<Currency>>((ref) async {
  final service = ref.read(companyServiceProvider);
  return service.getCurrencies();
});

class CompanyService {
  final _supabase = Supabase.instance.client;

  /// Get all company types
  Future<List<CompanyType>> getCompanyTypes() async {
    try {
      final response = await _supabase
          .from('company_types')
          .select('*')
          .order('type_name');
      
      return (response as List)
          .map((json) => CompanyType.fromJson(json))
          .toList();
    } catch (e) {
      print('CompanyService Error: Failed to get company types: $e');
      return [];
    }
  }

  /// Get all currencies
  Future<List<Currency>> getCurrencies() async {
    try {
      final response = await _supabase
          .from('currency_types')
          .select('*')
          .order('currency_name');
      
      return (response as List)
          .map((json) => Currency.fromJson(json))
          .toList();
    } catch (e) {
      print('CompanyService Error: Failed to get currencies: $e');
      return [];
    }
  }

  /// Create a new company and return the company ID if successful
  Future<String?> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('No user logged in');
      }

      // Use a transaction-like approach
      // First, create the company
      final companyCode = _generateCompanyCode(companyName);
      
      final companyResponse = await _supabase
          .from('companies')
          .insert({
            'company_name': companyName,
            'company_code': companyCode,
            'company_type_id': companyTypeId,
            'owner_id': userId,
            'base_currency_id': baseCurrencyId,
          })
          .select()
          .single();

      final companyId = companyResponse['company_id'];
      
      try {
        // Add user to company
        await _supabase
            .from('user_companies')
            .insert({
              'user_id': userId,
              'company_id': companyId,
            });

        // Check if owner role already exists for this company
        final existingRoles = await _supabase
            .from('roles')
            .select('role_id')
            .eq('company_id', companyId)
            .eq('role_name', 'Owner');

        String roleId;
        
        if (existingRoles.isEmpty) {
          // Create owner role only if it doesn't exist
          final roleResponse = await _supabase
              .from('roles')
              .insert({
                'role_name': 'Owner',
                'role_type': 'owner',
                'company_id': companyId,
                'description': 'Company owner with full permissions',
                'is_deletable': false,
              })
              .select()
              .single();
          
          roleId = roleResponse['role_id'];
          
          // Get all features to assign permissions
          final featuresResponse = await _supabase
              .from('features')
              .select('feature_id');

          // Give owner all permissions
          final permissions = (featuresResponse as List).map((feature) => {
            'role_id': roleId,
            'feature_id': feature['feature_id'],
            'can_access': true,
          }).toList();

          if (permissions.isNotEmpty) {
            await _supabase
                .from('role_permissions')
                .insert(permissions);
          }
        } else {
          // Use existing owner role
          roleId = existingRoles[0]['role_id'];
        }

        // Check if user already has this role
        final existingUserRole = await _supabase
            .from('user_roles')
            .select('user_role_id')
            .eq('user_id', userId)
            .eq('role_id', roleId);

        if (existingUserRole.isEmpty) {
          // Assign owner role to user only if they don't have it
          await _supabase
              .from('user_roles')
              .insert({
                'user_id': userId,
                'role_id': roleId,
              });
        }

        // Add company currency if base currency is specified
        await _supabase
            .from('company_currency')
            .insert({
              'company_id': companyId,
              'currency_id': baseCurrencyId,
            });

        return companyId;
      } catch (innerError) {
        // If something goes wrong, we should ideally delete the company
        // But for now, just log the error
        print('CompanyService Error during role creation: $innerError');
        
        // Try to clean up
        try {
          await _supabase
              .from('companies')
              .delete()
              .eq('company_id', companyId);
        } catch (deleteError) {
          print('CompanyService Error: Failed to clean up company: $deleteError');
        }
        
        return null;
      }
    } catch (e) {
      print('CompanyService Error: Failed to create company: $e');
      return null;
    }
  }

  String _generateCompanyCode(String companyName) {
    // Simple code generation - can be improved
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final prefix = companyName.replaceAll(' ', '').substring(0, 3).toUpperCase();
    return '$prefix${timestamp.substring(timestamp.length - 6)}';
  }
}

// Models
class CompanyType {
  final String companyTypeId;
  final String typeName;

  CompanyType({
    required this.companyTypeId,
    required this.typeName,
  });

  factory CompanyType.fromJson(Map<String, dynamic> json) {
    return CompanyType(
      companyTypeId: json['company_type_id'] as String,
      typeName: json['type_name'] as String,
    );
  }
}

class Currency {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;

  Currency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
    );
  }
}