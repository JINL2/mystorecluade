import 'package:equatable/equatable.dart';

/// Join Result entity representing the outcome of joining by code
/// The code can be either a company code or store code
/// Server determines which type and returns appropriate IDs
class JoinResult extends Equatable {
  const JoinResult({
    required this.success,
    this.companyId,
    this.companyName,
    this.storeId,
    this.storeName,
    this.roleAssigned,
  });

  /// Whether the join operation was successful
  final bool success;

  /// Company ID if joined a company (or store's parent company)
  final String? companyId;

  /// Company name for display
  final String? companyName;

  /// Store ID if joined a store
  final String? storeId;

  /// Store name for display
  final String? storeName;

  /// Role assigned to the user (e.g., "Member", "Employee")
  final String? roleAssigned;

  /// Whether this was a company join (has companyId but no storeId)
  bool get isCompanyJoin => companyId != null && storeId == null;

  /// Whether this was a store join (has storeId)
  bool get isStoreJoin => storeId != null;

  /// Display name for the joined entity
  String get entityName => storeName ?? companyName ?? 'entity';

  @override
  List<Object?> get props => [
        success,
        companyId,
        companyName,
        storeId,
        storeName,
        roleAssigned,
      ];

  @override
  String toString() => 'JoinResult(success: $success, companyId: $companyId, '
      'storeId: $storeId, roleAssigned: $roleAssigned)';
}
