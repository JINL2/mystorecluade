/**
 * ExcelTabContent Component
 * Excel-like table for journal entry input using TossSelector
 * Refactored: Uses Zustand provider for state management (ARCHITECTURE.md compliant)
 */

import React, { useEffect, useRef, useState } from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import type { ExcelTabContentProps } from './ExcelTabContent.types';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { CounterpartyCashLocationModal } from './CounterpartyCashLocationModal';
import { RecentTransactionHistory } from '../RecentTransactionHistory';
import { TemplateSelector } from '../TemplateSelector';
import { useExcelTab } from '../../hooks/useExcelTab';
import styles from './ExcelTabContent.module.css';

export const ExcelTabContent: React.FC<ExcelTabContentProps> = ({
  accounts,
  cashLocations: initialCashLocations,
  counterparties,
  templates,
  loadingTemplates,
  companyId,
  userId,
  stores,
  onCheckAccountMapping,
  onGetCounterpartyStores,
  onGetCounterpartyCashLocations,
  onLoadCashLocations,
  onLoadTemplates,
  onApplyTemplate,
  onSubmitSuccess,
  onSubmitError,
  currentStoreId,
  onCurrentStoreChange,
}) => {
  // Local state for store and date selection (independent - for submission only, no page refresh)
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(null);
  // Template store selection - uses app state's currentStore if available
  const [templateStoreId, setTemplateStoreId] = useState<string | null>(
    currentStoreId ?? (stores.length > 0 ? stores[0].store_id : null)
  );

  // Sync templateStoreId with app state's currentStoreId when it changes externally
  useEffect(() => {
    if (currentStoreId !== undefined && currentStoreId !== templateStoreId) {
      setTemplateStoreId(currentStoreId);
    }
  }, [currentStoreId]);

  // Handle template store change - update both local and app state
  const handleTemplateStoreChange = (storeId: string | null) => {
    setTemplateStoreId(storeId);
    if (onCurrentStoreChange) {
      onCurrentStoreChange(storeId);
    }
  };
  const [selectedDate, setSelectedDate] = useState<string>(() => {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  });

  // Local cash locations state (loaded when store changes)
  const [localCashLocations, setLocalCashLocations] = useState<any[]>(initialCashLocations);

  // Refresh trigger for RecentTransactionHistory
  const [refreshTrigger, setRefreshTrigger] = useState(0);

  // Load cash locations when store changes
  useEffect(() => {
    const loadCashLocations = async () => {
      if (onLoadCashLocations) {
        const locations = await onLoadCashLocations(selectedStoreId);
        setLocalCashLocations(locations);
      } else if (!selectedStoreId) {
        // Fallback to initial cash locations when no loader or no store selected
        setLocalCashLocations(initialCashLocations);
      }
    };
    loadCashLocations();
  }, [selectedStoreId, onLoadCashLocations, initialCashLocations]);

  // Load templates when template store changes
  useEffect(() => {
    if (onLoadTemplates && templateStoreId) {
      onLoadTemplates(templateStoreId);
    }
  }, [templateStoreId, onLoadTemplates]);

  // Use custom hook (provider wrapper)
  const {
    rows,
    submitting,
    showMappingWarning,
    mappingWarningMessage,
    showCashLocationModal,
    modalCounterpartyData,
    addRow,
    deleteRow,
    updateRowField,
    clearCounterparty,
    openCashLocationModal,
    closeCashLocationModal,
    confirmCashLocationModal,
    showWarning,
    hideWarning,
    submitExcelEntry,
    applyTemplateToRows,
    reset,
  } = useExcelTab();

  // Refs for focusing next field
  const locationInputRefs = useRef<{ [key: number]: HTMLInputElement | null }>({});
  const internalInputRefs = useRef<{ [key: number]: HTMLInputElement | null }>({});
  const externalInputRefs = useRef<{ [key: number]: HTMLInputElement | null }>({});
  const detailInputRefs = useRef<{ [key: number]: HTMLInputElement | null }>({});
  const debitInputRefs = useRef<{ [key: number]: HTMLInputElement | null }>({});
  const creditInputRefs = useRef<{ [key: number]: HTMLInputElement | null }>({});
  const accountInputRefs = useRef<{ [key: number]: HTMLInputElement | null }>({});

  // Reset on mount
  useEffect(() => {
    reset();
  }, [reset]);

  // Helper functions
  const getSelectedAccount = (accountId: string) => {
    return accounts.find((acc) => acc.accountId === accountId);
  };

  const isCashAccount = (accountId: string) => {
    const account = getSelectedAccount(accountId);
    return account && account.accountName.toLowerCase() === 'cash';
  };

  const isPayableOrReceivable = (accountId: string) => {
    const account = getSelectedAccount(accountId);
    if (!account || !account.categoryTag) return false;
    const tag = account.categoryTag.toLowerCase();
    return tag === 'payable' || tag === 'receivable';
  };

  const formatNumber = (value: string): string => {
    if (!value) return '';
    const cleaned = value.replace(/[^\d.]/g, '');
    const parts = cleaned.split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return parts.length > 1 ? parts[0] + '.' + parts[1] : parts[0];
  };

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

    return { totalDebit, totalCredit, difference };
  };

  const { difference } = calculateTotals();

  // Validate form
  const validateForm = () => {
    // Date must be selected (shared field)
    if (!selectedDate) return false;
    if (difference !== 0) return false;

    for (const row of rows) {
      if (!row.accountId) return false;
      if (isCashAccount(row.accountId) && !row.locationId) return false;
      if (isPayableOrReceivable(row.accountId) && !row.internalId && !row.externalId)
        return false;

      const debitValue = parseFloat(row.debit.replace(/,/g, '')) || 0;
      const creditValue = parseFloat(row.credit.replace(/,/g, '')) || 0;
      if (debitValue === 0 && creditValue === 0) return false;
    }

    return true;
  };

  const isFormValid = validateForm();

  // Convert options
  const accountOptions: TossSelectorOption[] = accounts.map((account) => ({
    value: account.accountId,
    label: account.accountName || account.account_name || '',
  }));

  const getSelectedLocations = () => {
    return rows.map((row) => row.locationId).filter((id) => id);
  };

  const getLocationOptions = (currentRowId: number): TossSelectorOption[] => {
    const selectedLocations = getSelectedLocations();
    const currentRow = rows.find((r) => r.id === currentRowId);

    // Helper function for location type badge colors
    const getLocationTypeBgColor = (type: string): string => {
      switch (type) {
        case 'cash':
          return '#E8F5E9'; // Green-50
        case 'bank':
          return '#E3F2FD'; // Blue-50
        case 'vault':
          return '#E0E0E0'; // Gray-300
        default:
          return '#F5F5F5';
      }
    };

    const getLocationTypeTextColor = (type: string): string => {
      switch (type) {
        case 'cash':
          return '#2E7D32'; // Green-700
        case 'bank':
          return '#1565C0'; // Blue-700
        case 'vault':
          return '#616161'; // Gray-700
        default:
          return '#616161';
      }
    };

    return localCashLocations.map((location) => ({
      value: location.locationId,
      label: location.locationName,
      description: location.locationType?.toUpperCase() || '',
      descriptionBgColor: getLocationTypeBgColor(location.locationType || ''),
      descriptionColor: getLocationTypeTextColor(location.locationType || ''),
      disabled:
        selectedLocations.includes(location.locationId) &&
        currentRow?.locationId !== location.locationId,
    }));
  };

  const getCounterpartyOptions = (isInternal: boolean): TossSelectorOption[] => {
    const filtered = counterparties.filter((cp) =>
      isInternal ? cp.isInternal === true : cp.isInternal !== true
    );
    return filtered.map((cp) => ({
      value: cp.counterpartyId,
      label: cp.counterpartyName,
    }));
  };

  // Handle number input change
  const handleNumberChange = (value: string, rowId: number, field: 'debit' | 'credit') => {
    const cleaned = value.replace(/[^\d.]/g, '');
    const parts = cleaned.split('.');
    if (parts.length > 2) return;

    updateRowField(rowId, field, cleaned);
  };

  // Check account mapping for internal counterparty
  const checkMapping = async (accountId: string, counterpartyId: string) => {
    if (!onCheckAccountMapping) return true;

    const account = getSelectedAccount(accountId);
    const counterparty = counterparties.find((cp) => cp.counterpartyId === counterpartyId);

    if (!counterparty?.isInternal) return true;

    const categoryTag = account?.categoryTag?.toLowerCase();
    if (categoryTag !== 'payable' && categoryTag !== 'receivable') return true;

    try {
      const hasMapping = await onCheckAccountMapping(companyId, counterpartyId, accountId);

      if (!hasMapping) {
        showWarning(
          'This internal counterparty requires an account mapping to be set up first. Please configure the account mapping in the Account Mapping page before using this counterparty.'
        );
        return false;
      }

      return true;
    } catch (error) {
      showWarning('Error checking account mapping. Please try again.');
      return false;
    }
  };

  // Handle row field update with mapping check
  const handleUpdateRowField = async (rowId: number, field: keyof typeof rows[0], value: any) => {
    // If internal counterparty is being selected, check account mapping
    if (field === 'internalId' && value) {
      const row = rows.find((r) => r.id === rowId);
      if (row && row.accountId) {
        const isValid = await checkMapping(row.accountId, value);
        if (!isValid) {
          return; // Don't update if mapping is invalid
        }

        // If mapping is valid, open modal for cash location selection
        const counterparty = counterparties.find((cp) => cp.counterpartyId === value);
        if (counterparty?.isInternal && counterparty?.linkedCompanyId) {
          openCashLocationModal(rowId, {
            counterpartyId: value,
            counterpartyName: counterparty.counterpartyName,
            linkedCompanyId: counterparty.linkedCompanyId,
          });
          return; // Don't update the row yet - wait for modal confirmation
        }
      }
    }

    updateRowField(rowId, field, value);
  };

  // Focus next field after account selection
  const focusNextFieldAfterAccount = (rowId: number, accountId: string) => {
    // Small delay to allow DOM to update
    setTimeout(() => {
      const row = rows.find((r) => r.id === rowId);
      if (!row) return;

      // If cash account, focus location
      if (isCashAccount(accountId)) {
        const locationInput = locationInputRefs.current[rowId];
        if (locationInput) {
          locationInput.focus();
          locationInput.click(); // Open dropdown
        }
      }
      // If payable/receivable account, focus internal counterparty
      else if (isPayableOrReceivable(accountId)) {
        const internalInput = internalInputRefs.current[rowId];
        if (internalInput) {
          internalInput.focus();
          internalInput.click(); // Open dropdown
        }
      }
      // Otherwise, focus detail field
      else {
        const detailInput = detailInputRefs.current[rowId];
        if (detailInput) {
          detailInput.focus();
        }
      }
    }, 100);
  };

  // Focus next field after location selection
  const focusNextFieldAfterLocation = (rowId: number) => {
    setTimeout(() => {
      const row = rows.find((r) => r.id === rowId);
      if (!row) return;

      // After location, go to detail
      const detailInput = detailInputRefs.current[rowId];
      if (detailInput) {
        detailInput.focus();
      }
    }, 100);
  };

  // Focus next field after internal counterparty selection
  const focusNextFieldAfterInternal = (rowId: number) => {
    setTimeout(() => {
      const row = rows.find((r) => r.id === rowId);
      if (!row) return;

      // After internal, go to detail
      const detailInput = detailInputRefs.current[rowId];
      if (detailInput) {
        detailInput.focus();
      }
    }, 100);
  };

  // Focus next field after external counterparty selection
  const focusNextFieldAfterExternal = (rowId: number) => {
    setTimeout(() => {
      const row = rows.find((r) => r.id === rowId);
      if (!row) return;

      // After external, go to detail
      const detailInput = detailInputRefs.current[rowId];
      if (detailInput) {
        detailInput.focus();
      }
    }, 100);
  };

  // Handle submit
  const handleSubmit = async () => {
    if (!isFormValid || submitting) return;

    const result = await submitExcelEntry(companyId, selectedStoreId, selectedDate, userId, accounts, counterparties);

    if (result.success) {
      // Trigger refresh of RecentTransactionHistory
      setRefreshTrigger(prev => prev + 1);
      if (onSubmitSuccess) {
        onSubmitSuccess();
      }
    } else {
      if (onSubmitError) {
        onSubmitError(result.error || 'Failed to submit journal entry');
      }
    }
  };

  // Handle template apply (with custom amount from detail panel)
  const handleApplyTemplate = (templateData: any, amount: number) => {
    // Apply template data to Excel rows with custom amount
    applyTemplateToRows(templateData, amount);
  };

  return (
    <div className={styles.container}>
      {/* Template Selector - above the Excel table */}
      <TemplateSelector
        templates={templates}
        loading={loadingTemplates}
        accounts={accounts.map((acc) => ({ accountId: acc.accountId, accountName: acc.accountName || acc.account_name || '' }))}
        stores={stores}
        selectedStoreId={templateStoreId}
        onStoreChange={handleTemplateStoreChange}
        onApplyTemplate={handleApplyTemplate}
      />

      <table className={styles.table}>
        <thead>
          <tr>
            <th>Store</th>
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
          {rows.map((row, index) => (
            <tr key={row.id}>
              {/* Store selector - only show on first row */}
              {index === 0 ? (
                <td rowSpan={rows.length} className={styles.storeCell}>
                  <div className={styles.storeSelectorWrapper}>
                    <TossSelector
                      value={selectedStoreId || ''}
                      options={stores.map(s => ({ value: s.store_id, label: s.store_name }))}
                      onChange={(value) => setSelectedStoreId(value || null)}
                      placeholder="Select store..."
                      searchable={true}
                      inline={false}
                      fullWidth={true}
                      emptyMessage="No stores available"
                    />
                  </div>
                </td>
              ) : null}
              {index === 0 ? (
                <td rowSpan={rows.length} className={styles.dateCell}>
                  <input
                    type="date"
                    className={styles.dateInput}
                    value={selectedDate}
                    onChange={(e) => setSelectedDate(e.target.value)}
                  />
                </td>
              ) : null}
              <td className={styles.selectorCell}>
                <TossSelector
                  ref={(el) => (accountInputRefs.current[row.id] = el)}
                  value={row.accountId}
                  options={accountOptions}
                  onChange={(value) => handleUpdateRowField(row.id, 'accountId', value)}
                  onSelect={(value) => focusNextFieldAfterAccount(row.id, value)}
                  placeholder="Select account..."
                  searchable={true}
                  inline={true}
                  fullWidth={true}
                  emptyMessage="No accounts available"
                />
              </td>
              <td
                className={`${styles.selectorCell} ${!isCashAccount(row.accountId) ? styles.disabled : ''}`}
              >
                <TossSelector
                  ref={(el) => (locationInputRefs.current[row.id] = el)}
                  value={row.locationId}
                  options={getLocationOptions(row.id)}
                  onChange={(value) => handleUpdateRowField(row.id, 'locationId', value)}
                  onSelect={() => focusNextFieldAfterLocation(row.id)}
                  placeholder="Select location..."
                  searchable={true}
                  inline={true}
                  fullWidth={true}
                  disabled={!isCashAccount(row.accountId)}
                  emptyMessage="No locations available"
                  showDescriptions={true}
                />
              </td>
              <td
                className={`${styles.selectorCell} ${(!isPayableOrReceivable(row.accountId) || row.externalId) ? styles.disabled : ''}`}
              >
                <div className={styles.counterpartyCell}>
                  <TossSelector
                    ref={(el) => (internalInputRefs.current[row.id] = el)}
                    value={row.internalId}
                    options={getCounterpartyOptions(true)}
                    onChange={(value) => handleUpdateRowField(row.id, 'internalId', value)}
                    onSelect={() => focusNextFieldAfterInternal(row.id)}
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
                        <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
                      </svg>
                    </button>
                  )}
                </div>
              </td>
              <td
                className={`${styles.selectorCell} ${(!isPayableOrReceivable(row.accountId) || row.internalId) ? styles.disabled : ''}`}
              >
                <div className={styles.counterpartyCell}>
                  <TossSelector
                    ref={(el) => (externalInputRefs.current[row.id] = el)}
                    value={row.externalId}
                    options={getCounterpartyOptions(false)}
                    onChange={(value) => handleUpdateRowField(row.id, 'externalId', value)}
                    onSelect={() => focusNextFieldAfterExternal(row.id)}
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
                        <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
                      </svg>
                    </button>
                  )}
                </div>
              </td>
              <td>
                <input
                  ref={(el) => (detailInputRefs.current[row.id] = el)}
                  type="text"
                  value={row.detail}
                  onChange={(e) => handleUpdateRowField(row.id, 'detail', e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') {
                      e.preventDefault();
                      const debitInput = debitInputRefs.current[row.id];
                      if (debitInput) {
                        debitInput.focus();
                        debitInput.select();
                      }
                    }
                  }}
                  placeholder="Enter detail..."
                />
              </td>
              <td>
                <input
                  ref={(el) => (debitInputRefs.current[row.id] = el)}
                  type="text"
                  inputMode="decimal"
                  value={formatNumber(row.debit)}
                  onChange={(e) => handleNumberChange(e.target.value, row.id, 'debit')}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') {
                      e.preventDefault();
                      // Check if credit is disabled (debit has value)
                      const hasDebitValue = !!row.debit && parseFloat(row.debit.replace(/,/g, '')) > 0;

                      if (hasDebitValue) {
                        // Credit is disabled, go to next row's account
                        const currentIndex = rows.findIndex((r) => r.id === row.id);
                        const nextRow = rows[currentIndex + 1];

                        if (nextRow) {
                          const nextAccountInput = accountInputRefs.current[nextRow.id];
                          if (nextAccountInput) {
                            nextAccountInput.focus();
                            nextAccountInput.click();
                          }
                        } else {
                          addRow();
                          setTimeout(() => {
                            const newRowId = rows[rows.length - 1].id + 1;
                            const newAccountInput = accountInputRefs.current[newRowId];
                            if (newAccountInput) {
                              newAccountInput.focus();
                              newAccountInput.click();
                            }
                          }, 100);
                        }
                      } else {
                        // No debit value, go to credit
                        const creditInput = creditInputRefs.current[row.id];
                        if (creditInput) {
                          creditInput.focus();
                          creditInput.select();
                        }
                      }
                    }
                  }}
                  disabled={!!row.credit && parseFloat(row.credit.replace(/,/g, '')) > 0}
                  placeholder="0"
                  style={{ textAlign: 'right' }}
                />
              </td>
              <td>
                <input
                  ref={(el) => (creditInputRefs.current[row.id] = el)}
                  type="text"
                  inputMode="decimal"
                  value={formatNumber(row.credit)}
                  onChange={(e) => handleNumberChange(e.target.value, row.id, 'credit')}
                  disabled={!!row.debit && parseFloat(row.debit.replace(/,/g, '')) > 0}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') {
                      e.preventDefault();
                      // Find next row
                      const currentIndex = rows.findIndex((r) => r.id === row.id);
                      const nextRow = rows[currentIndex + 1];

                      if (nextRow) {
                        // Focus next row's account field
                        const nextAccountInput = accountInputRefs.current[nextRow.id];
                        if (nextAccountInput) {
                          nextAccountInput.focus();
                          nextAccountInput.click(); // Open dropdown
                        }
                      } else {
                        // If no next row, add a new row
                        addRow();
                        // Focus on the new row after it's created
                        setTimeout(() => {
                          const newRowId = rows[rows.length - 1].id + 1;
                          const newAccountInput = accountInputRefs.current[newRowId];
                          if (newAccountInput) {
                            newAccountInput.focus();
                            newAccountInput.click();
                          }
                        }, 100);
                      }
                    }
                  }}
                  placeholder="0"
                  style={{ textAlign: 'right' }}
                />
              </td>
              <td>
                <button
                  className={styles.deleteButton}
                  onClick={() => deleteRow(row.id)}
                  disabled={rows.length <= 2}
                >
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" />
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
            <span
              className={`${styles.summaryValue} ${difference !== 0 ? styles.summaryError : styles.summarySuccess}`}
            >
              {formatNumber(Math.abs(difference).toString())}
            </span>
          </div>
        </div>
        <div className={styles.buttonGroup}>
          <button className={styles.addLineButton} onClick={addRow}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
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
        onClose={hideWarning}
        onConfirm={hideWarning}
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
          onConfirm={confirmCashLocationModal}
          onCancel={closeCashLocationModal}
        />
      )}

      {/* Recent Transaction History */}
      <RecentTransactionHistory
        companyId={companyId}
        stores={stores}
        refreshTrigger={refreshTrigger}
      />
    </div>
  );
};

export default ExcelTabContent;
