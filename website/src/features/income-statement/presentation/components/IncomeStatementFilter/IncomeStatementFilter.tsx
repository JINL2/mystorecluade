/**
 * IncomeStatementFilter Component
 * Filter component for Income Statement with Store, Type, and Date filters
 */

import React, { useState, useEffect } from 'react';
import { useAppState } from '@/app/providers/app_state_provider';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { IncomeStatementFilterProps, IncomeStatementFilters, Store } from './IncomeStatementFilter.types';
import styles from './IncomeStatementFilter.module.css';

export const IncomeStatementFilter: React.FC<IncomeStatementFilterProps> = ({
  onSearch,
  onClear,
  onFilterChange,
  className = '',
}) => {
  const { currentCompany } = useAppState();

  // Get current date for default values
  const now = new Date();
  const currentMonth = now.toISOString().split('T')[0].substring(0, 7); // YYYY-MM
  const firstDayOfMonth = `${currentMonth}-01`;
  const lastDayOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0)
    .toISOString()
    .split('T')[0];

  // Filter state
  const [filters, setFilters] = useState<IncomeStatementFilters>({
    store: null,
    type: 'monthly',
    fromDate: firstDayOfMonth,
    toDate: lastDayOfMonth,
  });

  // Store options
  const [stores, setStores] = useState<Store[]>([]);

  // Load stores when company changes
  useEffect(() => {
    if (currentCompany?.stores) {
      setStores(currentCompany.stores);
    } else {
      setStores([]);
    }
  }, [currentCompany]);

  // Store options for TossSelector
  const storeOptions = [
    { value: '', label: 'All Stores' },
    ...stores.map(store => ({
      value: store.store_id,
      label: store.store_name,
    })),
  ];

  // Type options
  const typeOptions = [
    { value: 'monthly', label: 'Monthly' },
    { value: '12month', label: '12-Month View' },
  ];

  // Handle filter changes
  const handleFilterChange = (field: keyof IncomeStatementFilters, value: any) => {
    const newFilters = {
      ...filters,
      [field]: value === '' ? null : value,
    };
    setFilters(newFilters);
    onFilterChange?.(newFilters);
  };

  // Handle search
  const handleSearch = () => {
    onSearch(filters);
  };

  // Handle clear
  const handleClear = () => {
    const resetFilters: IncomeStatementFilters = {
      store: null,
      type: 'monthly',
      fromDate: firstDayOfMonth,
      toDate: lastDayOfMonth,
    };
    setFilters(resetFilters);
    onClear?.();
  };

  // Reset filters when company changes
  useEffect(() => {
    handleClear();
  }, [currentCompany?.company_id]);

  return (
    <div className={`${styles.filterContainer} ${className}`}>
      <div className={styles.filterHeader}>
        <h3 className={styles.filterTitle}>Filters</h3>
      </div>

      <div className={styles.filterGrid}>
        {/* Store Filter */}
        <div className={styles.filterGroup}>
          <label className={styles.filterLabel}>Store</label>
          <TossSelector
            id="income-store-filter"
            name="store"
            placeholder="Select store"
            value={filters.store || ''}
            options={storeOptions}
            onChange={(value) => handleFilterChange('store', value)}
            fullWidth
          />
        </div>

        {/* Type Filter */}
        <div className={styles.filterGroup}>
          <label className={`${styles.filterLabel} ${styles.required}`}>Type</label>
          <TossSelector
            id="income-type-filter"
            name="type"
            placeholder="Select type"
            value={filters.type}
            options={typeOptions}
            onChange={(value) => handleFilterChange('type', value as 'monthly' | '12month')}
            fullWidth
            required
          />
        </div>

        {/* From Date Filter */}
        <div className={styles.filterGroup}>
          <label className={styles.filterLabel}>From Date</label>
          <input
            type="date"
            className={styles.dateInput}
            value={filters.fromDate}
            onChange={(e) => handleFilterChange('fromDate', e.target.value)}
            disabled={filters.type === '12month'}
          />
        </div>

        {/* To Date Filter */}
        <div className={styles.filterGroup}>
          <label className={styles.filterLabel}>To Date</label>
          <input
            type="date"
            className={styles.dateInput}
            value={filters.toDate}
            onChange={(e) => handleFilterChange('toDate', e.target.value)}
            disabled={filters.type === '12month'}
          />
        </div>
      </div>

      <div className={styles.filterActions}>
        <TossButton
          variant="secondary"
          size="md"
          onClick={handleClear}
        >
          Clear
        </TossButton>
        <TossButton
          variant="primary"
          size="md"
          onClick={handleSearch}
        >
          Search
        </TossButton>
      </div>
    </div>
  );
};

export default IncomeStatementFilter;
