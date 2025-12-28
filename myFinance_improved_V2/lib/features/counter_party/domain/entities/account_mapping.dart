import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_mapping.freezed.dart';

/// Account Mapping Entity (Pure Domain - No JSON)
///
/// Maps accounts between internal companies for automatic debt synchronization.
/// When company A records a receivable, company B automatically records a payable.
@freezed
class AccountMapping with _$AccountMapping {
  const AccountMapping._();

  const factory AccountMapping({
    required String mappingId,
    required String myCompanyId,
    required String myAccountId,
    required String counterpartyId,
    required String linkedAccountId,
    required String direction,
    String? createdBy,
    DateTime? createdAt,
    String? linkedCompanyId,
    String? myAccountName,
    String? linkedAccountName,
    String? linkedCompanyName,
    String? myAccountType,
    String? linkedAccountType,
  }) = _AccountMapping;
}

/// Helper extension for AccountMapping
extension AccountMappingX on AccountMapping {
  /// Get human-readable description of the mapping
  String get mappingDescription {
    final myAccount = myAccountName ?? 'Unknown Account';
    final linkedAccount = linkedAccountName ?? 'Unknown Account';
    final linkedCompany = linkedCompanyName ?? 'Unknown Company';

    return "When I record '$myAccount', $linkedCompany records '$linkedAccount'";
  }

  /// Check if mapping is bidirectional
  bool get isBidirectional => direction == 'bidirectional';
}
