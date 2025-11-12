/**
 * TransactionFilter Component
 * Search filter for transaction history with validation
 */

import React, { useState } from 'react';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { TossButton } from '@/shared/components/toss/TossButton';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { useAppState } from '@/app/providers/app_state_provider';
import { TransactionFilterValidator } from '../../../domain/validators/TransactionFilterValidator';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import styles from './TransactionFilter.module.css';

export interface TransactionFilterValues {
  storeId: string | null;
  fromDate: string;
  toDate: string;
}

interface TransactionFilterProps {
  onSearch: (filters: TransactionFilterValues) => void;
  onClear: () => void;
}

// Helper functions to get current month's first and last day
// Uses DateTimeUtils to avoid timezone-related date shifting
const getFirstDayOfMonth = (): string => {
  const now = new Date();
  const firstDay = new Date(now.getFullYear(), now.getMonth(), 1);
  return DateTimeUtils.toDateOnly(firstDay);
};

const getLastDayOfMonth = (): string => {
  const now = new Date();
  const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0);
  return DateTimeUtils.toDateOnly(lastDay);
};

export const TransactionFilter: React.FC<TransactionFilterProps> = ({ onSearch, onClear }) => {
  const { currentCompany } = useAppState();
  const stores = currentCompany?.stores || [];
  const { messageState, closeMessage, showWarning } = useErrorMessage();

  const [storeId, setStoreId] = useState<string | null>(null);
  const [fromDate, setFromDate] = useState<string>(getFirstDayOfMonth());
  const [toDate, setToDate] = useState<string>(getLastDayOfMonth());

  const handleSearch = () => {
    // Validate date range
    const dateRangeError = TransactionFilterValidator.validateDateRange(fromDate, toDate);
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
      const storeError = TransactionFilterValidator.validateStoreId(storeId);
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
    onSearch({ storeId, fromDate, toDate });
  };

  const handleClear = () => {
    setStoreId(null);
    setFromDate(getFirstDayOfMonth());
    setToDate(getLastDayOfMonth());
    onClear();
  };

  return (
    <div className={styles.filterContainer}>
      <div className={styles.filterHeader}>
        <div className={styles.filterTitle}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3" />
          </svg>
          <span>Search Transactions</span>
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
                showAllStoresOption={true}
                width="100%"
              />
            </div>

            <div className={styles.filterField}>
              <label className={styles.filterLabel}>FROM DATE</label>
              <input
                type="date"
                className={styles.dateInput}
                value={fromDate}
                onChange={(e) => setFromDate(e.target.value)}
              />
            </div>

            <div className={styles.filterField}>
              <label className={styles.filterLabel}>TO DATE</label>
              <input
                type="date"
                className={styles.dateInput}
                value={toDate}
                onChange={(e) => setToDate(e.target.value)}
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
