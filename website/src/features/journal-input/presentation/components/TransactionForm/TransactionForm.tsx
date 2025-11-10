/**
 * TransactionForm Component
 * Add/Edit transaction form matching backup HTML design
 */

import React, { useState } from 'react';
import styles from './TransactionForm.module.css';
import type {
  TransactionFormProps,
  TransactionFormData,
} from './TransactionForm.types';
import { TossSelector } from '../../../../../shared/components/selectors/TossSelector/TossSelector';
import type { TossSelectorOption } from '../../../../../shared/components/selectors/TossSelector/TossSelector.types';

export const TransactionForm: React.FC<TransactionFormProps> = ({
  isDebit: initialIsDebit,
  onSubmit,
  accounts,
  cashLocations,
  counterparties,
  suggestedAmount,
}) => {
  // Format amount for display
  const formatAmountDisplay = (value: string): string => {
    if (!value) return '';

    const num = parseFloat(value);
    if (isNaN(num)) return value;

    return num.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 2,
    });
  };

  // Form state
  const [isDebit, setIsDebit] = useState(initialIsDebit);
  const [selectedAccountId, setSelectedAccountId] = useState<string>('');
  const [amount, setAmount] = useState(
    suggestedAmount ? suggestedAmount.toString() : ''
  );
  const [description, setDescription] = useState('');
  const [selectedCashLocation, setSelectedCashLocation] = useState<string>('');
  const [selectedCounterparty, setSelectedCounterparty] = useState<string>('');

  // Get selected account
  const selectedAccount = accounts.find(acc => acc.accountId === selectedAccountId) || null;

  // Convert accounts to TossSelector options
  const accountOptions: TossSelectorOption[] = accounts.map((account) => ({
    value: account.accountId,
    label: account.accountName,
    badge: account.categoryTag,
  }));

  // Convert cash locations to TossSelector options
  const cashLocationOptions: TossSelectorOption[] = cashLocations.map((location) => ({
    value: location.locationId,
    label: location.locationName,
    badge: location.locationType,
  }));

  // Convert counterparties to TossSelector options
  const counterpartyOptions: TossSelectorOption[] = counterparties.map((counterparty) => ({
    value: counterparty.counterpartyId,
    label: counterparty.counterpartyName,
    badge: counterparty.type,
  }));

  // Handle transaction type change
  const handleTypeChange = (debit: boolean) => {
    setIsDebit(debit);
  };

  // Handle account selection
  const handleAccountChange = (value: string) => {
    setSelectedAccountId(value);
    // Reset conditional fields when account changes
    setSelectedCashLocation('');
    setSelectedCounterparty('');
  };

  // Format amount input
  const handleAmountChange = (value: string) => {
    // Remove non-numeric characters except decimal point
    const cleaned = value.replace(/[^\d.]/g, '');

    // Ensure only one decimal point
    const parts = cleaned.split('.');
    if (parts.length > 2) {
      return;
    }

    setAmount(cleaned);
  };

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
    };

    onSubmit(formData);
  };

  // Check if form is valid
  const isFormValid = selectedAccountId && amount && parseFloat(amount) > 0;

  // Render conditional fields based on account categoryTag
  const renderConditionalFields = () => {
    if (!selectedAccount || !selectedAccount.categoryTag) {
      return null;
    }

    const { categoryTag } = selectedAccount;

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
            showBadges={true}
            fullWidth={true}
            emptyMessage="No cash locations found"
          />
        )}

        {/* Counterparty for receivable/payable accounts */}
        {(categoryTag === 'receivable' || categoryTag === 'payable') && (
          <TossSelector
            label="Counterparty"
            placeholder="Select counterparty (optional)"
            value={selectedCounterparty}
            options={counterpartyOptions}
            onChange={(value) => setSelectedCounterparty(value)}
            required={false}
            searchable={true}
            showBadges={true}
            fullWidth={true}
            emptyMessage="No counterparties found"
          />
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
            onClick={() => handleTypeChange(true)}
          >
            Debit
          </button>
          <button
            type="button"
            className={`${styles.transactionTypeOption} ${!isDebit ? styles.active : ''}`}
            onClick={() => handleTypeChange(false)}
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
        showBadges={true}
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

      {/* Hidden submit button for form validation */}
      <button
        type="submit"
        style={{ display: 'none' }}
        disabled={!isFormValid}
      />
    </form>
  );
};

export default TransactionForm;
