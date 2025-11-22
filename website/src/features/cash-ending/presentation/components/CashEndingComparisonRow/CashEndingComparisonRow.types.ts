/**
 * CashEndingComparisonRow Component Types
 */

export interface CashEndingComparisonRowProps {
  cashEndingId: string;
  locationName: string;
  expectedBalance: number;
  actualBalance: number;
  status: 'pending' | 'completed';
  formatCurrency: (amount: number) => string;
}
