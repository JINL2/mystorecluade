/**
 * RecentTransactionHistory Component Types
 */

import type { Store } from '@/shared/components/selectors/StoreSelector/StoreSelector.types';

export interface RecentTransactionHistoryProps {
  companyId: string;
  stores: Store[];
  refreshTrigger?: number;
}
