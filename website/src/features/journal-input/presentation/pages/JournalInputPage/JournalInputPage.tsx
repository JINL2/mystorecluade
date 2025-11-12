/**
 * JournalInputPage Component
 * Journal entry input page with transaction lines management
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useJournalInput } from '../../hooks/useJournalInput';
import { useAuth } from '@/shared/hooks/useAuth';
import { useAppState } from '@/app/providers/app_state_provider';
import { TossButton } from '@/shared/components/toss/TossButton';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { TransactionForm } from '../../components/TransactionForm';
import type { TransactionFormData } from '../../components/TransactionForm';
import type { JournalInputPageProps } from './JournalInputPage.types';
import { TransactionLine } from '../../../domain/entities/TransactionLine';
import {
  formatCurrency,
  formatJournalDate,
  formatCategoryTag,
} from '@/core/utils/formatters';
import styles from './JournalInputPage.module.css';

export const JournalInputPage: React.FC<JournalInputPageProps> = () => {
  const { user } = useAuth();
  const { currentCompany, currentStore } = useAppState();

  const companyId = currentCompany?.company_id || '';
  const stores = currentCompany?.stores || [];
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(currentStore?.store_id || null);

  const {
    journalEntry,
    accounts,
    cashLocations,
    counterparties,
    loading,
    submitting,
    addTransactionLine,
    updateTransactionLine,
    removeTransactionLine,
    submitJournalEntry,
    resetJournalEntry,
  } = useJournalInput(companyId, selectedStoreId, user?.id || '');

  const [isTransactionModalOpen, setIsTransactionModalOpen] = useState(false);
  const [modalTransactionType, setModalTransactionType] = useState<'debit' | 'credit'>('debit');
  const [editingIndex, setEditingIndex] = useState<number | null>(null);

  // Error message states
  const [showValidationError, setShowValidationError] = useState(false);
  const [showSuccessMessage, setShowSuccessMessage] = useState(false);
  const [showErrorMessage, setShowErrorMessage] = useState(false);
  const [errorMessageText, setErrorMessageText] = useState('');

  const handleStoreSelect = (storeId: string | null) => {
    setSelectedStoreId(storeId);
    resetJournalEntry(storeId);
  };

  // Show loading if no company selected yet
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="finance" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Journal Input</h1>
            <p className={styles.subtitle}>Please select a company first</p>
          </div>
        </div>
      </>
    );
  }

  // Auto-select transaction type based on balance (lower side gets selected)
  const getAutoTransactionType = (): 'debit' | 'credit' => {
    return journalEntry.totalDebits <= journalEntry.totalCredits ? 'debit' : 'credit';
  };

  const handleAddDebit = () => {
    setEditingIndex(null);
    setModalTransactionType(getAutoTransactionType());
    setIsTransactionModalOpen(true);
  };

  const handleAddCredit = () => {
    setEditingIndex(null);
    setModalTransactionType(getAutoTransactionType());
    setIsTransactionModalOpen(true);
  };

  const handleAddTransaction = () => {
    setEditingIndex(null);
    setModalTransactionType(getAutoTransactionType());
    setIsTransactionModalOpen(true);
  };

  const handleTransactionSubmit = (data: TransactionFormData) => {
    // Find cash location details if cashLocationId is provided
    const cashLocation = data.cashLocationId
      ? cashLocations.find(loc => loc.locationId === data.cashLocationId)
      : null;

    // Find counterparty details if counterpartyId is provided
    const counterparty = data.counterpartyId
      ? counterparties.find(cp => cp.counterpartyId === data.counterpartyId)
      : null;

    // Create TransactionLine instance
    const transactionLine = new TransactionLine(
      data.isDebit,
      data.accountId,
      data.accountName,
      data.amount,
      data.description || '',
      data.categoryTag || null,
      data.cashLocationId || null,
      cashLocation?.locationName || null,
      cashLocation?.locationType || null,
      data.counterpartyId || null,
      counterparty?.counterpartyName || null,
      null, // counterpartyStoreId - not used in this context
      null, // counterpartyStoreName - not used in this context
      null  // debtCategory - not used in this context
    );

    // If editing, update the line; otherwise, add new line
    if (editingIndex !== null) {
      updateTransactionLine(editingIndex, transactionLine);
    } else {
      addTransactionLine(transactionLine);
    }

    setIsTransactionModalOpen(false);
    setEditingIndex(null);
  };

  const handleTransactionCancel = () => {
    setIsTransactionModalOpen(false);
    setEditingIndex(null);
  };

  const handleEditTransaction = (index: number) => {
    setEditingIndex(index);
    const line = journalEntry.transactionLines[index];
    setModalTransactionType(line.isDebit ? 'debit' : 'credit');
    setIsTransactionModalOpen(true);
  };

  const handleDeleteTransaction = (index: number) => {
    removeTransactionLine(index);
  };

  const handleSubmit = () => {
    if (!journalEntry.canSubmit()) {
      setShowValidationError(true);
      return;
    }

    // Directly submit without confirmation dialog
    handleConfirmSubmit();
  };

  const handleConfirmSubmit = async () => {
    const result = await submitJournalEntry();
    if (result.success) {
      setShowSuccessMessage(true);
    } else {
      setErrorMessageText(result.error || 'Failed to submit journal entry');
      setShowErrorMessage(true);
    }
  };

  // Get submit button text based on state
  const getSubmitButtonText = () => {
    if (journalEntry.transactionLines.length === 0) return 'Add transactions to submit';
    if (!journalEntry.isBalanced) return 'Balance debits and credits';
    return 'Submit Journal Entry';
  };

  if (loading) {
    return (
      <>
        <Navbar activeItem="finance" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Journal Input</h1>
          </div>
          <LoadingAnimation fullscreen />
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="finance" />
      <div className={styles.container}>
        {/* Page Header */}
        <div className={styles.header}>
          <h1 className={styles.title}>Journal Entry</h1>
          <p className={styles.subtitle}>Create balanced financial transactions</p>
        </div>

        {/* Journal Header with Date and Company Info */}
        <div className={styles.journalHeaderCard}>
          <div className={styles.journalDateInfo}>
            <svg className={styles.journalDateIcon} viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,3H18V1H16V3H8V1H6V3H5A2,2 0 0,0 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5A2,2 0 0,0 19,3M19,19H5V8H19V19Z"/>
            </svg>
            <span className={styles.journalDateText}>{formatJournalDate(journalEntry.date)}</span>
          </div>
          <div className={styles.journalCompanyInfo}>
            <svg className={styles.journalCompanyIcon} viewBox="0 0 24 24" fill="currentColor">
              <path d="M12,7V3H2V21H22V7H12M6,19H4V17H6V19M6,15H4V13H6V15M6,11H4V9H6V11M6,7H4V5H6V7M10,19H8V17H10V19M10,15H8V13H10V15M10,11H8V9H10V11M10,7H8V5H10V7M20,19H18V17H20V19M20,15H18V13H20V15M20,11H18V9H20V11M16,19H14V17H16V19M16,15H14V13H16V15M16,11H14V9H16V11"/>
            </svg>
            <span className={styles.journalCompanyText}>{currentCompany?.company_name || 'Company'}</span>
          </div>
        </div>

        {/* Store Selector */}
        <div className={styles.storeSelectorCard}>
          <StoreSelector
            stores={stores}
            selectedStoreId={selectedStoreId}
            onStoreSelect={handleStoreSelect}
            companyId={companyId}
            showAllStoresOption={true}
            allStoresLabel="All Stores"
            width="100%"
          />
        </div>

        {/* Balance Summary */}
        <div className={styles.balanceSummaryCard}>
          <div className={styles.balanceSummaryGrid}>
            <div className={`${styles.balanceItem} ${styles.clickable}`} onClick={handleAddDebit}>
              <div className={styles.balanceLabel}>Debits</div>
              <div className={`${styles.balanceAmount} ${styles.debit}`}>
                {formatCurrency(journalEntry.totalDebits)}
              </div>
              <div className={styles.balanceCount}>{journalEntry.debitCount} items</div>
            </div>
            <div className={styles.balanceDivider}></div>
            <div className={`${styles.balanceItem} ${styles.clickable}`} onClick={handleAddCredit}>
              <div className={styles.balanceLabel}>Credits</div>
              <div className={`${styles.balanceAmount} ${styles.credit}`}>
                {formatCurrency(journalEntry.totalCredits)}
              </div>
              <div className={styles.balanceCount}>{journalEntry.creditCount} items</div>
            </div>
            <div className={styles.balanceDivider}></div>
            <div className={styles.balanceItem}>
              <div className={styles.balanceLabel}>Difference</div>
              <div
                className={`${styles.balanceAmount} ${styles.difference} ${
                  !journalEntry.isBalanced ? styles.unbalanced : ''
                }`}
              >
                {formatCurrency(Math.abs(journalEntry.difference))}
              </div>
              <div className={styles.balanceCount}>&nbsp;</div>
            </div>
          </div>
        </div>

        {/* Description Input */}
        <div className={styles.descriptionCard}>
          <label className={styles.descriptionLabel} htmlFor="journalDescription">
            Description (Optional)
          </label>
          <textarea
            id="journalDescription"
            className={styles.descriptionTextarea}
            rows={2}
            placeholder="Enter journal description..."
          />
        </div>

        {/* Transaction Lines */}
        <div className={styles.transactionSection}>
          {journalEntry.transactionLines.length === 0 ? (
            <div className={styles.emptyState}>
              <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
                {/* Background Circle */}
                <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

                {/* Document Stack */}
                <rect x="35" y="40" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
                <rect x="40" y="35" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>

                {/* Document Lines */}
                <line x1="48" y1="45" x2="75" y2="45" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
                <line x1="48" y1="52" x2="70" y2="52" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
                <line x1="48" y1="59" x2="72" y2="59" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

                {/* Plus Symbol */}
                <circle cx="60" cy="75" r="12" fill="#0064FF"/>
                <path d="M56 75 H64 M60 71 V79" stroke="white" strokeWidth="2.5" strokeLinecap="round"/>
              </svg>
              <h3 className={styles.emptyTitle}>No transactions added</h3>
              <p className={styles.emptyText}>Click Debits or Credits above to add transactions</p>
            </div>
          ) : (
            <>
              {journalEntry.transactionLines.map((line, index) => (
                <div key={index} className={styles.transactionLineCard}>
                  <div
                    className={`${styles.transactionLineHeader} ${
                      line.isDebit ? styles.debit : styles.credit
                    }`}
                  >
                    <div
                      className={`${styles.transactionLineType} ${
                        line.isDebit ? styles.debit : styles.credit
                      }`}
                    >
                      {line.typeDisplay}
                    </div>
                    <div className={styles.transactionLineAccount}>
                      {line.accountName || 'No Account Selected'}
                    </div>
                    <div
                      className={`${styles.transactionLineAmount} ${
                        line.isDebit ? styles.debit : styles.credit
                      }`}
                    >
                      {formatCurrency(line.amount)}
                    </div>
                  </div>
                  <div className={styles.transactionLineBody}>
                    {line.description && (
                      <div className={styles.transactionLineDescription}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M14,10H19.5L14,4.5V10M5,3H15L21,9V19A2,2 0 0,1 19,21H5C3.89,21 3,20.1 3,19V5C3,3.89 3.89,3 5,3M9,12H16V14H9V12M9,16H14V18H9V16Z" />
                        </svg>
                        <span>{line.description}</span>
                      </div>
                    )}
                    <div className={styles.transactionLineTags}>
                      {line.categoryTag && (
                        <div className={`${styles.transactionTag} ${styles.category}`}>
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M17.63,5.84C17.27,5.33 16.67,5 16,5L5,5.01C3.9,5.01 3,5.9 3,7V17C3,18.1 3.9,19 5,19H16C16.67,19 17.27,18.67 17.63,18.16L22,12L17.63,5.84Z" />
                          </svg>
                          {formatCategoryTag(line.categoryTag)}
                        </div>
                      )}
                      {line.cashLocationName && (
                        <div className={`${styles.transactionTag} ${styles.cash}`}>
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M11,8C11,9.66 9.66,11 8,11C6.34,11 5,9.66 5,8C5,6.34 6.34,5 8,5C9.66,5 11,6.34 11,8M14,20H2V18C2,15.79 4.69,14 8,14C11.31,14 14,15.79 14,18V20M22,8V18H24V8H22M18,10V16H20V10H18M16,13V16H17V13H16Z" />
                          </svg>
                          {line.cashLocationName}
                        </div>
                      )}
                      {line.counterpartyName && (
                        <div className={`${styles.transactionTag} ${styles.counterparty}`}>
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4M12,6A6,6 0 0,0 6,12A6,6 0 0,0 12,18A6,6 0 0,0 18,12A6,6 0 0,0 12,6Z" />
                          </svg>
                          {line.counterpartyName}
                        </div>
                      )}
                    </div>
                    <div className={styles.transactionLineActions}>
                      <button
                        className={`${styles.transactionActionBtn} ${styles.edit}`}
                        onClick={() => handleEditTransaction(index)}
                      >
                        <svg className={styles.actionIcon} viewBox="0 0 24 24" fill="currentColor">
                          <path d="M20.71,7.04C21.1,6.65 21.1,6 20.71,5.63L18.37,3.29C18,2.9 17.35,2.9 16.96,3.29L15.12,5.12L18.87,8.87M3,17.25V21H6.75L17.81,9.93L14.06,6.18L3,17.25Z" />
                        </svg>
                        Edit
                      </button>
                      <button
                        className={`${styles.transactionActionBtn} ${styles.delete}`}
                        onClick={() => handleDeleteTransaction(index)}
                      >
                        <svg className={styles.actionIcon} viewBox="0 0 24 24" fill="currentColor">
                          <path d="M19,4H15.5L14.5,3H9.5L8.5,4H5V6H19M6,19A2,2 0 0,0 8,21H16A2,2 0 0,0 18,19V7H6V19Z" />
                        </svg>
                        Delete
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </>
          )}

          {/* Actions Footer */}
          <div className={styles.actionsFooter}>
            <TossButton
              variant="outline"
              size="lg"
              onClick={handleAddTransaction}
              className={styles.addTransactionBtn}
            >
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style={{ marginRight: '8px' }}>
                <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
              </svg>
              Add Transaction
            </TossButton>
            <TossButton
              variant="primary"
              size="lg"
              onClick={handleSubmit}
              disabled={!journalEntry.canSubmit()}
              loading={submitting}
              className={styles.submitBtn}
            >
              {getSubmitButtonText()}
            </TossButton>
          </div>
        </div>
      </div>

      {/* Transaction Modal */}
      {isTransactionModalOpen && (() => {
        // Get initial data for edit mode
        const isEditMode = editingIndex !== null;
        const editingLine = isEditMode ? journalEntry.transactionLines[editingIndex] : null;
        const initialData = editingLine ? {
          accountId: editingLine.accountId,
          accountName: editingLine.accountName,
          categoryTag: editingLine.categoryTag || undefined,
          amount: editingLine.amount,
          description: editingLine.description || undefined,
          isDebit: editingLine.isDebit,
          cashLocationId: editingLine.cashLocationId || undefined,
          counterpartyId: editingLine.counterpartyId || undefined,
        } : undefined;

        // Get the cash location ID that should be hidden from dropdown
        // If editing a line that has cash location, allow it to remain selectable
        // Otherwise, hide the cash location that's already used in other transactions
        const disabledCashLocationId = isEditMode
          ? (editingLine?.cashLocationId ? null : journalEntry.getCashLocationId())
          : journalEntry.getCashLocationId();

        return (
          <div className={styles.modalOverlay} onClick={handleTransactionCancel}>
            <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
              <div className={styles.modalHeader}>
                <h2 className={styles.modalTitle}>{isEditMode ? 'Edit Transaction' : 'Add Transaction'}</h2>
                <button className={styles.modalClose} onClick={handleTransactionCancel}>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                  </svg>
                </button>
              </div>
              <div className={styles.modalBody}>
                <TransactionForm
                  isDebit={modalTransactionType === 'debit'}
                  onSubmit={handleTransactionSubmit}
                  onCancel={handleTransactionCancel}
                  accounts={accounts}
                  cashLocations={cashLocations}
                  counterparties={counterparties}
                  companyId={companyId}
                  storeId={selectedStoreId}
                  suggestedAmount={Math.abs(journalEntry.difference)}
                  initialData={initialData}
                  isEditMode={isEditMode}
                  disabledCashLocationId={disabledCashLocationId}
                />
              </div>
              <div className={styles.modalFooter}>
                <TossButton variant="outline" size="lg" onClick={handleTransactionCancel}>
                  Cancel
                </TossButton>
                <TossButton
                  variant="primary"
                  size="lg"
                  onClick={() => {
                    // Submit form by triggering the hidden submit button
                    const form = document.querySelector('form');
                    if (form) {
                      const submitBtn = form.querySelector('button[type="submit"]') as HTMLButtonElement;
                      submitBtn?.click();
                    }
                  }}
                >
                  {isEditMode ? 'Update' : 'Add'}
                </TossButton>
              </div>
            </div>
          </div>
        );
      })()}

      {/* Validation Error Message */}
      <ErrorMessage
        variant="warning"
        isOpen={showValidationError}
        onClose={() => setShowValidationError(false)}
        message="Journal entry must be balanced with at least 2 transaction lines"
        zIndex={10000}
      />

      {/* Success Message */}
      <ErrorMessage
        variant="success"
        isOpen={showSuccessMessage}
        onClose={() => setShowSuccessMessage(false)}
        message="Journal entry submitted successfully!"
        zIndex={10000}
        autoCloseDuration={2000}
      />

      {/* Error Message */}
      <ErrorMessage
        variant="error"
        isOpen={showErrorMessage}
        onClose={() => setShowErrorMessage(false)}
        message={errorMessageText}
        zIndex={10000}
      />
    </>
  );
};

export default JournalInputPage;
