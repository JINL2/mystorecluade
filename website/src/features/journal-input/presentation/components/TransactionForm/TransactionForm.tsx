/**
 * TransactionForm Component
 * Add/Edit transaction form matching backup HTML design
 */

import React, { useState, useEffect } from 'react';
import styles from './TransactionForm.module.css';
import type {
  TransactionFormProps,
  TransactionFormData,
  CashLocation,
} from './TransactionForm.types';
import { TossSelector } from '../../../../../shared/components/selectors/TossSelector/TossSelector';
import type { TossSelectorOption } from '../../../../../shared/components/selectors/TossSelector/TossSelector.types';
import { ErrorMessage } from '../../../../../shared/components/common/ErrorMessage/ErrorMessage';

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

  // Form state - use initialData if in edit mode
  const [isDebit, setIsDebit] = useState(initialData?.isDebit ?? initialIsDebit);
  const [selectedAccountId, setSelectedAccountId] = useState<string>(initialData?.accountId ?? '');
  const [amount, setAmount] = useState(
    initialData?.amount ? initialData.amount.toString() : (suggestedAmount ? suggestedAmount.toString() : '')
  );
  const [description, setDescription] = useState(initialData?.description ?? '');
  const [selectedCashLocation, setSelectedCashLocation] = useState<string>(initialData?.cashLocationId ?? '');
  const [selectedCounterparty, setSelectedCounterparty] = useState<string>(initialData?.counterpartyId ?? '');

  // Account mapping validation state
  const [accountMappingStatus, setAccountMappingStatus] = useState<'none' | 'checking' | 'valid' | 'invalid'>('none');
  const [showMappingWarning, setShowMappingWarning] = useState(false);

  // Counterparty-related state (for internal counterparties)
  const [counterpartyStores, setCounterpartyStores] = useState<Array<{ storeId: string; storeName: string }>>([]);
  const [selectedCounterpartyStore, setSelectedCounterpartyStore] = useState<string>(initialData?.counterpartyStoreId ?? '');
  const [counterpartyCashLocations, setCounterpartyCashLocations] = useState<CashLocation[]>([]);
  const [selectedCounterpartyCashLocation, setSelectedCounterpartyCashLocation] = useState<string>(initialData?.counterpartyCashLocationId ?? '');
  const [loadingCounterpartyStores, setLoadingCounterpartyStores] = useState(false);
  const [loadingCounterpartyCashLocations, setLoadingCounterpartyCashLocations] = useState(false);

  // Helper function to get today's date in YYYY-MM-DD format (user's local timezone)
  const getTodayDate = (): string => {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  // Debt-related state (for payable/receivable accounts)
  const [debtCategory, setDebtCategory] = useState<string>(initialData?.debtCategory ?? '');
  const [interestRate, setInterestRate] = useState<string>(initialData?.interestRate?.toString() ?? '0');
  const [interestAccountId, setInterestAccountId] = useState<string>(initialData?.interestAccountId ?? '');
  const [interestDueDay, setInterestDueDay] = useState<string>(initialData?.interestDueDay?.toString() ?? '');
  const [issueDate, setIssueDate] = useState<string>(initialData?.issueDate ?? getTodayDate());
  const [dueDate, setDueDate] = useState<string>(initialData?.dueDate ?? '');
  const [debtDescription, setDebtDescription] = useState<string>(initialData?.debtDescription ?? '');

  // Get selected account
  const selectedAccount = accounts.find(acc => acc.accountId === selectedAccountId) || null;

  // Get selected counterparty
  const selectedCounterpartyData = counterparties.find(cp => cp.counterpartyId === selectedCounterparty) || null;

  // Helper functions for category colors (matching Account Mapping)
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

  // Account mapping validation function
  const checkAccountMapping = async () => {
    // Reset validation state if conditions are not met
    if (!selectedAccountId || !selectedCounterparty || !selectedCounterpartyData || !onCheckAccountMapping) {
      setAccountMappingStatus('none');
      return;
    }

    // Only check mapping for internal counterparties with payable/receivable accounts
    if (!selectedCounterpartyData.isInternal) {
      setAccountMappingStatus('none');
      return;
    }

    const categoryTag = selectedAccount?.categoryTag?.toLowerCase();
    if (categoryTag !== 'payable' && categoryTag !== 'receivable') {
      setAccountMappingStatus('none');
      return;
    }

    // Check account mapping
    setAccountMappingStatus('checking');

    try {
      const hasMapping = await onCheckAccountMapping(companyId, selectedCounterparty, selectedAccountId);

      if (!hasMapping) {
        setAccountMappingStatus('invalid');
        setShowMappingWarning(true);
      } else {
        setAccountMappingStatus('valid');
      }
    } catch (error) {
      console.error('Error checking account mapping:', error);
      setAccountMappingStatus('invalid');
      setShowMappingWarning(true);
    }
  };

  // Run validation when account or counterparty changes
  useEffect(() => {
    checkAccountMapping();
  }, [selectedAccountId, selectedCounterparty]);

  // Load counterparty stores when internal counterparty is selected
  useEffect(() => {
    const loadCounterpartyStores = async () => {
      if (!selectedCounterpartyData?.isInternal || !selectedCounterpartyData?.linkedCompanyId || !onGetCounterpartyStores) {
        setCounterpartyStores([]);
        setSelectedCounterpartyStore('');
        setCounterpartyCashLocations([]);
        setSelectedCounterpartyCashLocation('');
        return;
      }

      setLoadingCounterpartyStores(true);
      try {
        const stores = await onGetCounterpartyStores(selectedCounterpartyData.linkedCompanyId);
        setCounterpartyStores(stores);
      } catch (error) {
        console.error('Error loading counterparty stores:', error);
        setCounterpartyStores([]);
      } finally {
        setLoadingCounterpartyStores(false);
      }
    };

    loadCounterpartyStores();
  }, [selectedCounterparty, selectedCounterpartyData?.isInternal, selectedCounterpartyData?.linkedCompanyId]);

  // Load counterparty cash locations when linkedCompanyId or store changes
  useEffect(() => {
    const loadCounterpartyCashLocations = async () => {
      if (!selectedCounterpartyData?.isInternal || !selectedCounterpartyData?.linkedCompanyId || !onGetCounterpartyCashLocations) {
        setCounterpartyCashLocations([]);
        setSelectedCounterpartyCashLocation('');
        return;
      }

      setLoadingCounterpartyCashLocations(true);
      try {
        const locations = await onGetCounterpartyCashLocations(
          selectedCounterpartyData.linkedCompanyId,
          selectedCounterpartyStore || null
        );
        setCounterpartyCashLocations(locations);
      } catch (error) {
        console.error('Error loading counterparty cash locations:', error);
        setCounterpartyCashLocations([]);
      } finally {
        setLoadingCounterpartyCashLocations(false);
      }
    };

    loadCounterpartyCashLocations();
  }, [selectedCounterparty, selectedCounterpartyData?.linkedCompanyId, selectedCounterpartyStore]);

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
  // Mark the already-used cash location as disabled
  const cashLocationOptions: TossSelectorOption[] = cashLocations.map((location) => ({
    value: location.locationId,
    label: location.locationName,
    badge: getInitials(location.locationName),
    description: location.locationType || undefined,
    // Disable if: (1) this location is already used AND (2) it's not currently selected
    disabled: disabledCashLocationId === location.locationId && selectedCashLocation !== location.locationId,
  }));

  // Convert counterparties to TossSelector options
  // Show all counterparties with "Internal Company" label for internal ones
  const counterpartyOptions: TossSelectorOption[] = counterparties.map((counterparty) => {
    // Debug: Log each counterparty to see its structure
    console.log('Processing counterparty:', {
      id: counterparty.counterpartyId,
      name: counterparty.counterpartyName,
      isInternal: counterparty.isInternal,
      type: counterparty.type,
      linkedCompanyId: counterparty.linkedCompanyId,
      fullObject: counterparty
    });

    // Build description: show "Internal Company" for internal counterparties
    let description = '';
    let descriptionBgColor: string | undefined = undefined;
    let descriptionColor: string | undefined = undefined;

    if (counterparty.isInternal) {
      description = 'Internal Company';
      // Add type if available
      if (counterparty.type) {
        description += ` • ${counterparty.type}`;
      }
      // Use distinct styling for internal counterparties (matching account type badges)
      descriptionBgColor = 'rgba(59, 130, 246, 0.1)'; // Blue background like in Flutter
      descriptionColor = 'rgba(59, 130, 246, 1)'; // Blue text
    } else {
      // For external counterparties, just show type
      description = counterparty.type || '';
      if (description) {
        descriptionBgColor = 'rgba(107, 114, 128, 0.1)'; // Gray background
        descriptionColor = 'rgba(107, 114, 128, 1)'; // Gray text
      }
    }

    const option = {
      value: counterparty.counterpartyId,
      label: counterparty.counterpartyName,
      badge: getInitials(counterparty.counterpartyName),
      description: description || undefined,
      descriptionBgColor: descriptionBgColor,
      descriptionColor: descriptionColor,
    };

    console.log('Created option:', option);
    return option;
  });

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
      // Counterparty-related fields (for internal counterparties)
      counterpartyStoreId: selectedCounterpartyStore || undefined,
      counterpartyCashLocationId: selectedCounterpartyCashLocation || undefined,
      // Debt-related fields (for payable/receivable accounts)
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

  // Handle mapping warning dialog close (reset counterparty selection)
  const handleMappingWarningClose = () => {
    setShowMappingWarning(false);
    setSelectedCounterparty('');
    setAccountMappingStatus('none');
  };

  // Check if form is valid
  const isFormValid = (() => {
    // Basic validation
    if (!selectedAccountId || !amount || parseFloat(amount) <= 0) {
      return false;
    }

    // For payable/receivable accounts, counterparty is required
    const categoryTag = selectedAccount?.categoryTag?.toLowerCase();
    if ((categoryTag === 'payable' || categoryTag === 'receivable') && !selectedCounterparty) {
      return false;
    }

    // For internal counterparties, store and cash location are required
    if (selectedCounterpartyData?.isInternal && selectedCounterpartyData?.linkedCompanyId) {
      // Counterparty store is required
      if (!selectedCounterpartyStore) {
        return false;
      }
      // Counterparty cash location is required
      if (!selectedCounterpartyCashLocation) {
        return false;
      }
    }

    return true;
  })();

  // Notify parent component when validation state changes
  useEffect(() => {
    onValidationChange?.(isFormValid);
  }, [isFormValid, onValidationChange]);

  // Debt categories (matching Flutter app)
  const debtCategories = ['loan', 'purchase', 'salary', 'other'];

  // Convert debt categories to TossSelector options
  const debtCategoryOptions: TossSelectorOption[] = [
    { value: '', label: 'Select debt category' }, // Empty option for optional field
    ...debtCategories.map((category) => ({
      value: category,
      label: category.charAt(0).toUpperCase() + category.slice(1),
    }))
  ];

  // Render conditional fields based on account categoryTag
  const renderConditionalFields = () => {
    if (!selectedAccount || !selectedAccount.categoryTag) {
      return null;
    }

    const { categoryTag } = selectedAccount;
    const isPayableOrReceivable = categoryTag === 'receivable' || categoryTag === 'payable';

    // Convert counterparty stores to TossSelector options
    const counterpartyStoreOptions: TossSelectorOption[] = counterpartyStores.map((store) => ({
      value: store.storeId,
      label: store.storeName,
      badge: getInitials(store.storeName),
    }));

    // Convert counterparty cash locations to TossSelector options
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

            {/* Counterparty Store Selector (for internal counterparties) - REQUIRED */}
            {selectedCounterpartyData?.isInternal && selectedCounterpartyData?.linkedCompanyId && (
              <TossSelector
                label="Counterparty Store"
                placeholder={loadingCounterpartyStores ? "Loading stores..." : "Select counterparty store"}
                value={selectedCounterpartyStore}
                options={counterpartyStoreOptions}
                onChange={(value) => {
                  setSelectedCounterpartyStore(value);
                  // Reset cash location when store changes
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

            {/* Counterparty Cash Location Selector (for internal counterparties) - REQUIRED */}
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
          {/* Debt Category */}
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

          {/* Interest Rate */}
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

          {/* Interest Account ID */}
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

          {/* Interest Due Day */}
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

          {/* Issue Date and Due Date */}
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

          {/* Debt Description */}
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
