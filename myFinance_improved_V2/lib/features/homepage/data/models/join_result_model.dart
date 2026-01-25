import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/join_result.dart';

part 'join_result_model.freezed.dart';
part 'join_result_model.g.dart';

/// Data model for JoinResult
/// Handles JSON serialization from Supabase RPC response
///
/// RPC returns:
/// - success: bool
/// - type: 'joined_company' | 'joined_store' | 'already_joined' | 'invalid_code'
/// - message: string (on error)
/// - company_id, company_name, store_id, store_name
/// - role_assigned: bool (true if role was assigned)
@freezed
class JoinResultModel with _$JoinResultModel {
  const JoinResultModel._();

  const factory JoinResultModel({
    @Default(false) bool success,
    String? type,
    String? message,
    @JsonKey(name: 'error_code') String? errorCode,
    @JsonKey(name: 'company_id') String? companyId,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'role_assigned') @Default(false) bool roleAssignedFlag,
    // Employee limit fields
    @JsonKey(name: 'max_employees') int? maxEmployees,
    @JsonKey(name: 'current_employees') int? currentEmployees,
  }) = _JoinResultModel;

  factory JoinResultModel.fromJson(Map<String, dynamic> json) =>
      _$JoinResultModelFromJson(json);

  JoinResult toEntity() {
    return JoinResult(
      success: success,
      companyId: companyId,
      companyName: companyName,
      storeId: storeId,
      storeName: storeName,
      roleAssigned: roleAssignedFlag ? 'Employee' : null,
    );
  }

  /// Error message for failed joins
  String get errorMessage => message ?? 'Failed to join. Please try again.';

  /// Check if this is an "already joined" error
  bool get isAlreadyJoined =>
      type == 'already_joined' || errorCode == 'ALREADY_MEMBER';

  /// Check if this is an invalid code error
  bool get isInvalidCode =>
      type == 'invalid_code' || errorCode == 'BUSINESS_NOT_FOUND';

  /// Check if employee limit reached
  bool get isEmployeeLimitReached =>
      type == 'employee_limit_reached' || errorCode == 'EMPLOYEE_LIMIT_REACHED';

  /// Check if owner trying to join
  bool get isOwnerCannotJoin => errorCode == 'OWNER_CANNOT_JOIN';
}
