// lib/features/auth/data/models/freezed/company_dto_mapper.dart

import '../../../domain/entities/company_entity.dart';
import 'company_dto.dart';

/// CompanyDto Mapper
///
/// Converts between CompanyDto (Data Layer) and Company Entity (Domain Layer).
extension CompanyDtoMapper on CompanyDto {
  /// Convert DTO to Domain Entity
  Company toEntity() {
    return Company(
      id: companyId,
      name: companyName,
      companyTypeId: companyTypeId,
      currencyId: baseCurrencyId,
      companyCode: companyCode,
      ownerId: ownerId,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }
}

/// Company Entity to DTO extension
extension CompanyEntityMapper on Company {
  /// Convert Entity to DTO
  CompanyDto toDto() {
    return CompanyDto(
      companyId: id,
      companyName: name,
      companyCode: companyCode,
      companyTypeId: companyTypeId,
      ownerId: ownerId,
      baseCurrencyId: currencyId,
      createdAt: createdAt.toIso8601String(),
      updatedAt: updatedAt?.toIso8601String(),
    );
  }

  /// Convert Entity to insert map (without ID for DB auto-generation)
  Map<String, dynamic> toInsertMap() {
    final map = <String, dynamic>{
      'company_name': name,
      'company_type_id': companyTypeId,
      'owner_id': ownerId,
      'base_currency_id': currencyId,
    };

    // Only include optional fields if not empty
    if (companyCode != null && companyCode!.isNotEmpty) {
      map['company_code'] = companyCode;
    }

    return map;
  }
}
