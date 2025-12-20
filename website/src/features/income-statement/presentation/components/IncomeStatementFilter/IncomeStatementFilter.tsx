/**
 * IncomeStatementFilter Component
 * Filter component for Income Statement with Store, Type, and Date filters
 */

import React, { useState, useEffect } from 'react';
import { useAppState } from '@/app/providers/app_state_provider';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { TossButton } from '@/shared/components/toss/TossButton';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { IncomeStatementValidator } from '../../../domain/validators/IncomeStatementValidator';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import type { IncomeStatementFilterProps } from './IncomeStatementFilter.types';
import styles from './IncomeStatementFilter.module.css';

// Helper functions to get current month's first and last day
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

// Helper functions for 12-month view (full year)
const getFirstDayOfYear = (): string => {
  const now = new Date();
  const firstDay = new Date(now.getFullYear(), 0, 1); // January 1st
  return DateTimeUtils.toDateOnly(firstDay);
};

const getLastDayOfYear = (): string => {
  const now = new Date();
  const lastDay = new Date(now.getFullYear(), 11, 31); // December 31st
  return DateTimeUtils.toDateOnly(lastDay);
};

export const IncomeStatementFilter: React.FC<IncomeStatementFilterProps> = ({
  onSearch,
  onClear,
  className = '',
}) => {
  const { currentCompany } = useAppState();
  const stores = currentCompany?.stores || [];
  const { messageState, closeMessage, showWarning } = useErrorMessage();

  // Filter state
  const [storeId, setStoreId] = useState<string | null>(null);
  const [type, setType] = useState<'monthly' | '12month'>('monthly');
  const [fromDate, setFromDate] = useState<string>(getFirstDayOfMonth());
  const [toDate, setToDate] = useState<string>(getLastDayOfMonth());

  // Type options
  const typeOptions = [
    { value: 'monthly', label: 'Monthly' },
    { value: '12month', label: '12-Month View' },
  ];

  const handleSearch = () => {
    // Validate date range
    const dateRangeResult = IncomeStatementValidator.validateDateRange(fromDate, toDate);
    if (!dateRangeResult.isValid) {
      showWarning({
        title: 'Invalid Date Range',
        message: dateRangeResult.errors[0]?.message || 'Invalid date range',
        confirmText: 'OK',
      });
      return;
    }

    // Validate store ID if provided
    if (storeId) {
      const storeResult = IncomeStatementValidator.validateStoreId(storeId);
      if (!storeResult.isValid) {
        showWarning({
          title: 'Invalid Store',
          message: storeResult.errors[0]?.message || 'Invalid store ID',
          confirmText: 'OK',
        });
        return;
      }
    }

    // Validate statement type
    const typeResult = IncomeStatementValidator.validateStatementType(type);
    if (!typeResult.isValid) {
      showWarning({
        title: 'Invalid Type',
        message: typeResult.errors[0]?.message || 'Invalid statement type',
        confirmText: 'OK',
      });
      return;
    }

    // If validation passes, execute search
    onSearch({
      store: storeId,
      type,
      fromDate,
      toDate,
    });
  };

  const handleClear = () => {
    setStoreId(null);
    setType('monthly');
    setFromDate(getFirstDayOfMonth());
    setToDate(getLastDayOfMonth());
    onClear?.();
  };

  // Reset filters when company changes
  useEffect(() => {
    handleClear();
  }, [currentCompany?.company_id]);

  // Update date range when type changes
  useEffect(() => {
    if (type === '12month') {
      // 12-month view: set to full year (Jan 1 - Dec 31)
      setFromDate(getFirstDayOfYear());
      setToDate(getLastDayOfYear());
    } else {
      // Monthly view: set to current month
      setFromDate(getFirstDayOfMonth());
      setToDate(getLastDayOfMonth());
    }
  }, [type]);

  return (
    <div className={`${styles.filterContainer} ${className}`}>
      <div className={styles.filterHeader}>
        <div className={styles.filterTitle}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3" />
          </svg>
          <span>Search Income Statement</span>
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
            <label className={styles.filterLabel}>TYPE</label>
            <TossSelector
              id="income-type-filter"
              name="type"
              placeholder="Select type"
              value={type}
              options={typeOptions}
              onChange={(value) => setType(value as 'monthly' | '12month')}
              fullWidth
            />
          </div>

          <div className={styles.filterField}>
            <label className={styles.filterLabel}>FROM DATE</label>
            <input
              type="date"
              className={styles.dateInput}
              value={fromDate}
              onChange={(e) => setFromDate(e.target.value)}
              disabled={type === '12month'}
            />
          </div>

          <div className={styles.filterField}>
            <label className={styles.filterLabel}>TO DATE</label>
            <input
              type="date"
              className={styles.dateInput}
              value={toDate}
              onChange={(e) => setToDate(e.target.value)}
              disabled={type === '12month'}
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

export default IncomeStatementFilter;
