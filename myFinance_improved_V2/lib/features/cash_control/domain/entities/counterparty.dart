import 'package:freezed_annotation/freezed_annotation.dart';

part 'counterparty.freezed.dart';

/// Domain entity representing a counterparty (vendor, customer, etc.)
///
/// Maps to `counterparties` table
/// DB columns: counterparty_id, name, type, is_internal, linked_company_id
@freezed
class Counterparty with _$Counterparty {
  const factory Counterparty({
    required String counterpartyId,
    required String name,
    String? type,
    @Default(false) bool isInternal,
    String? linkedCompanyId,
  }) = _Counterparty;

  const Counterparty._();

  /// Check if this is an internal counterparty (linked company)
  bool get hasLinkedCompany => linkedCompanyId != null;

  /// Check if this is "My Company" type
  bool get isMyCompany => type == 'My Company';

  /// Check if this is "Team Member" type
  bool get isTeamMember => type == 'Team Member';
}
