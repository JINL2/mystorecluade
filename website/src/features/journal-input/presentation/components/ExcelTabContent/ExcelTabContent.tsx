/**
 * ExcelTabContent Component
 * Excel-like table for journal entry input using TossSelector
 * Updated: Replaced custom dropdowns with TossSelector for consistency
 */

import React, { useState } from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import type { ExcelTabContentProps } from './ExcelTabContent.types';
import { JournalInputDataSource } from '../../../data/datasources/JournalInputDataSource';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { CounterpartyCashLocationModal } from './CounterpartyCashLocationModal';
import styles from './ExcelTabContent.module.css';

const journalDataSource = new JournalInputDataSource();

export const ExcelTabContent: React.FC<ExcelTabContentProps> = ({
  accounts,
  cashLocations,
  counterparties,
  companyId,
  selectedStoreId,
  userId,
  onCheckAccountMapping,
  onGetCounterpartyStores,
  onGetCounterpartyCashLocations,
  onSubmitSuccess,
  onSubmitError,
}) => {
  // Row data interface
  interface RowData {
    id: number;
    date: string;
    accountId: string;
    locationId: string;
    internalId: string;
    externalId: string;
    detail: string;
    debit: string;
    credit: string;
    counterpartyStoreId: string;
    counterpartyCashLocationId: string;
  }

  const [rows, setRows] = useState<RowData[]>([
    {
      id: 1,
      date: '',
      accountId: '',
      locationId: '',
      internalId: '',
      externalId: '',
      detail: '',
      debit: '',
      credit: '',
      counterpartyStoreId: '',
      counterpartyCashLocationId: '',
    },
    {
      id: 2,
      date: '',
      accountId: '',
      locationId: '',
      internalId: '',
      externalId: '',
      detail: '',
      debit: '',
      credit: '',
      counterpartyStoreId: '',
      counterpartyCashLocationId: '',
    },
  ]);

  const [nextId, setNextId] = useState(3);
  const [submitting, setSubmitting] = useState(false);
  const [showMappingWarning, setShowMappingWarning] = useState(false);
  const [mappingWarningMessage, setMappingWarningMessage] = useState('');

  // Modal state for counterparty cash location
  const [showCashLocationModal, setShowCashLocationModal] = useState(false);
  const [selectedRowForModal, setSelectedRowForModal] = useState<number | null>(null);
  const [modalCounterpartyData, setModalCounterpartyData] = useState<{
    counterpartyId: string;
    counterpartyName: string;
    linkedCompanyId: string;
  } | null>(null);

  // Get selected account
  const getSelectedAccount = (accountId: string) => {
    return accounts.find(acc => acc.accountId === accountId);
  };

  // Check if selected account is "Cash"
  const isCashAccount = (accountId: string) => {
    const account = getSelectedAccount(accountId);
    return account && account.accountName.toLowerCase() === 'cash';
  };

  // Check if selected account is Payable or Receivable
  const isPayableOrReceivable = (accountId: string) => {
    const account = getSelectedAccount(accountId);
    if (!account || !account.categoryTag) return false;
    const tag = account.categoryTag.toLowerCase();
    return tag === 'payable' || tag === 'receivable';
  };

  // Convert accounts to TossSelector options
  const accountOptions: TossSelectorOption[] = accounts.map(account => ({
    value: account.accountId,
    label: account.accountName || account.account_name || '',
  }));

  // Get selected locations from all rows
  const getSelectedLocations = () => {
    return rows.map(row => row.locationId).filter(id => id);
  };

  // Convert cash locations to TossSelector options with disabled state
  const getLocationOptions = (currentRowId: number): TossSelectorOption[] => {
    const selectedLocations = getSelectedLocations();
    const currentRow = rows.find(r => r.id === currentRowId);

    return cashLocations.map(location => ({
      value: location.locationId,
      label: location.locationName,
      disabled: selectedLocations.includes(location.locationId) &&
                currentRow?.locationId !== location.locationId,
    }));
  };

  // Get counterparty options (internal or external)
  const getCounterpartyOptions = (isInternal: boolean): TossSelectorOption[] => {
    const filtered = counterparties.filter(cp =>
      isInternal ? cp.isInternal === true : cp.isInternal !== true
    );
    return filtered.map(cp => ({
      value: cp.counterpartyId,
      label: cp.counterpartyName,
    }));
  };

  // Format number with commas
  const formatNumber = (value: string): string => {
    if (!value) return '';
    const cleaned = value.replace(/[^\d.]/g, '');
    const parts = cleaned.split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return parts.length > 1 ? parts[0] + '.' + parts[1] : parts[0];
  };

  // Calculate totals and difference
  const calculateTotals = () => {
    const totalDebit = rows.reduce((sum, row) => {
      const value = parseFloat(row.debit.replace(/,/g, '')) || 0;
      return sum + value;
    }, 0);

    const totalCredit = rows.reduce((sum, row) => {
      const value = parseFloat(row.credit.replace(/,/g, '')) || 0;
      return sum + value;
    }, 0);

    const difference = totalDebit - totalCredit;

    return {
      totalDebit,
      totalCredit,
      difference,
    };
  };

  const { totalDebit, totalCredit, difference } = calculateTotals();

  // Validate all active fields are filled
  const validateForm = () => {
    // Check difference is 0
    if (difference !== 0) return false;

    // Check each row
    for (const row of rows) {
      // Date must be filled
      if (!row.date) return false;

      // Account must be selected
      if (!row.accountId) return false;

      // If Cash account, Location must be selected
      if (isCashAccount(row.accountId) && !row.locationId) return false;

      // If Payable/Receivable account, either Internal or External must be selected
      if (isPayableOrReceivable(row.accountId) && !row.internalId && !row.externalId) return false;

      // Detail is optional - no validation needed

      // Either Debit or Credit must have a value
      const debitValue = parseFloat(row.debit.replace(/,/g, '')) || 0;
      const creditValue = parseFloat(row.credit.replace(/,/g, '')) || 0;
      if (debitValue === 0 && creditValue === 0) return false;
    }

    return true;
  };

  const isFormValid = validateForm();

  // Handle number input change
  const handleNumberChange = (value: string, rowId: number, field: 'debit' | 'credit') => {
    const cleaned = value.replace(/[^\d.]/g, '');
    const parts = cleaned.split('.');
    if (parts.length > 2) return;

    setRows(rows.map(row =>
      row.id === rowId ? { ...row, [field]: cleaned } : row
    ));
  };

  // Check account mapping for internal counterparty
  const checkMapping = async (accountId: string, counterpartyId: string) => {
    if (!onCheckAccountMapping) return true;

    const account = getSelectedAccount(accountId);
    const counterparty = counterparties.find(cp => cp.counterpartyId === counterpartyId);

    // Only check for internal counterparties with payable/receivable accounts
    if (!counterparty?.isInternal) return true;

    const categoryTag = account?.categoryTag?.toLowerCase();
    if (categoryTag !== 'payable' && categoryTag !== 'receivable') return true;

    // Check account mapping
    try {
      const hasMapping = await onCheckAccountMapping(companyId, counterpartyId, accountId);

      if (!hasMapping) {
        setMappingWarningMessage(
          'This internal counterparty requires an account mapping to be set up first. Please configure the account mapping in the Account Mapping page before using this counterparty.'
        );
        setShowMappingWarning(true);
        return false;
      }

      return true;
    } catch (error) {
      console.error('Error checking account mapping:', error);
      setMappingWarningMessage('Error checking account mapping. Please try again.');
      setShowMappingWarning(true);
      return false;
    }
  };

  // Update row field
  const updateRowField = async (rowId: number, field: keyof RowData, value: any) => {
    // If internal counterparty is being selected, check account mapping
    if (field === 'internalId' && value) {
      const row = rows.find(r => r.id === rowId);
      if (row && row.accountId) {
        const isValid = await checkMapping(row.accountId, value);
        if (!isValid) {
          return; // Don't update if mapping is invalid
        }

        // If mapping is valid, open modal for cash location selection
        const counterparty = counterparties.find(cp => cp.counterpartyId === value);
        if (counterparty?.isInternal && counterparty?.linkedCompanyId) {
          setSelectedRowForModal(rowId);
          setModalCounterpartyData({
            counterpartyId: value,
            counterpartyName: counterparty.counterpartyName,
            linkedCompanyId: counterparty.linkedCompanyId,
          });
          setShowCashLocationModal(true);
          // Don't update the row yet - wait for modal confirmation
          return;
        }
      }
    }

    setRows(rows.map((row, index) => {
      if (row.id === rowId) {
        const updated = { ...row, [field]: value };

        // If internal is selected, clear external
        if (field === 'internalId' && value) {
          updated.externalId = '';
          updated.counterpartyStoreId = '';
          updated.counterpartyCashLocationId = '';
        }
        // If external is selected, clear internal and counterparty cash location
        if (field === 'externalId' && value) {
          updated.internalId = '';
          updated.counterpartyStoreId = '';
          updated.counterpartyCashLocationId = '';
        }

        return updated;
      }

      // If date is being set on first row (index 0) and second row (index 1) has no date, copy it
      if (field === 'date' && value && rowId === 1 && index === 1 && !row.date) {
        return { ...row, date: value };
      }
      // If date is being set on second row (index 1) and first row (index 0) has no date, copy it
      if (field === 'date' && value && rowId === 2 && index === 0 && !row.date) {
        return { ...row, date: value };
      }

      return row;
    }));
  };

  // Clear counterparty selection
  const clearCounterparty = (rowId: number, field: 'internalId' | 'externalId') => {
    updateRowField(rowId, field, '');
  };

  // Handle modal confirm
  const handleModalConfirm = (storeId: string, cashLocationId: string) => {
    if (selectedRowForModal !== null && modalCounterpartyData) {
      setRows(rows.map(row => {
        if (row.id === selectedRowForModal) {
          return {
            ...row,
            internalId: modalCounterpartyData.counterpartyId,
            externalId: '',
            counterpartyStoreId: storeId,
            counterpartyCashLocationId: cashLocationId,
          };
        }
        return row;
      }));
    }

    setShowCashLocationModal(false);
    setSelectedRowForModal(null);
    setModalCounterpartyData(null);
  };

  // Handle modal cancel
  const handleModalCancel = () => {
    setShowCashLocationModal(false);
    setSelectedRowForModal(null);
    setModalCounterpartyData(null);
  };

  // Add new row
  const handleAddLine = () => {
    setRows([...rows, {
      id: nextId,
      date: '',
      accountId: '',
      locationId: '',
      internalId: '',
      externalId: '',
      detail: '',
      debit: '',
      credit: '',
      counterpartyStoreId: '',
      counterpartyCashLocationId: '',
    }]);
    setNextId(nextId + 1);
  };

  // Delete row
  const handleDeleteRow = (rowId: number) => {
    if (rows.length <= 2) return;
    setRows(rows.filter(row => row.id !== rowId));
  };

  // Handle submit
  const handleSubmit = async () => {
    if (!isFormValid || submitting) return;

    setSubmitting(true);

    try {
      // Transform rows to transaction lines format
      const transactionLines = rows.map(row => {
        const account = getSelectedAccount(row.accountId);
        const debitValue = parseFloat(row.debit.replace(/,/g, '')) || 0;
        const creditValue = parseFloat(row.credit.replace(/,/g, '')) || 0;
        const amount = debitValue > 0 ? debitValue : creditValue;
        const isDebit = debitValue > 0;

        // Find counterparty data
        const counterpartyId = row.internalId || row.externalId || null;
        const counterparty = counterpartyId
          ? counterparties.find(cp => cp.counterpartyId === counterpartyId)
          : null;

        // Determine debt category based on account type and debit/credit
        let debtCategory = null;
        if (counterpartyId && account) {
          const categoryTag = account.categoryTag?.toLowerCase();
          if (categoryTag === 'receivable') {
            debtCategory = 'sales'; // Receivable = sales revenue
          } else if (categoryTag === 'payable') {
            debtCategory = 'expense'; // Payable = expense
          } else {
            debtCategory = 'other';
          }
        }

        return {
          isDebit,
          accountId: row.accountId,
          amount,
          description: row.detail || '',
          cashLocationId: row.locationId || null,
          counterpartyId,
          counterpartyStoreId: row.counterpartyStoreId || null,
          debtCategory,
          interestRate: null,
          interestAccountId: null,
          interestDueDay: null,
          issueDate: row.date,
          dueDate: null,
          debtDescription: null,
          linkedCompanyId: counterparty?.linked_company_id || counterparty?.linkedCompanyId || null,
          counterpartyCashLocationId: row.counterpartyCashLocationId || null,
        };
      });

      // Submit journal entry
      // Convert date string (yyyy-MM-dd) to Date object with current time
      const [year, month, day] = rows[0].date.split('-').map(Number);
      const now = new Date();
      const dateWithTime = new Date(year, month - 1, day, now.getHours(), now.getMinutes(), now.getSeconds());

      await journalDataSource.submitJournalEntry({
        companyId,
        storeId: selectedStoreId,
        date: dateWithTime, // Pass Date object with time components
        createdBy: userId,
        description: 'Excel journal entry', // You can make this customizable
        transactionLines,
      });

      // Reset form on success
      setRows([
        {
          id: 1,
          date: '',
          accountId: '',
          locationId: '',
          internalId: '',
          externalId: '',
          detail: '',
          debit: '',
          credit: '',
          counterpartyStoreId: '',
          counterpartyCashLocationId: '',
        },
        {
          id: 2,
          date: '',
          accountId: '',
          locationId: '',
          internalId: '',
          externalId: '',
          detail: '',
          debit: '',
          credit: '',
          counterpartyStoreId: '',
          counterpartyCashLocationId: '',
        },
      ]);
      setNextId(3);

      if (onSubmitSuccess) {
        onSubmitSuccess();
      }
    } catch (error) {
      console.error('Error submitting journal entry:', error);
      if (onSubmitError) {
        onSubmitError(error instanceof Error ? error.message : 'Failed to submit journal entry');
      }
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className={styles.container}>
      <table className={styles.table}>
        <thead>
          <tr>
            <th>Date</th>
            <th>Account</th>
            <th>Location</th>
            <th>Internal</th>
            <th>External</th>
            <th>Detail</th>
            <th>Debit</th>
            <th>Credit</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row.id}>
              <td>
                <input
                  type="date"
                  value={row.date}
                  onChange={(e) => updateRowField(row.id, 'date', e.target.value)}
                />
              </td>
              <td className={styles.selectorCell}>
                <TossSelector
                  value={row.accountId}
                  options={accountOptions}
                  onChange={(value) => updateRowField(row.id, 'accountId', value)}
                  placeholder="Select account..."
                  searchable={true}
                  inline={true}
                  fullWidth={true}
                  emptyMessage="No accounts available"
                />
              </td>
              <td className={`${styles.selectorCell} ${!isCashAccount(row.accountId) ? styles.disabled : ''}`}>
                <TossSelector
                  value={row.locationId}
                  options={getLocationOptions(row.id)}
                  onChange={(value) => updateRowField(row.id, 'locationId', value)}
                  placeholder="Select location..."
                  searchable={true}
                  inline={true}
                  fullWidth={true}
                  disabled={!isCashAccount(row.accountId)}
                  emptyMessage="No locations available"
                />
              </td>
              <td className={`${styles.selectorCell} ${(!isPayableOrReceivable(row.accountId) || row.externalId) ? styles.disabled : ''}`}>
                <div className={styles.counterpartyCell}>
                  <TossSelector
                    value={row.internalId}
                    options={getCounterpartyOptions(true)}
                    onChange={(value) => updateRowField(row.id, 'internalId', value)}
                    placeholder="Select internal..."
                    searchable={true}
                    inline={true}
                    fullWidth={true}
                    disabled={!isPayableOrReceivable(row.accountId) || !!row.externalId}
                    emptyMessage="No internal counterparties"
                  />
                  {row.internalId && (
                    <button
                      className={styles.clearButton}
                      onClick={() => clearCounterparty(row.id, 'internalId')}
                      type="button"
                    >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                      </svg>
                    </button>
                  )}
                </div>
              </td>
              <td className={`${styles.selectorCell} ${(!isPayableOrReceivable(row.accountId) || row.internalId) ? styles.disabled : ''}`}>
                <div className={styles.counterpartyCell}>
                  <TossSelector
                    value={row.externalId}
                    options={getCounterpartyOptions(false)}
                    onChange={(value) => updateRowField(row.id, 'externalId', value)}
                    placeholder="Select external..."
                    searchable={true}
                    inline={true}
                    fullWidth={true}
                    disabled={!isPayableOrReceivable(row.accountId) || !!row.internalId}
                    emptyMessage="No external counterparties"
                  />
                  {row.externalId && (
                    <button
                      className={styles.clearButton}
                      onClick={() => clearCounterparty(row.id, 'externalId')}
                      type="button"
                    >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                      </svg>
                    </button>
                  )}
                </div>
              </td>
              <td>
                <input
                  type="text"
                  value={row.detail}
                  onChange={(e) => updateRowField(row.id, 'detail', e.target.value)}
                  placeholder="Enter detail..."
                />
              </td>
              <td>
                <input
                  type="text"
                  inputMode="decimal"
                  value={formatNumber(row.debit)}
                  onChange={(e) => handleNumberChange(e.target.value, row.id, 'debit')}
                  placeholder="0"
                  style={{ textAlign: 'right' }}
                />
              </td>
              <td>
                <input
                  type="text"
                  inputMode="decimal"
                  value={formatNumber(row.credit)}
                  onChange={(e) => handleNumberChange(e.target.value, row.id, 'credit')}
                  placeholder="0"
                  style={{ textAlign: 'right' }}
                />
              </td>
              <td>
                <button
                  className={styles.deleteButton}
                  onClick={() => handleDeleteRow(row.id)}
                  disabled={rows.length <= 2}
                >
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
                  </svg>
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Summary and Action Buttons */}
      <div className={styles.actionButtons}>
        <div className={styles.summary}>
          <div className={styles.summaryItem}>
            <span className={styles.summaryLabel}>Difference:</span>
            <span className={`${styles.summaryValue} ${difference !== 0 ? styles.summaryError : styles.summarySuccess}`}>
              {formatNumber(Math.abs(difference).toString())}
            </span>
          </div>
        </div>
        <div className={styles.buttonGroup}>
          <button className={styles.addLineButton} onClick={handleAddLine}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
            </svg>
            Add Line
          </button>
          <button
            className={styles.submitButton}
            disabled={!isFormValid || submitting}
            onClick={handleSubmit}
          >
            {submitting ? 'Submitting...' : 'Submit'}
          </button>
        </div>
      </div>

      {/* Account Mapping Warning Dialog */}
      <ErrorMessage
        variant="warning"
        title="Account Mapping Required"
        message={mappingWarningMessage}
        isOpen={showMappingWarning}
        onClose={() => setShowMappingWarning(false)}
        onConfirm={() => setShowMappingWarning(false)}
        confirmText="OK"
        showCancelButton={false}
      />

      {/* Counterparty Cash Location Modal */}
      {modalCounterpartyData && (
        <CounterpartyCashLocationModal
          isOpen={showCashLocationModal}
          counterpartyName={modalCounterpartyData.counterpartyName}
          linkedCompanyId={modalCounterpartyData.linkedCompanyId}
          onGetCounterpartyStores={onGetCounterpartyStores}
          onGetCounterpartyCashLocations={onGetCounterpartyCashLocations}
          onConfirm={handleModalConfirm}
          onCancel={handleModalCancel}
        />
      )}
    </div>
  );
};

export default ExcelTabContent;
