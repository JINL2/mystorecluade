import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'store_service.dart';

// Enhanced store service provider with better error handling
final enhancedStoreServiceProvider = Provider<EnhancedStoreService>((ref) {
  return EnhancedStoreService();
});

/// Enhanced store service with comprehensive error handling and result types
class EnhancedStoreService extends StoreService {
  /// Create a store with comprehensive error handling
  @override
  Future<StoreCreationResult> createStoreEnhanced({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return StoreCreationResult.failure(
          error: 'Authentication required',
          errorCode: 'AUTH_REQUIRED',
          userMessage: 'Please log in to create a store',
        );
      }

      // Validate inputs
      final validation = _validateStoreInputs(
        storeName: storeName,
        companyId: companyId,
        storeAddress: storeAddress,
        storePhone: storePhone,
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
      );

      if (!validation.isValid) {
        return StoreCreationResult.failure(
          error: validation.error!,
          errorCode: validation.errorCode!,
          userMessage: validation.userMessage!,
        );
      }

      // Verify user has permission to create stores for this company
      final hasPermission = await _verifyStoreCreationPermission(userId, companyId);
      if (!hasPermission.isValid) {
        return StoreCreationResult.failure(
          error: hasPermission.error!,
          errorCode: hasPermission.errorCode!,
          userMessage: hasPermission.userMessage!,
        );
      }

      // Check for duplicate store name within company
      final duplicateCheck = await _checkDuplicateStoreName(storeName, companyId);
      if (!duplicateCheck.isValid) {
        return StoreCreationResult.failure(
          error: duplicateCheck.error!,
          errorCode: duplicateCheck.errorCode!,
          userMessage: duplicateCheck.userMessage!,
        );
      }

      // Create the store with rollback capability
      final result = await _createStoreWithRollback(
        storeName: storeName.trim(),
        companyId: companyId,
        storeAddress: storeAddress?.trim(),
        storePhone: storePhone?.trim(),
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
        userId: userId,
      );

      return result;

    } on PostgrestException catch (e) {
      return StoreCreationResult.failure(
        error: 'Database error: ${e.message}',
        errorCode: e.code ?? 'DATABASE_ERROR',
        userMessage: _mapPostgrestError(e),
      );
    } catch (e) {
      return StoreCreationResult.failure(
        error: e.toString(),
        errorCode: 'UNKNOWN_ERROR',
        userMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Validate store creation inputs
  ValidationResult _validateStoreInputs({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) {
    // Validate store name
    if (storeName.trim().isEmpty) {
      return ValidationResult.invalid(
        error: 'Store name is required',
        errorCode: 'INVALID_NAME',
        userMessage: 'Please enter a valid store name',
      );
    }

    if (storeName.trim().length < 2) {
      return ValidationResult.invalid(
        error: 'Store name too short',
        errorCode: 'NAME_TOO_SHORT',
        userMessage: 'Store name must be at least 2 characters',
      );
    }

    if (storeName.trim().length > 100) {
      return ValidationResult.invalid(
        error: 'Store name too long',
        errorCode: 'NAME_TOO_LONG',
        userMessage: 'Store name must be less than 100 characters',
      );
    }

    // Validate company ID
    if (companyId.trim().isEmpty) {
      return ValidationResult.invalid(
        error: 'Company ID is required',
        errorCode: 'INVALID_COMPANY_ID',
        userMessage: 'Invalid company selected',
      );
    }

    // Validate store address (if provided)
    if (storeAddress != null && storeAddress.trim().isNotEmpty) {
      if (storeAddress.trim().length < 5) {
        return ValidationResult.invalid(
          error: 'Store address too short',
          errorCode: 'ADDRESS_TOO_SHORT',
          userMessage: 'Store address must be at least 5 characters',
        );
      }

      if (storeAddress.trim().length > 500) {
        return ValidationResult.invalid(
          error: 'Store address too long',
          errorCode: 'ADDRESS_TOO_LONG',
          userMessage: 'Store address must be less than 500 characters',
        );
      }
    }

    // Validate store phone (if provided)
    if (storePhone != null && storePhone.trim().isNotEmpty) {
      final phoneRegex = RegExp(r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$');
      if (!phoneRegex.hasMatch(storePhone.trim())) {
        return ValidationResult.invalid(
          error: 'Invalid phone number format',
          errorCode: 'INVALID_PHONE',
          userMessage: 'Please enter a valid phone number',
        );
      }
    }

    // Validate operational settings
    if (huddleTime != null && (huddleTime <= 0 || huddleTime > 1440)) {
      return ValidationResult.invalid(
        error: 'Invalid huddle time',
        errorCode: 'INVALID_HUDDLE_TIME',
        userMessage: 'Huddle time must be between 1 and 1440 minutes',
      );
    }

    if (paymentTime != null && (paymentTime <= 0 || paymentTime > 1440)) {
      return ValidationResult.invalid(
        error: 'Invalid payment time',
        errorCode: 'INVALID_PAYMENT_TIME',
        userMessage: 'Payment time must be between 1 and 1440 minutes',
      );
    }

    if (allowedDistance != null && (allowedDistance <= 0 || allowedDistance > 10000)) {
      return ValidationResult.invalid(
        error: 'Invalid allowed distance',
        errorCode: 'INVALID_ALLOWED_DISTANCE',
        userMessage: 'Allowed distance must be between 1 and 10000 meters',
      );
    }

    return ValidationResult.valid();
  }

  /// Verify user has permission to create stores for the company
  Future<ValidationResult> _verifyStoreCreationPermission(String userId, String companyId) async {
    try {
      // Check if user is company owner
      final companyOwner = await _supabase
          .from('companies')
          .select('owner_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (companyOwner == null) {
        return ValidationResult.invalid(
          error: 'Company not found',
          errorCode: 'COMPANY_NOT_FOUND',
          userMessage: 'Selected company no longer exists',
        );
      }

      if (companyOwner['owner_id'] == userId) {
        return ValidationResult.valid();
      }

      // Check if user has store creation permissions through roles
      final userPermissions = await _supabase
          .rpc('check_user_feature_permission', params: {
        'p_user_id': userId,
        'p_company_id': companyId,
        'p_feature_name': 'store_management',
      });

      if (userPermissions != true) {
        return ValidationResult.invalid(
          error: 'Insufficient permissions',
          errorCode: 'INSUFFICIENT_PERMISSIONS',
          userMessage: 'You do not have permission to create stores for this company',
        );
      }

      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.invalid(
        error: 'Permission check failed',
        errorCode: 'PERMISSION_CHECK_FAILED',
        userMessage: 'Unable to verify permissions. Please try again.',
      );
    }
  }

  /// Check for duplicate store names within the company
  Future<ValidationResult> _checkDuplicateStoreName(String storeName, String companyId) async {
    try {
      final existingStores = await _supabase
          .from('stores')
          .select('store_id')
          .eq('company_id', companyId)
          .ilike('store_name', storeName.trim())
          .eq('is_deleted', false);

      if (existingStores.isNotEmpty) {
        return ValidationResult.invalid(
          error: 'Duplicate store name',
          errorCode: 'DUPLICATE_STORE_NAME',
          userMessage: 'A store with this name already exists in your company',
        );
      }

      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.invalid(
        error: 'Duplicate check failed',
        errorCode: 'DUPLICATE_CHECK_FAILED',
        userMessage: 'Unable to verify store name. Please try again.',
      );
    }
  }

  /// Create store with rollback capability
  Future<StoreCreationResult> _createStoreWithRollback({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
    required String userId,
  }) async {
    String? storeId;

    try {
      // Prepare store data
      final storeData = <String, dynamic>{
        'store_name': storeName,
        'company_id': companyId,
      };

      if (storeAddress != null && storeAddress.isNotEmpty) {
        storeData['store_address'] = storeAddress;
      }
      if (storePhone != null && storePhone.isNotEmpty) {
        storeData['store_phone'] = storePhone;
      }
      if (huddleTime != null) {
        storeData['huddle_time'] = huddleTime;
      }
      if (paymentTime != null) {
        storeData['payment_time'] = paymentTime;
      }
      if (allowedDistance != null) {
        storeData['allowed_distance'] = allowedDistance;
      }

      // Create the store
      final storeResponse = await _supabase
          .from('stores')
          .insert(storeData)
          .select('store_id, store_code, store_name, company_id')
          .single();

      storeId = storeResponse['store_id'];
      final storeCode = storeResponse['store_code'];

      // The database trigger should automatically create user_stores entry
      // But let's verify it exists, and create if not
      final userStoreExists = await _supabase
          .from('user_stores')
          .select('user_store_id')
          .eq('user_id', userId)
          .eq('store_id', storeId!)
          .eq('is_deleted', false)
          .maybeSingle();

      if (userStoreExists == null) {
        // Create user_stores entry manually
        await _supabase
            .from('user_stores')
            .insert({
              'user_id': userId,
              'store_id': storeId!,
            });
      }

      return StoreCreationResult.success(
        storeId: storeId!,
        storeName: storeName,
        storeCode: storeCode,
        companyId: companyId,
        storeAddress: storeAddress,
        storePhone: storePhone,
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
      );

    } catch (e) {
      // Rollback: Clean up created store if something fails
      if (storeId != null) {
        try {
          await _supabase
              .from('stores')
              .delete()
              .eq('store_id', storeId!);
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
        if (e.message.contains('store_name')) {
          return 'A store with this name already exists in your company';
        }
        return 'This information is already in use';
      case '23503': // Foreign key constraint violation
        if (e.message.contains('company_id')) {
          return 'Selected company no longer exists';
        }
        return 'Invalid reference data. Please refresh and try again';
      case '23514': // Check constraint violation
        return 'Invalid data format. Please check your input';
      case 'PGRST116': // No rows returned
        return 'Required information not found';
      default:
        return 'A database error occurred. Please try again';
    }
  }

  final _supabase = Supabase.instance.client;
}

/// Validation result helper class
class ValidationResult {
  final bool isValid;
  final String? error;
  final String? errorCode;
  final String? userMessage;

  const ValidationResult._({
    required this.isValid,
    this.error,
    this.errorCode,
    this.userMessage,
  });

  factory ValidationResult.valid() {
    return const ValidationResult._(isValid: true);
  }

  factory ValidationResult.invalid({
    required String error,
    required String errorCode,
    required String userMessage,
  }) {
    return ValidationResult._(
      isValid: false,
      error: error,
      errorCode: errorCode,
      userMessage: userMessage,
    );
  }
}

/// Result class for store creation operations
class StoreCreationResult {
  final bool isSuccess;
  final String? storeId;
  final String? storeName;
  final String? storeCode;
  final String? companyId;
  final String? storeAddress;
  final String? storePhone;
  final int? huddleTime;
  final int? paymentTime;
  final int? allowedDistance;
  final String? error;
  final String? errorCode;
  final String? userMessage;

  const StoreCreationResult._({
    required this.isSuccess,
    this.storeId,
    this.storeName,
    this.storeCode,
    this.companyId,
    this.storeAddress,
    this.storePhone,
    this.huddleTime,
    this.paymentTime,
    this.allowedDistance,
    this.error,
    this.errorCode,
    this.userMessage,
  });

  factory StoreCreationResult.success({
    required String storeId,
    required String storeName,
    required String? storeCode,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) {
    return StoreCreationResult._(
      isSuccess: true,
      storeId: storeId,
      storeName: storeName,
      storeCode: storeCode,
      companyId: companyId,
      storeAddress: storeAddress,
      storePhone: storePhone,
      huddleTime: huddleTime,
      paymentTime: paymentTime,
      allowedDistance: allowedDistance,
    );
  }

  factory StoreCreationResult.failure({
    required String error,
    required String errorCode,
    required String userMessage,
  }) {
    return StoreCreationResult._(
      isSuccess: false,
      error: error,
      errorCode: errorCode,
      userMessage: userMessage,
    );
  }
}