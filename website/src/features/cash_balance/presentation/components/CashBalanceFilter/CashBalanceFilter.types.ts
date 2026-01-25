/**
 * CashBalanceFilter Types
 */

export interface Store {
  store_id: string;
  store_name: string;
}

export interface CashBalanceFilterProps {
  stores: Store[];
  onSearch: (filters: FilterValues) => void;
  onClear: () => void;
}

export interface FilterValues {
  storeId: string | null;
  startDate: string;
  endDate: string;
  locationTypes: string[];
}
