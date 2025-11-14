/**
 * CurrencyModel - DTO and Mapper
 * Handles conversion between database schema and domain entities
 */

import { Currency } from '../../domain/entities/Currency';

/**
 * DTO - Data Transfer Object
 * Represents the shape of data after database mapping
 */
export interface CurrencyDTO {
  currencyId: string;
  companyId: string;
  code: string;
  symbol: string;
  name: string;
  isDefault: boolean;
  exchangeRate: number;
}

/**
 * CurrencyModel - Mapper class
 * Converts between database raw data and domain entities
 */
export class CurrencyModel {
  /**
   * Convert raw database data to DTO
   * Handles snake_case to camelCase conversion
   */
  static fromDatabase(data: any): CurrencyDTO {
    return {
      currencyId: data.currency_id,
      companyId: data.company_id,
      code: data.code || data.currency_code,
      symbol: data.symbol || '',
      name: data.name || data.currency_name || '',
      isDefault: data.is_default || false,
      exchangeRate: data.exchange_rate || 1.0,
    };
  }

  /**
   * Convert DTO to Domain Entity
   */
  static toEntity(dto: CurrencyDTO): Currency {
    return new Currency(
      dto.currencyId,
      dto.companyId,
      dto.code,
      dto.symbol,
      dto.name,
      dto.isDefault,
      dto.exchangeRate
    );
  }

  /**
   * Convert raw database data directly to Domain Entity
   * Convenience method that combines fromDatabase and toEntity
   */
  static fromDatabaseToEntity(data: any): Currency {
    const dto = this.fromDatabase(data);
    return this.toEntity(dto);
  }

  /**
   * Convert Domain Entity to database format
   * Used for updates and inserts
   */
  static toDatabase(currency: Currency): any {
    return {
      currency_id: currency.currencyId,
      company_id: currency.companyId,
      code: currency.code,
      symbol: currency.symbol,
      name: currency.name,
      is_default: currency.isDefault,
      exchange_rate: currency.exchangeRate,
    };
  }
}
