import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'company_service.dart';

// Enhanced company service provider with better error handling
final enhancedCompanyServiceProvider = Provider<EnhancedCompanyService>((ref) {
  return EnhancedCompanyService();
});

/// Enhanced company service with comprehensive error handling and result types
class EnhancedCompanyService extends CompanyService {
  /// Create a new company with comprehensive error handling
  @override
  Future<CompanyCreationResult> createCompanyEnhanced({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return CompanyCreationResult.failure(
          error: 'Authentication required',
          errorCode: 'AUTH_REQUIRED',
          userMessage: 'Please log in to create a business',
        );
      }

      // Validate inputs
      if (companyName.trim().isEmpty) {
        return CompanyCreationResult.failure(
          error: 'Company name is required',
          errorCode: 'INVALID_NAME',
          userMessage: 'Please enter a valid company name',
        );
      }

      if (companyName.trim().length < 2) {
        return CompanyCreationResult.failure(
          error: 'Company name too short',
          errorCode: 'NAME_TOO_SHORT',
          userMessage: 'Company name must be at least 2 characters',
        );
      }

      if (companyName.trim().length > 100) {
        return CompanyCreationResult.failure(
          error: 'Company name too long',
          errorCode: 'NAME_TOO_LONG',
          userMessage: 'Company name must be less than 100 characters',
        );
      }

      // Check for duplicate company name for this user
      final existingCompanies = await _supabase
          .from('companies')
          .select('company_id')
          .eq('owner_id', userId)
          .ilike('company_name', companyName.trim())
          .eq('is_deleted', false);

      if (existingCompanies.isNotEmpty) {
        return CompanyCreationResult.failure(
          error: 'Duplicate company name',
          errorCode: 'DUPLICATE_NAME',
          userMessage: 'You already have a business with this name',
        );
      }

      // Verify company type exists
      final companyTypeExists = await _supabase
          .from('company_types')
          .select('company_type_id')
          .eq('company_type_id', companyTypeId)
          .maybeSingle();

      if (companyTypeExists == null) {
        return CompanyCreationResult.failure(
          error: 'Invalid company type',
          errorCode: 'INVALID_COMPANY_TYPE',
          userMessage: 'Please select a valid business type',
        );
      }

      // Verify currency exists
      final currencyExists = await _supabase
          .from('currency_types')
          .select('currency_id')
          .eq('currency_id', baseCurrencyId)
          .maybeSingle();

      if (currencyExists == null) {
        return CompanyCreationResult.failure(
          error: 'Invalid currency',
          errorCode: 'INVALID_CURRENCY',
          userMessage: 'Please select a valid currency',
        );
      }

      // Create the company using transaction-like approach
      final result = await _createCompanyWithRollback(
        companyName: companyName.trim(),
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
        userId: userId,
      );

      return result;

    } on PostgrestException catch (e) {
      return CompanyCreationResult.failure(
        error: 'Database error: ${e.message}',
        errorCode: e.code ?? 'DATABASE_ERROR',
        userMessage: _mapPostgrestError(e),
      );
    } catch (e) {
      return CompanyCreationResult.failure(
        error: e.toString(),
        errorCode: 'UNKNOWN_ERROR',
        userMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Join a company with comprehensive error handling
  @override
  Future<CompanyJoinResult> joinCompanyEnhanced({
    required String companyCode,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return CompanyJoinResult.failure(
          error: 'Authentication required',
          errorCode: 'AUTH_REQUIRED',
          userMessage: 'Please log in to join a business',
        );
      }

      // Validate business code format
      final codeValidation = await validateBusinessCodeFormat(companyCode);
      if (!codeValidation.isValid) {
        return CompanyJoinResult.failure(
          error: codeValidation.errorMessage ?? 'Invalid code format',
          errorCode: codeValidation.errorCode ?? 'INVALID_FORMAT',
          userMessage: codeValidation.errorMessage ?? 'Please enter a valid business code',
        );
      }

      // Use the normalized code
      final normalizedCode = codeValidation.normalizedCode ?? companyCode.trim().toUpperCase();

      // Use RPC function for joining business
      final response = await _supabase.rpc(
        'join_business_by_code',
        params: {
          'p_user_id': userId,
          'p_business_code': normalizedCode,
        },
      );

      final result = response as Map<String, dynamic>;
      
      if (result['success'] == true) {
        return CompanyJoinResult.success(
          companyId: result['company_id'],
          companyName: result['company_name'] ?? result['business_name'],
          businessType: result['business_type'],
          roleAssigned: result['role_assigned'],
          joinedAt: result['joined_at'] != null 
              ? DateTime.parse(result['joined_at'])
              : DateTime.now(),
        );
      } else {
        final errorCode = result['error_code'] ?? 'UNKNOWN_ERROR';
        final errorMessage = result['error'] ?? 'Unknown error occurred';
        
        return CompanyJoinResult.failure(
          error: errorMessage,
          errorCode: errorCode,
          userMessage: _mapJoinErrorCode(errorCode, errorMessage),
        );
      }

    } on PostgrestException catch (e) {
      return CompanyJoinResult.failure(
        error: 'Database error: ${e.message}',
        errorCode: e.code ?? 'DATABASE_ERROR',
        userMessage: _mapPostgrestError(e),
      );
    } catch (e) {
      return CompanyJoinResult.failure(
        error: e.toString(),
        errorCode: 'UNKNOWN_ERROR',
        userMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Create company with rollback capability
  Future<CompanyCreationResult> _createCompanyWithRollback({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
    required String userId,
  }) async {
    String? companyId;
    String? roleId;

    try {
      // Step 1: Create the company
      final companyResponse = await _supabase
          .from('companies')
          .insert({
            'company_name': companyName,
            'company_type_id': companyTypeId,
            'owner_id': userId,
            'base_currency_id': baseCurrencyId,
          })
          .select('company_id, company_code, company_name')
          .single();

      companyId = companyResponse['company_id'];
      final companyCode = companyResponse['company_code'];

      // Step 2: Add user to company
      await _supabase
          .from('user_companies')
          .insert({
            'user_id': userId,
            'company_id': companyId!,
          });

      // Step 3: Create or get owner role
      final existingRoles = await _supabase
          .from('roles')
          .select('role_id')
          .eq('company_id', companyId!)
          .eq('role_name', 'Owner')
          .maybeSingle();

      if (existingRoles == null) {
        // Create owner role
        final roleResponse = await _supabase
            .from('roles')
            .insert({
              'role_name': 'Owner',
              'role_type': 'owner',
              'company_id': companyId!,
              'description': 'Company owner with full permissions',
              'is_deletable': false,
            })
            .select('role_id')
            .single();
        
        roleId = roleResponse['role_id'];

        // Step 4: Assign permissions to role
        final featuresResponse = await _supabase
            .from('features')
            .select('feature_id');

        if (featuresResponse.isNotEmpty) {
          final permissions = (featuresResponse as List).map((feature) => {
            'role_id': roleId,
            'feature_id': feature['feature_id'],
            'can_access': true,
          }).toList();

          await _supabase
              .from('role_permissions')
              .insert(permissions);
        }
      } else {
        roleId = existingRoles['role_id'];
      }

      // Step 5: Assign role to user
      await _supabase
          .from('user_roles')
          .insert({
            'user_id': userId,
            'role_id': roleId,
          });

      // Step 6: Add company currency
      await _supabase
          .from('company_currency')
          .insert({
            'company_id': companyId!,
            'currency_id': baseCurrencyId,
          });

      return CompanyCreationResult.success(
        companyId: companyId!,
        companyName: companyName,
        companyCode: companyCode,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      );

    } catch (e) {
      // Rollback: Clean up created company if something fails
      if (companyId != null) {
        try {
          await _supabase
              .from('companies')
              .delete()
              .eq('company_id', companyId!);
        } catch (rollbackError) {
          // Log rollback error but don't throw
        }
      }

      rethrow;
    }
  }

  /// Map Supabase errors to user-friendly messages
  String _mapPostgrestError(PostgrestException e) {
    switch (e.code) {
      case '23505': // Unique constraint violation
        if (e.message.contains('company_name')) {
          return 'A business with this name already exists';
        }
        return 'This information is already in use';
      case '23503': // Foreign key constraint violation
        return 'Invalid reference data. Please refresh and try again';
      case '23514': // Check constraint violation
        return 'Invalid data format. Please check your input';
      case 'PGRST116': // No rows returned
        return 'Required information not found';
      default:
        return 'A database error occurred. Please try again';
    }
  }

  /// Map join error codes to user messages
  String _mapJoinErrorCode(String errorCode, String errorMessage) {
    switch (errorCode) {
      case 'NOT_FOUND':
        return 'Business code not found. Please verify with your manager';
      case 'ALREADY_MEMBER':
        return 'You are already a member of this business';
      case 'OWNER_CANNOT_JOIN':
        return 'You cannot join your own business as an employee';
      case 'INVALID_FORMAT':
      case 'INVALID_INPUT':
        return 'Invalid business code format. Please check and try again';
      case 'MAX_MEMBERS_REACHED':
        return 'This business has reached its member limit';
      case 'BUSINESS_INACTIVE':
        return 'This business is no longer active';
      default:
        return errorMessage.isNotEmpty 
            ? errorMessage 
            : 'Unable to join business. Please try again';
    }
  }

  final _supabase = Supabase.instance.client;
}

/// Result class for company creation operations
class CompanyCreationResult {
  final bool isSuccess;
  final String? companyId;
  final String? companyName;
  final String? companyCode;
  final String? companyTypeId;
  final String? baseCurrencyId;
  final String? error;
  final String? errorCode;
  final String? userMessage;

  const CompanyCreationResult._({
    required this.isSuccess,
    this.companyId,
    this.companyName,
    this.companyCode,
    this.companyTypeId,
    this.baseCurrencyId,
    this.error,
    this.errorCode,
    this.userMessage,
  });

  factory CompanyCreationResult.success({
    required String companyId,
    required String companyName,
    required String? companyCode,
    required String companyTypeId,
    required String baseCurrencyId,
  }) {
    return CompanyCreationResult._(
      isSuccess: true,
      companyId: companyId,
      companyName: companyName,
      companyCode: companyCode,
      companyTypeId: companyTypeId,
      baseCurrencyId: baseCurrencyId,
    );
  }

  factory CompanyCreationResult.failure({
    required String error,
    required String errorCode,
    required String userMessage,
  }) {
    return CompanyCreationResult._(
      isSuccess: false,
      error: error,
      errorCode: errorCode,
      userMessage: userMessage,
    );
  }
}

/// Result class for company join operations
class CompanyJoinResult {
  final bool isSuccess;
  final String? companyId;
  final String? companyName;
  final String? businessType;
  final String? roleAssigned;
  final DateTime? joinedAt;
  final String? error;
  final String? errorCode;
  final String? userMessage;

  const CompanyJoinResult._({
    required this.isSuccess,
    this.companyId,
    this.companyName,
    this.businessType,
    this.roleAssigned,
    this.joinedAt,
    this.error,
    this.errorCode,
    this.userMessage,
  });

  factory CompanyJoinResult.success({
    required String companyId,
    required String companyName,
    required String? businessType,
    required String? roleAssigned,
    required DateTime joinedAt,
  }) {
    return CompanyJoinResult._(
      isSuccess: true,
      companyId: companyId,
      companyName: companyName,
      businessType: businessType,
      roleAssigned: roleAssigned,
      joinedAt: joinedAt,
    );
  }

  factory CompanyJoinResult.failure({
    required String error,
    required String errorCode,
    required String userMessage,
  }) {
    return CompanyJoinResult._(
      isSuccess: false,
      error: error,
      errorCode: errorCode,
      userMessage: userMessage,
    );
  }
}