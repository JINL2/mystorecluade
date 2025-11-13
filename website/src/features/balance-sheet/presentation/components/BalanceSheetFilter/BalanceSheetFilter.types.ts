/**
 * BalanceSheetFilter Component Types
 */

export interface Store {
  store_id: string;
  store_name: string;
}

export interface BalanceSheetFilterProps {
  stores?: Store[];
  companyId?: string;
  onSearch: (filters: FilterValues) => void;
  onClear: () => void;
}

export interface FilterValues {
  storeId: string | null;
  startDate: string | null;
  endDate: string | null;
}
