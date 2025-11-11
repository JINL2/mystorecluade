export class Currency {
  constructor(
    public readonly currencyId: string,
    public readonly companyId: string,
    public readonly code: string,
    public readonly symbol: string,
    public readonly name: string,
    public readonly isDefault: boolean,
    public readonly exchangeRate?: number
  ) {}
  get displayName(): string { return `${this.code} (${this.symbol}) - ${this.name}`; }
}
