/**
 * IncomeStatementFilter Component Types
 */

export interface IncomeStatementFilters {
  store: string | null;
  type: 'monthly' | '12month';
  fromDate: string;
  toDate: string;
}

export interface IncomeStatementFilterProps {
  onSearch: (filters: IncomeStatementFilters) => void;
  onClear?: () => void;
  onFilterChange?: (filters: IncomeStatementFilters) => void;
  className?: string;
}

export interface Store {
  store_id: string;
  store_name: string;
}
