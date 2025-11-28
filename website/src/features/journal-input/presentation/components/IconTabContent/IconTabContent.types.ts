/**
 * IconTabContent Component Types
 */

import type { JournalEntry } from '../../../domain/entities/JournalEntry';
import type {
  Account,
  CashLocation,
  Counterparty,
} from '../../../domain/repositories/IJournalInputRepository';
import type { Store } from '@/shared/components/selectors/StoreSelector/StoreSelector.types';

export interface IconTabContentProps {
  journalEntry: JournalEntry;
  accounts: Account[];
  cashLocations: CashLocation[];
  counterparties: Counterparty[];
  companyId: string;
  stores: Store[];
  submitting: boolean;
  refreshTrigger?: number;
  onAddTransaction: () => void;
  onEditTransaction: (index: number) => void;
  onDeleteTransaction: (index: number) => void;
  onSubmit: () => void;
}
