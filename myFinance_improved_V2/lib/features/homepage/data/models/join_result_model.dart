import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';

/// Data model for JoinResult
/// Handles JSON serialization from Supabase RPC response
class JoinResultModel extends JoinResult {
  const JoinResultModel({
    required super.success,
    super.companyId,
    super.companyName,
    super.storeId,
    super.storeName,
    super.roleAssigned,
  });

  /// Create model from JSON response from join_user_by_code RPC
  ///
  /// Expected JSON structure:
  /// ```json
  /// {
  ///   "success": true,
  ///   "company_id": "uuid",
  ///   "company_name": "Company Name",
  ///   "store_id": "uuid",  // Optional, only if joined a store
  ///   "store_name": "Store Name",  // Optional
  ///   "role_assigned": "Member"  // Or "Employee" for store
  /// }
  /// ```
  factory JoinResultModel.fromJson(Map<String, dynamic> json) {
    return JoinResultModel(
      success: json['success'] as bool? ?? false,
      companyId: json['company_id'] as String?,
      companyName: json['company_name'] as String? ?? json['entity_name'] as String?,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      roleAssigned: json['role_assigned'] as String?,
    );
  }

  /// Convert model to domain entity
  JoinResult toEntity() {
    return JoinResult(
      success: success,
      companyId: companyId,
      companyName: companyName,
      storeId: storeId,
      storeName: storeName,
      roleAssigned: roleAssigned,
    );
  }

  /// Create a test/mock model
  factory JoinResultModel.mock({
    bool success = true,
    String? companyId,
    String? companyName,
    String? storeId,
    String? storeName,
    String? roleAssigned,
  }) {
    return JoinResultModel(
      success: success,
      companyId: companyId ?? 'mock-company-id',
      companyName: companyName ?? 'Mock Company',
      storeId: storeId,
      storeName: storeName,
      roleAssigned: roleAssigned ?? 'Member',
    );
  }
}
