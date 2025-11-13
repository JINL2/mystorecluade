/**
 * BalanceSheetFilter Component
 * Filter component for balance sheet with store and date range selection
 *
 * Following Clean Architecture and 2025 Best Practice:
 * - Uses Provider state instead of local useState (ARCHITECTURE.md compliance)
 * - Feature-specific UI state managed in Zustand Provider
 * - Receives stores and companyId as props from parent
 */

import React from 'react';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector/StoreSelector';
import { TossButton } from '@/shared/components/toss/TossButton';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { BalanceSheetValidator } from '../../../domain/validators/BalanceSheetValidator';
import { useBalanceSheet } from '../../hooks/useBalanceSheet';
import { BalanceSheetFilterProps } from './BalanceSheetFilter.types';
import styles from './BalanceSheetFilter.module.css';

export const BalanceSheetFilter: React.FC<BalanceSheetFilterProps> = ({
  stores = [],
  companyId,
  onSearch,
  onClear,
}) => {
  const { messageState, closeMessage, showWarning } = useErrorMessage();

  // Use Provider state instead of local useState (ARCHITECTURE.md compliance)
  const { storeId, startDate, endDate, setStoreId, setStartDate, setEndDate } = useBalanceSheet();

  const handleSearch = () => {
    // Validate date range
    const dateRangeError = BalanceSheetValidator.validateDateRange(startDate, endDate);
    if (dateRangeError) {
      showWarning({
        title: 'Invalid Date Range',
        message: dateRangeError.message,
        confirmText: 'OK',
      });
      return;
    }

    // Validate store ID if provided
    if (storeId) {
      const storeError = BalanceSheetValidator.validateStoreId(storeId);
      if (storeError) {
        showWarning({
          title: 'Invalid Store',
          message: storeError.message,
          confirmText: 'OK',
        });
        return;
      }
    }

    // If validation passes, execute search
    onSearch({
      storeId,
      startDate: startDate || null,
      endDate: endDate || null,
    });
  };

  const handleClear = () => {
    // clearFilters already resets to first/last day of month (Provider logic)
    onClear();
  };

  return (
    <div className={styles.filterContainer}>
      <div className={styles.filterHeader}>
        <div className={styles.filterTitle}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3" />
          </svg>
          <span>Search Balance Sheet</span>
        </div>
      </div>

      <div className={styles.filterContent}>
        <div className={styles.filterRow}>
          <div className={styles.filterField}>
            <label className={styles.filterLabel}>STORE</label>
            <StoreSelector
              stores={stores}
              selectedStoreId={storeId}
              onStoreSelect={setStoreId}
              companyId={companyId || ''}
              showAllStoresOption={true}
              allStoresLabel="All Stores"
              width="100%"
            />
          </div>

          <div className={styles.filterField}>
            <label className={styles.filterLabel}>FROM DATE</label>
            <input
              type="date"
              className={styles.dateInput}
              value={startDate || ''}
              onChange={(e) => setStartDate(e.target.value)}
            />
          </div>

          <div className={styles.filterField}>
            <label className={styles.filterLabel}>TO DATE</label>
            <input
              type="date"
              className={styles.dateInput}
              value={endDate || ''}
              onChange={(e) => setEndDate(e.target.value)}
            />
          </div>
        </div>

        <div className={styles.filterActions}>
          <TossButton onClick={handleClear} variant="secondary">
            Clear All
          </TossButton>
          <TossButton onClick={handleSearch} variant="primary">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="11" cy="11" r="8" />
              <path d="m21 21-4.35-4.35" />
            </svg>
            Search
          </TossButton>
        </div>
      </div>

      {/* Validation Error Dialog */}
      <ErrorMessage
        variant={messageState.variant}
        title={messageState.title}
        message={messageState.message}
        isOpen={messageState.isOpen}
        onClose={closeMessage}
        confirmText={messageState.confirmText || 'OK'}
      />
    </div>
  );
};
