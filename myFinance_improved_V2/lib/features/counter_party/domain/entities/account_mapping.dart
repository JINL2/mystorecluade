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
