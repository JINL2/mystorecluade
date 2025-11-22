/**
 * CashLocation Entity
 * Domain entity representing a cash/bank/vault location
 */

export type CashLocationType = 'cash' | 'bank' | 'vault';

export class CashLocation {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly type: CashLocationType,
    public readonly storeId: string | null,
    public readonly isCompanyWide: boolean,
    public readonly currencyCode: string | null,
    public readonly bankAccount: string | null,
    public readonly bankName: string | null
  ) {}

  get displayName(): string {
    return this.name;
  }

  get typeLabel(): string {
    return this.type;
  }

  isAvailableForStore(storeId: string): boolean {
    return this.isCompanyWide || this.storeId === storeId;
  }

  static create(data: {
    id: string;
    name: string;
    type: CashLocationType;
    storeId: string | null;
    isCompanyWide: boolean;
    currencyCode: string | null;
    bankAccount: string | null;
    bankName: string | null;
  }): CashLocation {
    return new CashLocation(
      data.id,
      data.name,
      data.type,
      data.storeId,
      data.isCompanyWide,
      data.currencyCode,
      data.bankAccount,
      data.bankName
    );
  }
}
