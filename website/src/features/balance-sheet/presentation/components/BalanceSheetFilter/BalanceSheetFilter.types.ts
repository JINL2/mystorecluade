/**
 * BalanceSheetFilter Component Types
 */

export interface BalanceSheetFilterProps {
  onSearch: (filters: FilterValues) => void;
  onClear: () => void;
}

export interface FilterValues {
  storeId: string | null;
  startDate: string | null;
  endDate: string | null;
}
