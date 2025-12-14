/**
 * DateFilterContent Component
 * Custom date filter content for the LeftFilter component
 */

import React from 'react';
import { formatDateDisplay } from '../../../hooks/useProductReceiveList';
import styles from '../ProductReceivePage.module.css';

type DatePreset = 'this_month' | 'last_month' | 'this_year' | 'custom';

interface DateFilterContentProps {
  datePreset: DatePreset;
  fromDate: string;
  toDate: string;
  onPresetChange: (preset: DatePreset) => void;
}

export const DateFilterContent: React.FC<DateFilterContentProps> = ({
  datePreset,
  fromDate,
  toDate,
  onPresetChange,
}) => {
  return (
    <div className={styles.dateFilterContent}>
      <label className={styles.datePresetOption}>
        <input
          type="radio"
          name="datePreset"
          checked={datePreset === 'this_month'}
          onChange={() => onPresetChange('this_month')}
          className={styles.radioInput}
        />
        <span className={styles.radioLabel}>This Month</span>
      </label>

      <label className={styles.datePresetOption}>
        <input
          type="radio"
          name="datePreset"
          checked={datePreset === 'last_month'}
          onChange={() => onPresetChange('last_month')}
          className={styles.radioInput}
        />
        <span className={styles.radioLabel}>Last Month</span>
      </label>

      <label className={styles.datePresetOption}>
        <input
          type="radio"
          name="datePreset"
          checked={datePreset === 'this_year'}
          onChange={() => onPresetChange('this_year')}
          className={styles.radioInput}
        />
        <span className={styles.radioLabel}>This Year</span>
      </label>

      <label className={styles.datePresetOption}>
        <input
          type="radio"
          name="datePreset"
          checked={datePreset === 'custom'}
          onChange={() => onPresetChange('custom')}
          className={styles.radioInput}
        />
        <div
          className={`${styles.customDateButton} ${datePreset === 'custom' ? styles.active : ''}`}
          onClick={(e) => {
            e.preventDefault();
            onPresetChange('custom');
          }}
        >
          <span>Custom</span>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19,19H5V8H19M16,1V3H8V1H6V3H5C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5C21,3.89 20.1,3 19,3H18V1M17,12H12V17H17V12Z" />
          </svg>
        </div>
      </label>

      {(fromDate || toDate) && (
        <div className={styles.selectedDateRange}>
          <span className={styles.dateRangeText}>
            {formatDateDisplay(fromDate)} ~ {formatDateDisplay(toDate)}
          </span>
        </div>
      )}
    </div>
  );
};
