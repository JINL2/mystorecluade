/**
 * Currency Entity
 * Represents a currency with denominations and exchange rate
 */

export interface Denomination {
  denomination_id: string;
  value: number;
  type: 'bill' | 'coin';
}

export interface CurrencyWithExchangeRate {
  currency_id: string;
  company_currency_id: string;
  currency_code: string;
  currency_name: string;
  symbol: string;
  flag_emoji: string;
  is_base_currency: boolean;
  exchange_rate_to_base: number;
  denominations: Denomination[];
  created_at: string;
}

export class CurrencyEntity {
  constructor(
    public readonly currencyId: string,
    public readonly companyCurrencyId: string,
    public readonly currencyCode: string,
    public readonly currencyName: string,
    public readonly symbol: string,
    public readonly flagEmoji: string,
    public readonly isBaseCurrency: boolean,
    public readonly exchangeRateToBase: number,
    public readonly denominations: Denomination[],
    public readonly createdAt: string
  ) {}

  calculateSubtotal(quantities: Record<string, number>): number {
    return this.denominations.reduce((total, denom) => {
      const qty = quantities[denom.denomination_id] || 0;
      return total + denom.value * qty;
    }, 0);
  }

  convertToBase(amount: number): number {
    return amount * this.exchangeRateToBase;
  }
}
