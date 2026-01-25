/**
 * ExchangeRateModel
 * DTO and Mapper for ExchangeRate entity
 */

import { ExchangeRate } from '../../domain/entities/ExchangeRate';

export interface ExchangeRateDTO {
  currency_id: string;
  currency_code: string;
  currency_name: string;
  symbol: string;
  rate: number;
}

export class ExchangeRateModel {
  /**
   * Convert DTO to Domain Entity
   */
  static toDomain(dto: ExchangeRateDTO): ExchangeRate {
    return ExchangeRate.create({
      currencyId: dto.currency_id,
      currencyCode: dto.currency_code,
      currencyName: dto.currency_name,
      symbol: dto.symbol,
      rate: dto.rate,
    });
  }

  /**
   * Convert Domain Entity to DTO
   */
  static fromDomain(exchangeRate: ExchangeRate): ExchangeRateDTO {
    return {
      currency_id: exchangeRate.currencyId,
      currency_code: exchangeRate.currencyCode,
      currency_name: exchangeRate.currencyName,
      symbol: exchangeRate.symbol,
      rate: exchangeRate.rate,
    };
  }

  /**
   * Convert array of DTOs to Domain Entities
   */
  static toDomainList(dtos: ExchangeRateDTO[]): ExchangeRate[] {
    return dtos.map((dto) => ExchangeRateModel.toDomain(dto));
  }

  /**
   * Filter out base currency (rate === 1) and convert to Domain
   */
  static filterAndConvertForeignCurrencies(dtos: ExchangeRateDTO[]): ExchangeRate[] {
    return dtos
      .filter((dto) => dto.rate !== 1)
      .map((dto) => ExchangeRateModel.toDomain(dto));
  }
}
