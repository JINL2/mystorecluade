export class Currency {
  constructor(
    public readonly currencyId: string,
    public readonly companyId: string,
    public readonly code: string,
    public readonly symbol: string,
    public readonly name: string,
    public readonly isDefault: boolean
  ) {}
  get displayName(): string { return `${this.code} (${this.symbol}) - ${this.name}`; }
}
