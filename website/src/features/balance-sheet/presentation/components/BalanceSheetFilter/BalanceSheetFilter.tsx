/**
 * BalanceSheetFilter Component
 * Filter component for balance sheet with store and date range selection
 */

import { useState } from 'react';
import { useAppState } from '@/app/providers/app_state_provider';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector/StoreSelector';
import { TossButton } from '@/shared/components/toss/TossButton';
import { BalanceSheetFilterProps } from './BalanceSheetFilter.types';
import styles from './BalanceSheetFilter.module.css';

export const BalanceSheetFilter = ({ onSearch, onClear }: BalanceSheetFilterProps) => {
  const { currentCompany } = useAppState();
  const [selectedStoreId, setSelectedStoreId] = useState<string | null>(null);

  // Get first and last day of current month in local time
  const getDefaultDates = () => {
    const now = new Date();
    const firstDay = new Date(now.getFullYear(), now.getMonth(), 1);
    const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0);

    // Format as YYYY-MM-DD
    const formatDate = (date: Date) => {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    };

    return {
      start: formatDate(firstDay),
      end: formatDate(lastDay),
    };
  };

  const defaultDates = getDefaultDates();
  const [startDate, setStartDate] = useState<string>(defaultDates.start);
  const [endDate, setEndDate] = useState<string>(defaultDates.end);

  const handleSearch = () => {
    onSearch({
      storeId: selectedStoreId,
      startDate: startDate || null,
      endDate: endDate || null,
    });
  };

  const handleClear = () => {
    setSelectedStoreId(null);
    const defaultDates = getDefaultDates();
    setStartDate(defaultDates.start);
    setEndDate(defaultDates.end);
    onClear();
  };

  return (
    <div className={styles.filterContainer}>
      <div className={styles.filterHeader}>
        <h3 className={styles.filterTitle}>Filters</h3>
      </div>

      <div className={styles.filterContent}>
        {/* Store Selector */}
        <div className={styles.filterField}>
          <label className={styles.fieldLabel}>Store</label>
          <StoreSelector
            stores={currentCompany?.stores || []}
            selectedStoreId={selectedStoreId}
            onStoreSelect={setSelectedStoreId}
            companyId={currentCompany?.company_id || ''}
            showAllStoresOption={true}
            allStoresLabel="All Stores"
            width="100%"
          />
        </div>

        {/* From Date */}
        <div className={styles.filterField}>
          <label className={styles.fieldLabel}>From Date</label>
          <input
            type="date"
            className={styles.dateInput}
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            placeholder="Select start date"
            lang="en"
          />
        </div>

        {/* To Date */}
        <div className={styles.filterField}>
          <label className={styles.fieldLabel}>To Date</label>
          <input
            type="date"
            className={styles.dateInput}
            value={endDate}
            onChange={(e) => setEndDate(e.target.value)}
            placeholder="Select end date"
            lang="en"
          />
        </div>
      </div>

      {/* Action Buttons */}
      <div className={styles.filterActions}>
        <TossButton variant="secondary" size="md" onClick={handleClear}>
          Clear All
        </TossButton>
        <TossButton variant="primary" size="md" onClick={handleSearch}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style={{ marginRight: '8px' }}>
            <path d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z"/>
          </svg>
          Search
        </TossButton>
      </div>
    </div>
  );
};
