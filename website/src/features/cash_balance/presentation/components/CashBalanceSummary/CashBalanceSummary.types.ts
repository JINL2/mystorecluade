/**
 * CashBalanceSummary Types
 */

import type { CashLocation } from '../../pages/CashBalancePage/CashBalancePage.types';

export interface CashBalanceSummaryProps {
  locations: CashLocation[];
  formatCurrency: (amount: number, currencyCode: string) => string;
}
