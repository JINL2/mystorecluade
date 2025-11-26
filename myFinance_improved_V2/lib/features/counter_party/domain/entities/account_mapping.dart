import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_mapping.freezed.dart';
part 'account_mapping.g.dart';

/// Account Mapping Entity
///
/// Maps accounts between internal companies for automatic debt synchronization.
/// When company A records a receivable, company B automatically records a payable.
@freezed
class AccountMapping with _$AccountMapping {
  const factory AccountMapping({
    @JsonKey(name: 'mapping_id') required String mappingId,
    @JsonKey(name: 'my_company_id') required String myCompanyId,
    @JsonKey(name: 'my_account_id') required String myAccountId,
    @JsonKey(name: 'counterparty_id') required String counterpartyId,
    @JsonKey(name: 'linked_account_id') required String linkedAccountId,
    required String direction, // 'bidirectional' by default
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,

    // From counterparties table via join
    @JsonKey(name: 'linked_company_id') String? linkedCompanyId,

    // Display fields (for UI) from RPC joins
    @JsonKey(name: 'my_account_name') String? myAccountName,
    @JsonKey(name: 'linked_account_name') String? linkedAccountName,
    @JsonKey(name: 'linked_company_name') String? linkedCompanyName,
    @JsonKey(name: 'my_account_type') String? myAccountType,
    @JsonKey(name: 'linked_account_type') String? linkedAccountType,
  }) = _AccountMapping;

  factory AccountMapping.fromJson(Map<String, dynamic> json) =>
      _$AccountMappingFromJson(json);
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
