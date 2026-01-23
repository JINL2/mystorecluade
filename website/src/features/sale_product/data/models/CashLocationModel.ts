/**
 * CashLocationModel
 * DTO and Mapper for CashLocation entity
 * Updated for get_cash_locations_v2 RPC response
 */

import { CashLocation, CashLocationType } from '../../domain/entities/CashLocation';

/**
 * DTO matching get_cash_locations_v2 RPC response
 */
export interface CashLocationDTO {
  cash_location_id: string;
  location_name: string;
  location_type: CashLocationType;
  store_id: string | null;
  store_name: string | null;
  company_id: string;
  is_company_wide: boolean;
  currency_code: string | null;
  currency_id: string | null;
  bank_account: string | null;
  bank_name: string | null;
  location_info: string | null;
  icon: string | null;
  note: string | null;
  main_cash_location: boolean;
  created_at: string;
  created_at_utc: string | null;
}

export class CashLocationModel {
  /**
   * Convert DTO to Domain Entity
   */
  static toDomain(dto: CashLocationDTO): CashLocation {
    return CashLocation.create({
      id: dto.cash_location_id,
      name: dto.location_name,
      type: dto.location_type,
      storeId: dto.store_id,
      isCompanyWide: dto.is_company_wide,
      currencyCode: dto.currency_code,
      bankAccount: dto.bank_account,
      bankName: dto.bank_name,
    });
  }

  /**
   * Convert Domain Entity to DTO
   */
  static fromDomain(cashLocation: CashLocation): Partial<CashLocationDTO> {
    return {
      cash_location_id: cashLocation.id,
      location_name: cashLocation.name,
      location_type: cashLocation.type,
      store_id: cashLocation.storeId,
      is_company_wide: cashLocation.isCompanyWide,
      currency_code: cashLocation.currencyCode,
      bank_account: cashLocation.bankAccount,
      bank_name: cashLocation.bankName,
    };
  }

  /**
   * Convert array of DTOs to Domain Entities
   */
  static toDomainList(dtos: CashLocationDTO[]): CashLocation[] {
    return dtos.map((dto) => CashLocationModel.toDomain(dto));
  }

  /**
   * Convert to Domain (v2 doesn't return deleted items)
   */
  static filterAndConvertActive(dtos: CashLocationDTO[]): CashLocation[] {
    return dtos.map((dto) => CashLocationModel.toDomain(dto));
  }
}
