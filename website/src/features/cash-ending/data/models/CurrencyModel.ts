/**
 * CurrencyModel
 * Handles JSON transformation between API and Domain Entity
 */

import { CurrencyEntity, type CurrencyWithExchangeRate } from '../../domain/entities/Currency';

export class CurrencyModel {
  /**
   * Convert API JSON response to Domain Entity
   */
  static fromJson(json: CurrencyWithExchangeRate): CurrencyEntity {
    return new CurrencyEntity(
      json.currency_id,
      json.company_currency_id,
      json.currency_code,
      json.currency_name,
      json.symbol,
      json.flag_emoji,
      json.is_base_currency,
      json.exchange_rate_to_base,
      json.denominations,
      json.created_at
    );
  }

  /**
   * Convert Domain Entity to API JSON format
   */
  static toJson(entity: CurrencyEntity): CurrencyWithExchangeRate {
    return {
      currency_id: entity.currencyId,
      company_currency_id: entity.companyCurrencyId,
      currency_code: entity.currencyCode,
      currency_name: entity.currencyName,
      symbol: entity.symbol,
      flag_emoji: entity.flagEmoji,
      is_base_currency: entity.isBaseCurrency,
      exchange_rate_to_base: entity.exchangeRateToBase,
      denominations: entity.denominations,
      created_at: entity.createdAt,
    };
  }
}
