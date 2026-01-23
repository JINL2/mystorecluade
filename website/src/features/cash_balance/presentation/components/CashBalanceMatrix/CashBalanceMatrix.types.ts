/**
 * CashBalanceMatrix Types
 */

import type { CashLocation, CashBalanceEntry } from '../../pages/CashBalancePage/CashBalancePage.types';

export interface CashBalanceMatrixProps {
  locations: CashLocation[];
  entries: CashBalanceEntry[];
  dates: string[];
  formatCurrency: (amount: number, currencyCode: string) => string;
}
