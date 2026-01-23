/**
 * ExchangeRate Entity
 * Domain entity representing a currency exchange rate
 */

export class ExchangeRate {
  constructor(
    public readonly currencyId: string,
    public readonly currencyCode: string,
    public readonly currencyName: string,
    public readonly symbol: string,
    public readonly rate: number
  ) {}

  convertAmount(amount: number): number {
    return amount / this.rate;
  }

  formatConvertedAmount(amount: number, options?: Intl.NumberFormatOptions): string {
    const converted = this.convertAmount(amount);
    return converted.toLocaleString(undefined, {
      minimumFractionDigits: 0,
      maximumFractionDigits: 2,
      ...options,
    });
  }

  formatRate(baseCurrencySymbol: string): string {
    return `1 ${this.currencyCode} = ${this.rate.toLocaleString()} ${baseCurrencySymbol}`;
  }

  static create(data: {
    currencyId: string;
    currencyCode: string;
    currencyName: string;
    symbol: string;
    rate: number;
  }): ExchangeRate {
    return new ExchangeRate(
      data.currencyId,
      data.currencyCode,
      data.currencyName,
      data.symbol,
      data.rate
    );
  }
}
