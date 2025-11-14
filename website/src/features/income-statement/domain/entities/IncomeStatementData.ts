/**
 * IncomeStatementData Entity
 * Represents income statement (P&L) financial data
 */

// Account in a subcategory
export interface IncomeStatementAccount {
  account_name: string;
  net_amount: number;
  monthly_amounts?: { [month: string]: number };  // For 12-month view
  total?: number;  // For 12-month view
}

// Subcategory with accounts
export interface IncomeStatementSubcategory {
  subcategory: string;
  subcategory_total: number;
  subcategory_monthly_totals?: { [month: string]: number };  // For 12-month view
  accounts: IncomeStatementAccount[];
}

// Section with subcategories
export interface IncomeStatementSection {
  section: string;
  section_total: number | string;  // Can be string for percentage values
  section_monthly_totals?: { [month: string]: number };  // For 12-month view
  subcategories?: IncomeStatementSubcategory[];
}

// Monthly view data (array of sections)
export type MonthlyIncomeStatementData = IncomeStatementSection[];

// 12-month view data
export interface TwelveMonthIncomeStatementData {
  summary: {
    period_info: {
      start_date: string;
      end_date: string;
      store_scope: 'all_stores' | 'single_store';
      store_name?: string;  // Optional: Only present when store_scope is 'single_store'
    };
  };
  months: string[];  // ["2025-01", "2025-02", ...]
  sections: IncomeStatementSection[];
}

// Combined type for both views
export type IncomeStatementData = MonthlyIncomeStatementData | TwelveMonthIncomeStatementData;
