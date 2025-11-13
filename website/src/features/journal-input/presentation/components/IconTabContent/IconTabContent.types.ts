/**
 * IconTabContent Component Types
 */

import type { JournalEntry } from '../../../domain/entities/JournalEntry';
import type {
  Account,
  CashLocation,
  Counterparty,
} from '../../../domain/repositories/IJournalInputRepository';

export interface IconTabContentProps {
  journalEntry: JournalEntry;
  accounts: Account[];
  cashLocations: CashLocation[];
  counterparties: Counterparty[];
  companyId: string;
  selectedStoreId: string | null;
  submitting: boolean;
  onAddTransaction: () => void;
  onEditTransaction: (index: number) => void;
  onDeleteTransaction: (index: number) => void;
  onSubmit: () => void;
}
