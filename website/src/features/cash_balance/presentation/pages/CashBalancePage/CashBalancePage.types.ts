/**
 * CashBalancePage Types
 */

export interface CashBalancePageProps {
  // Props can be extended as needed
}

export interface CashLocation {
  locationId: string;
  locationName: string;
  locationType: 'cash' | 'vault' | 'bank' | 'digital_wallet';
  currencyCode: string;
  currentBalance: number;
  lastUpdated?: string;
}

export interface CashBalanceEntry {
  date: string;
  locationId: string;
  inAmount: number;
  outAmount: number;
}

export interface FilterState {
  startDate: Date;
  endDate: Date;
  selectedStoreId: string | null;
  selectedLocationTypes: string[];
  selectedCurrency: string | null;
}

export type ViewMode = 'matrix' | 'summary';
