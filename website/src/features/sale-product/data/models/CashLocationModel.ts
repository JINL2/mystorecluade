/**
 * CashLocationModel
 * DTO and Mapper for CashLocation entity
 */

import { CashLocation, CashLocationType } from '../../domain/entities/CashLocation';

export interface CashLocationDTO {
  id: string;
  name: string;
  type: CashLocationType;
  storeId: string | null;
  isCompanyWide: boolean;
  isDeleted: boolean;
  currencyCode: string | null;
  bankAccount: string | null;
  bankName: string | null;
  locationInfo: string;
  transactionCount: number;
}

export class CashLocationModel {
  /**
   * Convert DTO to Domain Entity
   */
  static toDomain(dto: CashLocationDTO): CashLocation {
    return CashLocation.create({
      id: dto.id,
      name: dto.name,
      type: dto.type,
      storeId: dto.storeId,
      isCompanyWide: dto.isCompanyWide,
      currencyCode: dto.currencyCode,
      bankAccount: dto.bankAccount,
      bankName: dto.bankName,
    });
  }

  /**
   * Convert Domain Entity to DTO
   */
  static fromDomain(cashLocation: CashLocation): Partial<CashLocationDTO> {
    return {
      id: cashLocation.id,
      name: cashLocation.name,
      type: cashLocation.type,
      storeId: cashLocation.storeId,
      isCompanyWide: cashLocation.isCompanyWide,
      currencyCode: cashLocation.currencyCode,
      bankAccount: cashLocation.bankAccount,
      bankName: cashLocation.bankName,
    };
  }

  /**
   * Convert array of DTOs to Domain Entities
   */
  static toDomainList(dtos: CashLocationDTO[]): CashLocation[] {
    return dtos.map((dto) => CashLocationModel.toDomain(dto));
  }

  /**
   * Filter out deleted locations and convert to Domain
   */
  static filterAndConvertActive(dtos: CashLocationDTO[]): CashLocation[] {
    return dtos
      .filter((dto) => !dto.isDeleted)
      .map((dto) => CashLocationModel.toDomain(dto));
  }
}
