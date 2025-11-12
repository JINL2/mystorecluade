/**
 * CurrencyTypeModel - DTO and Mapper for currency types
 * Handles conversion for currency_types table data
 */

/**
 * DTO - Data Transfer Object
 * Represents currency type data from currency_types table
 */
export interface CurrencyTypeDTO {
  currencyId: string;
  code: string;
  symbol: string;
  name: string;
}

/**
 * CurrencyTypeModel - Mapper class
 * Converts between database raw data and DTO
 */
export class CurrencyTypeModel {
  /**
   * Convert raw database data to DTO
   * Handles snake_case to camelCase conversion
   */
  static fromDatabase(data: any): CurrencyTypeDTO {
    return {
      currencyId: data.currency_id,
      code: data.currency_code || data.code,
      symbol: data.symbol || '',
      name: data.currency_name || data.name || '',
    };
  }

  /**
   * Convert DTO to database format
   * Used for updates and inserts
   */
  static toDatabase(currencyType: CurrencyTypeDTO): any {
    return {
      currency_id: currencyType.currencyId,
      currency_code: currencyType.code,
      symbol: currencyType.symbol,
      currency_name: currencyType.name,
    };
  }
}
