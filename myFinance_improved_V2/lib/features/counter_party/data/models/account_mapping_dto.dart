import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/account_mapping.dart';

part 'account_mapping_dto.freezed.dart';
part 'account_mapping_dto.g.dart';

/// Account Mapping DTO for JSON serialization
@freezed
class AccountMappingDto with _$AccountMappingDto {
  const AccountMappingDto._();

  const factory AccountMappingDto({
    @JsonKey(name: 'mapping_id') required String mappingId,
    @JsonKey(name: 'my_company_id') required String myCompanyId,
    @JsonKey(name: 'my_account_id') required String myAccountId,
    @JsonKey(name: 'counterparty_id') required String counterpartyId,
    @JsonKey(name: 'linked_account_id') required String linkedAccountId,
    required String direction,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
    @JsonKey(name: 'my_account_name') String? myAccountName,
    @JsonKey(name: 'linked_account_name') String? linkedAccountName,
    @JsonKey(name: 'linked_company_name') String? linkedCompanyName,
    @JsonKey(name: 'my_account_type') String? myAccountType,
    @JsonKey(name: 'linked_account_type') String? linkedAccountType,
  }) = _AccountMappingDto;

  factory AccountMappingDto.fromJson(Map<String, dynamic> json) =>
      _$AccountMappingDtoFromJson(json);

  /// Convert to Domain Entity
  AccountMapping toEntity() => AccountMapping(
    mappingId: mappingId,
    myCompanyId: myCompanyId,
    myAccountId: myAccountId,
    counterpartyId: counterpartyId,
    linkedAccountId: linkedAccountId,
    direction: direction,
    createdBy: createdBy,
    createdAt: createdAt,
    linkedCompanyId: linkedCompanyId,
    myAccountName: myAccountName,
    linkedAccountName: linkedAccountName,
    linkedCompanyName: linkedCompanyName,
    myAccountType: myAccountType,
    linkedAccountType: linkedAccountType,
  );

  /// Create DTO from Entity
  factory AccountMappingDto.fromEntity(AccountMapping entity) => AccountMappingDto(
    mappingId: entity.mappingId,
    myCompanyId: entity.myCompanyId,
    myAccountId: entity.myAccountId,
    counterpartyId: entity.counterpartyId,
    linkedAccountId: entity.linkedAccountId,
    direction: entity.direction,
    createdBy: entity.createdBy,
    createdAt: entity.createdAt,
    linkedCompanyId: entity.linkedCompanyId,
    myAccountName: entity.myAccountName,
    linkedAccountName: entity.linkedAccountName,
    linkedCompanyName: entity.linkedCompanyName,
    myAccountType: entity.myAccountType,
    linkedAccountType: entity.linkedAccountType,
  );
}
