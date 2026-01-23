/**
 * BaseCurrency Entity
 * Domain entity for base currency RPC response
 */

// Currency info
export interface CurrencyInfo {
  currencyId: string;
  currencyCode: string;
  currencyName: string;
  symbol: string;
  flagEmoji: string;
}

// Denomination info
export interface DenominationInfo {
  denominationId: string;
  value: number;
}

// Company currency with exchange rate and denominations
export interface CompanyCurrency extends CurrencyInfo {
  exchangeRateToBase: number;
  rateDate: string | null;
  denominations: DenominationInfo[];
}

// Main response
export interface BaseCurrencyResponse {
  baseCurrency: CurrencyInfo;
  companyCurrencies: CompanyCurrency[];
}

// RPC response types
interface CurrencyInfoRpc {
  currency_id: string;
  currency_code: string;
  currency_name: string;
  symbol: string;
  flag_emoji: string;
}

interface DenominationInfoRpc {
  denomination_id: string;
  value: number;
}

interface CompanyCurrencyRpc extends CurrencyInfoRpc {
  exchange_rate_to_base: number;
  rate_date: string | null;
  denominations: DenominationInfoRpc[];
}

interface BaseCurrencyResponseRpc {
  base_currency: CurrencyInfoRpc;
  company_currencies: CompanyCurrencyRpc[];
}

/**
 * Map RPC response to domain entity
 */
export function mapBaseCurrencyFromRpc(data: unknown): BaseCurrencyResponse {
  const response = data as BaseCurrencyResponseRpc;

  return {
    baseCurrency: {
      currencyId: response.base_currency?.currency_id ?? '',
      currencyCode: response.base_currency?.currency_code ?? '',
      currencyName: response.base_currency?.currency_name ?? '',
      symbol: response.base_currency?.symbol ?? '',
      flagEmoji: response.base_currency?.flag_emoji ?? '',
    },
    companyCurrencies: (response.company_currencies ?? []).map((currency) => ({
      currencyId: currency.currency_id ?? '',
      currencyCode: currency.currency_code ?? '',
      currencyName: currency.currency_name ?? '',
      symbol: currency.symbol ?? '',
      flagEmoji: currency.flag_emoji ?? '',
      exchangeRateToBase: currency.exchange_rate_to_base ?? 1,
      rateDate: currency.rate_date ?? null,
      denominations: (currency.denominations ?? []).map((denom) => ({
        denominationId: denom.denomination_id ?? '',
        value: denom.value ?? 0,
      })),
    })),
  };
}
