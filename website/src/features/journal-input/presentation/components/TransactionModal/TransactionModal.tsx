/**
 * TransactionModal Component
 * Modal wrapper for TransactionForm
 * Separated from JournalInputPage for better maintainability
 */

import React from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { TransactionForm } from '../TransactionForm';
import type { TransactionFormData } from '../TransactionForm';
import type { Account, CashLocation, Counterparty } from '../../../domain/repositories/IJournalInputRepository';
import type { JournalEntry } from '../../../domain/entities/JournalEntry';
import styles from './TransactionModal.module.css';

export interface TransactionModalProps {
  isOpen: boolean;
  isEditMode: boolean;
  editingIndex: number | null;
  journalEntry: JournalEntry;
  modalTransactionType: 'debit' | 'credit';
  accounts: Account[];
  cashLocations: CashLocation[];
  counterparties: Counterparty[];
  companyId: string;
  selectedStoreId: string | null;
  isFormValid: boolean;
  onSubmit: (data: TransactionFormData) => void;
  onCancel: () => void;
  onCheckAccountMapping: (companyId: string, counterpartyId: string, accountId: string) => Promise<boolean>;
  onGetCounterpartyStores: (linkedCompanyId: string) => Promise<Array<{ storeId: string; storeName: string }>>;
  onGetCounterpartyCashLocations: (linkedCompanyId: string, storeId?: string | null) => Promise<CashLocation[]>;
  onValidationChange: (isValid: boolean) => void;
}

export const TransactionModal: React.FC<TransactionModalProps> = ({
  isOpen,
  isEditMode,
  editingIndex,
  journalEntry,
  modalTransactionType,
  accounts,
  cashLocations,
  counterparties,
  companyId,
  selectedStoreId,
  isFormValid,
  onSubmit,
  onCancel,
  onCheckAccountMapping,
  onGetCounterpartyStores,
  onGetCounterpartyCashLocations,
  onValidationChange,
}) => {
  if (!isOpen) return null;

  // Get initial data for edit mode
  const editingLine = isEditMode && editingIndex !== null ? journalEntry.transactionLines[editingIndex] : null;
  const initialData = editingLine ? {
    accountId: editingLine.accountId,
    accountName: editingLine.accountName,
    categoryTag: editingLine.categoryTag || undefined,
    amount: editingLine.amount,
    description: editingLine.description || undefined,
    isDebit: editingLine.isDebit,
    cashLocationId: editingLine.cashLocationId || undefined,
    counterpartyId: editingLine.counterpartyId || undefined,
    counterpartyStoreId: editingLine.counterpartyStoreId || undefined,
    counterpartyCashLocationId: editingLine.counterpartyCashLocationId || undefined,
    debtCategory: editingLine.debtCategory || undefined,
    interestRate: editingLine.interestRate || undefined,
    interestAccountId: editingLine.interestAccountId || undefined,
    interestDueDay: editingLine.interestDueDay || undefined,
    issueDate: editingLine.issueDate || undefined,
    dueDate: editingLine.dueDate || undefined,
    debtDescription: editingLine.debtDescription || undefined,
  } : undefined;

  // Get the cash location ID that should be hidden from dropdown
  const disabledCashLocationId = isEditMode
    ? (editingLine?.cashLocationId ? null : journalEntry.getCashLocationId())
    : journalEntry.getCashLocationId();

  // Handle form submit button click
  const handleFormSubmit = () => {
    const form = document.querySelector('form');
    if (form) {
      const submitBtn = form.querySelector('button[type="submit"]') as HTMLButtonElement;
      submitBtn?.click();
    }
  };

  return (
    <div className={styles.modalOverlay} onClick={onCancel}>
      <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
        <div className={styles.modalHeader}>
          <h2 className={styles.modalTitle}>{isEditMode ? 'Edit Transaction' : 'Add Transaction'}</h2>
          <button className={styles.modalClose} onClick={onCancel}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
            </svg>
          </button>
        </div>
        <div className={styles.modalBody}>
          <TransactionForm
            isDebit={modalTransactionType === 'debit'}
            onSubmit={onSubmit}
            onCancel={onCancel}
            accounts={accounts}
            cashLocations={cashLocations}
            counterparties={counterparties}
            companyId={companyId}
            storeId={selectedStoreId}
            suggestedAmount={Math.abs(journalEntry.difference)}
            initialData={initialData}
            isEditMode={isEditMode}
            disabledCashLocationId={disabledCashLocationId}
            onCheckAccountMapping={onCheckAccountMapping}
            onGetCounterpartyStores={onGetCounterpartyStores}
            onGetCounterpartyCashLocations={onGetCounterpartyCashLocations}
            onValidationChange={onValidationChange}
          />
        </div>
        <div className={styles.modalFooter}>
          <TossButton variant="outline" size="lg" onClick={onCancel}>
            Cancel
          </TossButton>
          <TossButton
            variant="primary"
            size="lg"
            disabled={!isFormValid}
            onClick={handleFormSubmit}
          >
            {isEditMode ? 'Update' : 'Add'}
          </TossButton>
        </div>
      </div>
    </div>
  );
};

export default TransactionModal;
