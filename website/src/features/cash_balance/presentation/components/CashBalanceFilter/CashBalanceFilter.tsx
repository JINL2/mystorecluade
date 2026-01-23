/**
 * CashBalanceFilter Component
 * Filter component for cash balance with store, date range, and location type selection
 */

import React, { useState } from 'react';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector/StoreSelector';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { CashBalanceFilterProps } from './CashBalanceFilter.types';
import styles from './CashBalanceFilter.module.css';

const LOCATION_TYPES = [
  { id: 'cash', label: 'Cash', icon: '💵' },
  { id: 'vault', label: 'Vault', icon: '🔐' },
  { id: 'bank', label: 'Bank', icon: '🏦' },
  { id: 'digital_wallet', label: 'Digital', icon: '📱' },
];

// Get default date range (last 7 days)
const getDefaultDateRange = () => {
  const end = new Date();
  const start = new Date();
  start.setDate(start.getDate() - 7);

  return {
    startDate: start.toISOString().split('T')[0],
    endDate: end.toISOString().split('T')[0],
  };
};

export const CashBalanceFilter: React.FC<CashBalanceFilterProps> = ({
  stores = [],
  onSearch,
  onClear,
}) => {
  const defaultDates = getDefaultDateRange();

  const [storeId, setStoreId] = useState<string | null>(null);
  const [startDate, setStartDate] = useState(defaultDates.startDate);
  const [endDate, setEndDate] = useState(defaultDates.endDate);
  const [selectedTypes, setSelectedTypes] = useState<string[]>(['cash', 'vault', 'bank', 'digital_wallet']);

  const handleTypeToggle = (typeId: string) => {
    setSelectedTypes(prev => {
      if (prev.includes(typeId)) {
        // Don't allow deselecting all
        if (prev.length === 1) return prev;
        return prev.filter(t => t !== typeId);
      }
      return [...prev, typeId];
    });
  };

  const handleSearch = () => {
    onSearch({
      storeId,
      startDate,
      endDate,
      locationTypes: selectedTypes,
    });
  };

  const handleClear = () => {
    const defaults = getDefaultDateRange();
    setStoreId(null);
    setStartDate(defaults.startDate);
    setEndDate(defaults.endDate);
    setSelectedTypes(['cash', 'vault', 'bank', 'digital_wallet']);
    onClear();
  };

  return (
    <div className={styles.filterContainer}>
      <div className={styles.filterHeader}>
        <div className={styles.filterTitle}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3" />
          </svg>
          <span>Filter Cash Balance</span>
        </div>
      </div>

      <div className={styles.filterContent}>
        <div className={styles.filterRow}>
          {/* Store Selector */}
          <div className={styles.filterField}>
            <label className={styles.filterLabel}>STORE</label>
            <StoreSelector
              stores={stores}
              selectedStoreId={storeId}
              onStoreSelect={setStoreId}
              companyId=""
              showAllStoresOption={true}
              allStoresLabel="All Stores"
              width="100%"
            />
          </div>

          {/* Start Date */}
          <div className={styles.filterField}>
            <label className={styles.filterLabel}>START DATE</label>
            <input
              type="date"
              className={styles.dateInput}
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
            />
          </div>

          {/* End Date */}
          <div className={styles.filterField}>
            <label className={styles.filterLabel}>END DATE</label>
            <input
              type="date"
              className={styles.dateInput}
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
            />
          </div>

          {/* Location Types */}
          <div className={styles.filterField}>
            <label className={styles.filterLabel}>LOCATION TYPE</label>
            <div className={styles.chipGroup}>
              {LOCATION_TYPES.map(type => (
                <button
                  key={type.id}
                  className={`${styles.chip} ${selectedTypes.includes(type.id) ? styles.active : ''}`}
                  onClick={() => handleTypeToggle(type.id)}
                >
                  <span>{type.icon}</span>
                  <span>{type.label}</span>
                </button>
              ))}
            </div>
          </div>
        </div>

        <div className={styles.filterActions}>
          <TossButton onClick={handleClear} variant="secondary">
            Clear
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
    </div>
  );
};

export default CashBalanceFilter;
