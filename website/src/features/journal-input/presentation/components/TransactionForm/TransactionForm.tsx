/**
 * TransactionForm Component
 * Add/Edit transaction form matching backup HTML design
 * Refactored: Logic separated into custom hooks for better maintainability
 */

import React, { useEffect } from 'react';
import styles from './TransactionForm.module.css';
import type { TransactionFormProps, TransactionFormData } from './TransactionForm.types';
import { TossSelector } from '../../../../../shared/components/selectors/TossSelector/TossSelector';
import type { TossSelectorOption } from '../../../../../shared/components/selectors/TossSelector/TossSelector.types';
import { ErrorMessage } from '../../../../../shared/components/common/ErrorMessage/ErrorMessage';
import { useTransactionFormState } from './hooks/useTransactionFormState';
import { useCounterpartyData } from './hooks/useCounterpartyData';
import { useAccountMapping } from './hooks/useAccountMapping';

export const TransactionForm: React.FC<TransactionFormProps> = ({
  isDebit: initialIsDebit,
  onSubmit,
  accounts,
  cashLocations,
  counterparties,
  companyId,
  suggestedAmount,
  initialData,
  disabledCashLocationId = null,
  onCheckAccountMapping,
  onGetCounterpartyStores,
  onGetCounterpartyCashLocations,
  onValidationChange,
}) => {
  // Use custom hooks for state management
  const formState = useTransactionFormState({
    initialData,
    initialIsDebit,
    suggestedAmount,
  });

  const {
    isDebit,
    selectedAccountId,
    amount,
    description,
    selectedCashLocation,
    selectedCounterparty,
    counterpartyStores,
    selectedCounterpartyStore,
    counterpartyCashLocations,
    selectedCounterpartyCashLocation,
    loadingCounterpartyStores,
    loadingCounterpartyCashLocations,
    debtCategory,
    interestRate,
    interestAccountId,
    interestDueDay,
    issueDate,
    dueDate,
    debtDescription,
    setIsDebit,
    setSelectedCashLocation,
    setSelectedCounterparty,
    setSelectedCounterpartyStore,
    setSelectedCounterpartyCashLocation,
    setDebtCategory,
    setInterestRate,
    setInterestAccountId,
    setInterestDueDay,
    setIssueDate,
    setDueDate,
    setDebtDescription,
    setCounterpartyStores,
    setCounterpartyCashLocations,
    setLoadingCounterpartyStores,
    setLoadingCounterpartyCashLocations,
    setDescription,
    formatAmountDisplay,
    handleAmountChange,
    handleAccountChange,
  } = formState;

  // Get selected account
  const selectedAccount = accounts.find(acc => acc.accountId === selectedAccountId) || null;

  // Use counterparty data hook
  const { selectedCounterpartyData } = useCounterpartyData({
    selectedCounterparty,
    counterparties,
    setCounterpartyStores,
    setSelectedCounterpartyStore,
    setCounterpartyCashLocations,
    setSelectedCounterpartyCashLocation,
    setLoadingCounterpartyStores,
    setLoadingCounterpartyCashLocations,
    selectedCounterpartyStore,
    onGetCounterpartyStores,
    onGetCounterpartyCashLocations,
  });

  // Use account mapping validation hook
  const {
    accountMappingStatus,
    showMappingWarning,
    handleMappingWarningClose,
  } = useAccountMapping({
    selectedAccountId,
    selectedAccount,
    selectedCounterparty,
    selectedCounterpartyData,
    companyId,
    onCheckAccountMapping,
  });

  // Helper functions for category colors
  const getCategoryBadgeColor = (tag: string): string => {
    switch (tag?.toLowerCase()) {
      case 'payable': return 'rgba(239, 68, 68, 0.15)';
      case 'receivable': return 'rgba(59, 130, 246, 0.15)';
      case 'contra_asset': return 'rgba(107, 114, 128, 0.15)';
      case 'cash': return 'rgba(34, 197, 94, 0.15)';
      case 'general': return 'rgba(107, 114, 128, 0.15)';
      case 'fixed_asset': return 'rgba(168, 85, 247, 0.15)';
      case 'equity': return 'rgba(14, 165, 233, 0.15)';
      default: return 'rgba(107, 114, 128, 0.15)';
    }
  };

  const getCategoryTextColor = (tag: string): string => {
    switch (tag?.toLowerCase()) {
      case 'payable': return 'rgb(239, 68, 68)';
      case 'receivable': return 'rgb(59, 130, 246)';
      case 'contra_asset': return 'rgb(107, 114, 128)';
      case 'cash': return 'rgb(34, 197, 94)';
      case 'general': return 'rgb(107, 114, 128)';
      case 'fixed_asset': return 'rgb(168, 85, 247)';
      case 'equity': return 'rgb(14, 165, 233)';
      default: return 'rgb(107, 114, 128)';
    }
  };

  const getCategoryTagLabel = (tag: string): string => {
    if (!tag) return 'General';
    return tag.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
  };

  const getInitials = (name: string): string => {
    if (!name) return '??';
    const words = name.trim().split(' ');
    if (words.length === 1) {
      return name.substring(0, 2).toUpperCase();
    }
    return words.slice(0, 2).map(w => w[0]).join('').toUpperCase();
  };

  // Convert accounts to TossSelector options
  const accountOptions: TossSelectorOption[] = accounts.map((account) => ({
    value: account.accountId,
    label: account.accountName,
    badge: getInitials(account.accountName),
    description: account.categoryTag && account.categoryTag.toLowerCase() !== 'general'
      ? getCategoryTagLabel(account.categoryTag)
      : undefined,
    descriptionBgColor: account.categoryTag ? getCategoryBadgeColor(account.categoryTag) : undefined,
    descriptionColor: account.categoryTag ? getCategoryTextColor(account.categoryTag) : undefined,
  }));

  // Convert cash locations to TossSelector options
  const cashLocationOptions: TossSelectorOption[] = cashLocations.map((location) => ({
    value: location.locationId,
    label: location.locationName,
    badge: getInitials(location.locationName),
    description: location.locationType || undefined,
    disabled: disabledCashLocationId === location.locationId && selectedCashLocation !== location.locationId,
  }));

  // Convert counterparties to TossSelector options
  const counterpartyOptions: TossSelectorOption[] = counterparties.map((counterparty) => {
    let description = '';
    let descriptionBgColor: string | undefined = undefined;
    let descriptionColor: string | undefined = undefined;

    if (counterparty.isInternal) {
      description = 'Internal Company';
      if (counterparty.type) {
        description += ` • ${counterparty.type}`;
      }
      descriptionBgColor = 'rgba(59, 130, 246, 0.1)';
      descriptionColor = 'rgba(59, 130, 246, 1)';
    } else {
      description = counterparty.type || '';
      if (description) {
        descriptionBgColor = 'rgba(107, 114, 128, 0.1)';
        descriptionColor = 'rgba(107, 114, 128, 1)';
      }
    }

    return {
      value: counterparty.counterpartyId,
      label: counterparty.counterpartyName,
      badge: getInitials(counterparty.counterpartyName),
      description: description || undefined,
      descriptionBgColor: descriptionBgColor,
      descriptionColor: descriptionColor,
    };
  });

  // Handle form submission
  const handleSubmit = () => {
    if (!selectedAccountId || !amount) {
      return;
    }

    const account = accounts.find(acc => acc.accountId === selectedAccountId);
    if (!account) {
      return;
    }

    const amountNum = parseFloat(amount.replace(/,/g, ''));
    if (isNaN(amountNum) || amountNum <= 0) {
      return;
    }

    const formData: TransactionFormData = {
      accountId: account.accountId,
      accountName: account.accountName,
      categoryTag: account.categoryTag,
      amount: amountNum,
      description: description || undefined,
      isDebit,
      cashLocationId: selectedCashLocation || undefined,
      counterpartyId: selectedCounterparty || undefined,
      counterpartyStoreId: selectedCounterpartyStore || undefined,
      counterpartyCashLocationId: selectedCounterpartyCashLocation || undefined,
      debtCategory: debtCategory || undefined,
      interestRate: interestRate ? parseFloat(interestRate) : undefined,
      interestAccountId: interestAccountId || undefined,
      interestDueDay: interestDueDay ? parseInt(interestDueDay) : undefined,
      issueDate: issueDate || undefined,
      dueDate: dueDate || undefined,
      debtDescription: debtDescription || undefined,
    };

    onSubmit(formData);
  };

  // Check if form is valid
  const isFormValid = (() => {
    if (!selectedAccountId || !amount || parseFloat(amount) <= 0) {
      return false;
    }

    const categoryTag = selectedAccount?.categoryTag?.toLowerCase();
    if ((categoryTag === 'payable' || categoryTag === 'receivable') && !selectedCounterparty) {
      return false;
    }

    if (selectedCounterpartyData?.isInternal && selectedCounterpartyData?.linkedCompanyId) {
      if (!selectedCounterpartyStore || !selectedCounterpartyCashLocation) {
        return false;
      }
    }

    return true;
  })();

  // Notify parent component when validation state changes
  useEffect(() => {
    onValidationChange?.(isFormValid);
  }, [isFormValid, onValidationChange]);

  // Debt categories (must match database constraint: note, account, loan, other)
  const debtCategoryOptions: TossSelectorOption[] = [
    { value: '', label: 'Select debt category' },
    { value: 'note', label: 'Note (어음)' },
    { value: 'account', label: 'Account (외상)' },
    { value: 'loan', label: 'Loan (대출)' },
    { value: 'other', label: 'Other (기타)' },
  ];

  // Render conditional fields based on account categoryTag
  const renderConditionalFields = () => {
    if (!selectedAccount || !selectedAccount.categoryTag) {
      return null;
    }

    const { categoryTag } = selectedAccount;
    const isPayableOrReceivable = categoryTag === 'receivable' || categoryTag === 'payable';

    const counterpartyStoreOptions: TossSelectorOption[] = counterpartyStores.map((store) => ({
      value: store.storeId,
      label: store.storeName,
      badge: getInitials(store.storeName),
    }));

    const counterpartyCashLocationOptions: TossSelectorOption[] = counterpartyCashLocations.map((location) => ({
      value: location.locationId,
      label: location.locationName,
      badge: getInitials(location.locationName),
      description: location.locationType || undefined,
    }));

    return (
      <div className={styles.conditionalFields}>
        {/* Cash Location for cash accounts */}
        {categoryTag === 'cash' && (
          <TossSelector
            label="Cash Location"
            placeholder="Select cash location"
            value={selectedCashLocation}
            options={cashLocationOptions}
            onChange={(value) => setSelectedCashLocation(value)}
            required={true}
            searchable={true}
            showBadges={false}
            fullWidth={true}
            emptyMessage="No cash locations found"
          />
        )}

        {/* Counterparty for receivable/payable accounts */}
        {isPayableOrReceivable && (
          <>
            <TossSelector
              label="Counterparty"
              placeholder="Select counterparty"
              value={selectedCounterparty}
              options={counterpartyOptions}
              onChange={(value) => setSelectedCounterparty(value)}
              required={true}
              searchable={true}
              showBadges={false}
              showDescriptions={true}
              fullWidth={true}
              emptyMessage="No counterparties found"
            />

            {/* Account Mapping Success Indicator */}
            {selectedCounterpartyData?.isInternal && accountMappingStatus === 'valid' && (
              <div style={{
                padding: '12px 16px',
                backgroundColor: 'rgba(34, 197, 94, 0.1)',
                borderRadius: '8px',
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                marginTop: '12px',
              }}>
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <circle cx="10" cy="10" r="10" fill="rgb(34, 197, 94)" opacity="0.2"/>
                  <path d="M6 10l3 3 5-5" stroke="rgb(34, 197, 94)" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
                <span style={{ color: 'rgb(34, 197, 94)', fontSize: '14px', fontWeight: '500' }}>
                  Account mapping verified
                </span>
              </div>
            )}

            {/* Counterparty Store Selector */}
            {selectedCounterpartyData?.isInternal && selectedCounterpartyData?.linkedCompanyId && (
              <TossSelector
                label="Counterparty Store"
                placeholder={loadingCounterpartyStores ? "Loading stores..." : "Select counterparty store"}
                value={selectedCounterpartyStore}
                options={counterpartyStoreOptions}
                onChange={(value) => {
                  setSelectedCounterpartyStore(value);
                  setSelectedCounterpartyCashLocation('');
                }}
                required={true}
                searchable={true}
                showBadges={false}
                fullWidth={true}
                emptyMessage={loadingCounterpartyStores ? "Loading..." : "No stores configured for this counterparty"}
                disabled={loadingCounterpartyStores}
              />
            )}

            {/* Counterparty Cash Location Selector */}
            {selectedCounterpartyData?.isInternal && selectedCounterpartyData?.linkedCompanyId && (
              <TossSelector
                label="Counterparty Cash Location"
                placeholder={loadingCounterpartyCashLocations ? "Loading locations..." : "Select counterparty cash location"}
                value={selectedCounterpartyCashLocation}
                options={counterpartyCashLocationOptions}
                onChange={(value) => setSelectedCounterpartyCashLocation(value)}
                required={true}
                searchable={true}
                showBadges={false}
                fullWidth={true}
                emptyMessage={loadingCounterpartyCashLocations ? "Loading..." : "No cash locations found"}
                disabled={loadingCounterpartyCashLocations}
              />
            )}
          </>
        )}
      </div>
    );
  };

  return (
    <form className={styles.transactionForm} onSubmit={(e) => {
      e.preventDefault();
      handleSubmit();
    }}>
      {/* Transaction Type Toggle */}
      <div className={styles.formSection}>
        <div className={styles.formTitle}>Transaction Type</div>
        <div className={`${styles.transactionTypeToggle} ${!isDebit ? styles.credit : ''}`}>
          <button
            type="button"
            className={`${styles.transactionTypeOption} ${isDebit ? styles.active : ''}`}
            onClick={() => setIsDebit(true)}
          >
            Debit
          </button>
          <button
            type="button"
            className={`${styles.transactionTypeOption} ${!isDebit ? styles.active : ''}`}
            onClick={() => setIsDebit(false)}
          >
            Credit
          </button>
        </div>
      </div>

      {/* Account Selection */}
      <TossSelector
        label="Account"
        placeholder="Select account"
        value={selectedAccountId}
        options={accountOptions}
        onChange={handleAccountChange}
        required={true}
        searchable={true}
        showBadges={false}
        showDescriptions={true}
        fullWidth={true}
        emptyMessage="No accounts found"
      />

      {/* Conditional Fields */}
      {renderConditionalFields()}

      {/* Amount */}
      <div className={styles.formSection}>
        <div className={styles.formTitle}>
          Amount <span className={styles.required}>*</span>
        </div>
        <input
          type="text"
          className={styles.input}
          placeholder="Enter amount"
          value={formatAmountDisplay(amount)}
          onChange={(e) => handleAmountChange(e.target.value)}
        />
      </div>

      {/* Description */}
      <div className={styles.formSection}>
        <div className={styles.formTitle}>Description (Optional)</div>
        <input
          type="text"
          className={styles.input}
          placeholder="Enter description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
        />
      </div>

      {/* Debt Fields (for payable/receivable accounts with counterparty) */}
      {selectedAccount?.categoryTag &&
       (selectedAccount.categoryTag === 'payable' || selectedAccount.categoryTag === 'receivable') &&
       selectedCounterparty && (
        <div className={styles.debtFields}>
          <TossSelector
            label="Debt Category (Optional)"
            placeholder="Select debt category"
            value={debtCategory}
            options={debtCategoryOptions}
            onChange={(value) => setDebtCategory(value)}
            required={false}
            searchable={false}
            showBadges={false}
            fullWidth={true}
            emptyMessage="No categories available"
          />

          <div className={styles.formSection}>
            <div className={styles.formTitle}>Interest Rate (%) (Optional)</div>
            <input
              type="number"
              className={styles.input}
              placeholder="Enter interest rate"
              value={interestRate}
              onChange={(e) => setInterestRate(e.target.value)}
              min="0"
              max="100"
              step="0.01"
            />
          </div>

          <TossSelector
            label="Interest Account (Optional)"
            placeholder="Select interest account"
            value={interestAccountId}
            options={accountOptions}
            onChange={(value) => setInterestAccountId(value)}
            required={false}
            searchable={true}
            showBadges={false}
            showDescriptions={true}
            fullWidth={true}
            emptyMessage="No accounts found"
          />

          <div className={styles.formSection}>
            <div className={styles.formTitle}>Interest Due Day (Optional)</div>
            <input
              type="number"
              className={styles.input}
              placeholder="Enter day (1-31)"
              value={interestDueDay}
              onChange={(e) => setInterestDueDay(e.target.value)}
              min="1"
              max="31"
              step="1"
            />
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
            <div className={styles.formSection}>
              <div className={styles.formTitle}>Issue Date (Optional)</div>
              <div className={styles.dateInputWrapper}>
                <input
                  type="date"
                  className={styles.input}
                  value={issueDate}
                  onChange={(e) => setIssueDate(e.target.value)}
                />
                {issueDate && (
                  <button
                    type="button"
                    className={styles.dateClearButton}
                    onClick={() => setIssueDate('')}
                    aria-label="Clear issue date"
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                    </svg>
                  </button>
                )}
              </div>
            </div>
            <div className={styles.formSection}>
              <div className={styles.formTitle}>Due Date (Optional)</div>
              <div className={styles.dateInputWrapper}>
                <input
                  type="date"
                  className={styles.input}
                  value={dueDate}
                  onChange={(e) => setDueDate(e.target.value)}
                />
                {dueDate && (
                  <button
                    type="button"
                    className={styles.dateClearButton}
                    onClick={() => setDueDate('')}
                    aria-label="Clear due date"
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                    </svg>
                  </button>
                )}
              </div>
            </div>
          </div>

          <div className={styles.formSection}>
            <div className={styles.formTitle}>Debt Description (Optional)</div>
            <textarea
              className={styles.input}
              placeholder="Enter debt description"
              value={debtDescription}
              onChange={(e) => setDebtDescription(e.target.value)}
              rows={2}
              style={{ resize: 'vertical', fontFamily: 'inherit' }}
            />
          </div>
        </div>
      )}

      {/* Hidden submit button for form validation */}
      <button
        type="submit"
        style={{ display: 'none' }}
        disabled={!isFormValid}
      />

      {/* Account Mapping Warning Dialog */}
      <ErrorMessage
        variant="warning"
        title="Account Mapping Required"
        message="This internal counterparty requires an account mapping to be set up first. Please configure the account mapping in the Account Mapping page before using this counterparty."
        isOpen={showMappingWarning}
        onClose={handleMappingWarningClose}
        onConfirm={handleMappingWarningClose}
        confirmText="OK"
        showCancelButton={false}
      />
    </form>
  );
};

export default TransactionForm;
