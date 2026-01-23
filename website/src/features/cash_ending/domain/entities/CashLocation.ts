/**
 * CashLocation Entity
 * Represents a cash location (cash register, bank, vault)
 */

export type LocationType = 'cash' | 'bank' | 'vault';

export interface CashLocation {
  cash_location_id: string;
  location_name: string;
  location_type: LocationType;
  store_id: string | null;
  store_name: string | null;
  company_id: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export class CashLocationEntity {
  constructor(
    public readonly cashLocationId: string,
    public readonly locationName: string,
    public readonly locationType: LocationType,
    public readonly storeId: string | null,
    public readonly storeName: string | null,
    public readonly companyId: string,
    public readonly isActive: boolean,
    public readonly createdAt: string,
    public readonly updatedAt: string
  ) {}

  get isCash(): boolean {
    return this.locationType === 'cash';
  }

  get isBank(): boolean {
    return this.locationType === 'bank';
  }

  get isVault(): boolean {
    return this.locationType === 'vault';
  }
}
