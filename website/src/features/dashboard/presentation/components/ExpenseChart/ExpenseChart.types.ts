/**
 * ExpenseChart Types
 */

export interface ExpenseBreakdownItem {
  category: string;
  amount: number;
  percentage: number;
}

export interface ExpenseChartProps {
  data: ExpenseBreakdownItem[];
  formatCurrency: (amount: number) => string;
}
