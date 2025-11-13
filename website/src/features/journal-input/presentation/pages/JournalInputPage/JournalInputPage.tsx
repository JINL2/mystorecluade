/**
 * JournalInputPage Component
 * Journal entry input page with transaction lines management
 * Refactored: Modal logic separated into TransactionModal component
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useJournalInput } from '../../hooks/useJournalInput';
import { useAuth } from '@/shared/hooks/useAuth';
import { useAppState } from '@/app/providers/app_state_provider';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import type { TransactionFormData } from '../../components/TransactionForm';
import type { JournalInputPageProps } from './JournalInputPage.types';
import { TransactionLine } from '../../../domain/entities/TransactionLine';
import { IconTabContent } from '../../components/IconTabContent';
import { ExcelTabContent } from '../../components/ExcelTabContent';
import { TransactionModal } from '../../components/TransactionModal';
import { formatJournalDate } from '@/core/utils/formatters';
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
    checkAccountMapping,
    getCounterpartyStores,
    getCounterpartyCashLocations,
  } = useJournalInput(companyId, selectedStoreId, user?.id || '');

  const [isTransactionModalOpen, setIsTransactionModalOpen] = useState(false);
  const [modalTransactionType, setModalTransactionType] = useState<'debit' | 'credit'>('debit');
  const [editingIndex, setEditingIndex] = useState<number | null>(null);

  // Tab state - Excel is default
  const [activeTab, setActiveTab] = useState<'icon' | 'excel'>('excel');

  // Form validation state from TransactionForm
  const [isFormValid, setIsFormValid] = useState(false);

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

  const handleAddTransaction = () => {
    setEditingIndex(null);
    setIsFormValid(false);
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

    // Create TransactionLine instance with new debt fields for p_lines alignment
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
      data.counterpartyStoreId || null,
      null, // counterpartyStoreName - will be resolved in backend
      data.debtCategory || null,
      // New debt fields from form
      data.interestRate || null,
      data.interestAccountId || null,
      data.interestDueDay || null,
      data.issueDate || null,
      data.dueDate || null,
      data.debtDescription || null,
      counterparty?.linkedCompanyId || null, // linkedCompanyId from counterparty
      data.counterpartyCashLocationId || null // counterparty's cash location for mirror journal
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
    setIsFormValid(false);
  };

  const handleEditTransaction = (index: number) => {
    setEditingIndex(index);
    setIsFormValid(false);
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
            showAllStoresOption={false}
            width="100%"
          />
        </div>

        {/* Input Method Tabs */}
        <div className={styles.tabsContainer}>
          <div className={`${styles.tabsWrapper} ${activeTab === 'icon' ? styles.iconActive : ''}`}>
            <button
              className={`${styles.tab} ${activeTab === 'excel' ? styles.active : ''}`}
              onClick={() => setActiveTab('excel')}
            >
              <svg className={styles.tabIcon} viewBox="0 0 24 24" fill="currentColor">
                <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20M12.9,14.5L15.8,19H14L12,15.6L10,19H8.2L11.1,14.5L8.2,10H10L12,13.4L14,10H15.8L12.9,14.5Z"/>
              </svg>
              Excel
            </button>
            <button
              className={`${styles.tab} ${activeTab === 'icon' ? styles.active : ''}`}
              onClick={() => setActiveTab('icon')}
            >
              <svg className={styles.tabIcon} viewBox="0 0 24 24" fill="currentColor">
                <path d="M13,9H18.5L13,3.5V9M6,2H14L20,8V20A2,2 0 0,1 18,22H6C4.89,22 4,21.1 4,20V4C4,2.89 4.89,2 6,2M15,18V16H6V18H15M18,14V12H6V14H18Z"/>
              </svg>
              Icon
            </button>
          </div>
        </div>

        {/* Tab Content */}
        {activeTab === 'icon' && (
          <IconTabContent
            journalEntry={journalEntry}
            accounts={accounts}
            cashLocations={cashLocations}
            counterparties={counterparties}
            companyId={companyId}
            selectedStoreId={selectedStoreId}
            submitting={submitting}
            onAddTransaction={handleAddTransaction}
            onEditTransaction={handleEditTransaction}
            onDeleteTransaction={handleDeleteTransaction}
            onSubmit={handleSubmit}
          />
        )}

        {/* Excel Tab Content */}
        {activeTab === 'excel' && (
          <ExcelTabContent
            accounts={accounts}
            cashLocations={cashLocations}
            counterparties={counterparties}
            companyId={companyId}
            selectedStoreId={selectedStoreId}
            userId={user?.id || ''}
            onCheckAccountMapping={checkAccountMapping}
            onGetCounterpartyStores={getCounterpartyStores}
            onGetCounterpartyCashLocations={getCounterpartyCashLocations}
            onSubmitSuccess={() => setShowSuccessMessage(true)}
            onSubmitError={(error) => {
              setErrorMessageText(error);
              setShowErrorMessage(true);
            }}
          />
        )}
      </div>

      {/* Transaction Modal */}
      <TransactionModal
        isOpen={isTransactionModalOpen}
        isEditMode={editingIndex !== null}
        editingIndex={editingIndex}
        journalEntry={journalEntry}
        modalTransactionType={modalTransactionType}
        accounts={accounts}
        cashLocations={cashLocations}
        counterparties={counterparties}
        companyId={companyId}
        selectedStoreId={selectedStoreId}
        isFormValid={isFormValid}
        onSubmit={handleTransactionSubmit}
        onCancel={handleTransactionCancel}
        onCheckAccountMapping={checkAccountMapping}
        onGetCounterpartyStores={getCounterpartyStores}
        onGetCounterpartyCashLocations={getCounterpartyCashLocations}
        onValidationChange={setIsFormValid}
      />

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
