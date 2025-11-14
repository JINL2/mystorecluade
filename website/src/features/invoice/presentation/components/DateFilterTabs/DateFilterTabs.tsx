/**
 * DateFilterTabs Component
 * Date filter tabs for invoice filtering (Today, Yesterday, This Week, etc.)
 */

import React, { useState } from 'react';
import type { DateFilterTabsProps, DateFilterType } from './DateFilterTabs.types';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import styles from './DateFilterTabs.module.css';

export const DateFilterTabs: React.FC<DateFilterTabsProps> = ({
  activeFilter,
  onFilterChange,
}) => {
  const [showCustomPicker, setShowCustomPicker] = useState(false);
  const [customStart, setCustomStart] = useState('');
  const [customEnd, setCustomEnd] = useState('');

  const handleTabClick = (filter: DateFilterType) => {
    if (filter === 'custom') {
      setShowCustomPicker(true);
      return;
    }

    const { start, end } = calculateDateRange(filter);
    onFilterChange(filter, start, end);
  };

  const calculateDateRange = (filter: DateFilterType): { start: string; end: string } => {
    const today = new Date();
    let start: Date;
    let end: Date = new Date(today);

    switch (filter) {
      case 'all':
        // Set to a very old date (e.g., 10 years ago) to get all records
        start = new Date(today.getFullYear() - 10, 0, 1);
        break;
      case 'today':
        start = new Date(today);
        break;
      case 'yesterday':
        start = new Date(today);
        start.setDate(today.getDate() - 1);
        end = new Date(start);
        break;
      case 'this-week':
        start = new Date(today);
        const day = today.getDay();
        const diff = day === 0 ? -6 : 1 - day; // Monday as first day
        start.setDate(today.getDate() + diff);
        break;
      case 'this-month':
        start = new Date(today.getFullYear(), today.getMonth(), 1);
        break;
      case 'last-month':
        start = new Date(today.getFullYear(), today.getMonth() - 1, 1);
        end = new Date(today.getFullYear(), today.getMonth(), 0);
        break;
      default:
        start = new Date(today);
    }

    // Use DateTimeUtils.toDateOnly() to avoid timezone issues
    // This ensures the date string is always in local timezone (yyyy-MM-dd)
    return {
      start: DateTimeUtils.toDateOnly(start),
      end: DateTimeUtils.toDateOnly(end),
    };
  };

  const handleCustomApply = () => {
    if (customStart && customEnd) {
      onFilterChange('custom', customStart, customEnd);
      setShowCustomPicker(false);
    }
  };

  const tabs: Array<{ id: DateFilterType; label: string }> = [
    { id: 'all', label: 'All' },
    { id: 'today', label: 'Today' },
    { id: 'yesterday', label: 'Yesterday' },
    { id: 'this-week', label: 'This Week' },
    { id: 'this-month', label: 'This Month' },
    { id: 'last-month', label: 'Last Month' },
    { id: 'custom', label: 'Custom Range' },
  ];

  return (
    <div className={styles.container}>
      <div className={styles.tabsWrapper}>
        {tabs.map((tab) => (
          <button
            key={tab.id}
            className={`${styles.tab} ${activeFilter === tab.id ? styles.active : ''}`}
            onClick={() => handleTabClick(tab.id)}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {showCustomPicker && (
        <div className={styles.customPicker}>
          <div className={styles.customPickerContent}>
            <div className={styles.customPickerHeader}>
              <h3>Custom Date Range</h3>
              <button
                className={styles.closeButton}
                onClick={() => setShowCustomPicker(false)}
              >
                ✕
              </button>
            </div>
            <div className={styles.customPickerBody}>
              <div className={styles.dateInput}>
                <label>Start Date</label>
                <input
                  type="date"
                  value={customStart}
                  onChange={(e) => setCustomStart(e.target.value)}
                />
              </div>
              <div className={styles.dateInput}>
                <label>End Date</label>
                <input
                  type="date"
                  value={customEnd}
                  onChange={(e) => setCustomEnd(e.target.value)}
                />
              </div>
            </div>
            <div className={styles.customPickerFooter}>
              <button
                className={styles.cancelButton}
                onClick={() => setShowCustomPicker(false)}
              >
                Cancel
              </button>
              <button
                className={styles.applyButton}
                onClick={handleCustomApply}
                disabled={!customStart || !customEnd}
              >
                Apply
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default DateFilterTabs;
