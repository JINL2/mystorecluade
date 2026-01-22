/**
 * BalanceSummary Entity
 * Represents the balance summary for a cash location
 */

export interface BalanceSummaryData {
  success: boolean;
  location_id: string;
  location_name: string;
  location_type: string;
  total_journal: number;
  total_real: number;
  difference: number;
  is_balanced: boolean;
  has_shortage: boolean;
  has_surplus: boolean;
  currency_symbol: string;
  currency_code: string;
  last_updated: string;
  error?: string;
}

export class BalanceSummaryEntity {
  constructor(
    public readonly success: boolean,
    public readonly locationId: string,
    public readonly locationName: string,
    public readonly locationType: string,
    public readonly totalJournal: number,
    public readonly totalReal: number,
    public readonly difference: number,
    public readonly isBalanced: boolean,
    public readonly hasShortage: boolean,
    public readonly hasSurplus: boolean,
    public readonly currencySymbol: string,
    public readonly currencyCode: string,
    public readonly lastUpdated: string,
    public readonly error?: string
  ) {}

  get differencePercent(): number {
    if (this.totalJournal === 0) return 0;
    return (this.difference / this.totalJournal) * 100;
  }

  get needsAdjustment(): boolean {
    return this.difference !== 0;
  }
}
