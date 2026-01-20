/**
 * CustomDatePickerModal Component
 * Modal for selecting custom date range
 */

import React, { forwardRef } from 'react';
import { formatDateDisplay } from '../../../hooks/useProductReceiveList';
import styles from '../ProductReceivePage.module.css';

interface CustomDatePickerModalProps {
  fromDate: string;
  toDate: string;
  onFromDateChange: (date: string) => void;
  onToDateChange: (date: string) => void;
  onToday: () => void;
  onCancel: () => void;
  onApply: () => void;
}

export const CustomDatePickerModal = forwardRef<HTMLDivElement, CustomDatePickerModalProps>(
  ({ fromDate, toDate, onFromDateChange, onToDateChange, onToday, onCancel, onApply }, ref) => {
    return (
      <div className={styles.datePickerOverlay}>
        <div className={styles.datePickerModal} ref={ref}>
          <div className={styles.datePickerHeader}>
            <span>From date: <strong>{formatDateDisplay(fromDate) || 'Select'}</strong></span>
            <span> - </span>
            <span>To date: <strong>{formatDateDisplay(toDate) || 'Select'}</strong></span>
          </div>

          <div className={styles.datePickerBody}>
            <div className={styles.calendarContainer}>
              <div className={styles.calendarSection}>
                <label className={styles.calendarLabel}>From Date</label>
                <input
                  type="date"
                  className={styles.calendarInput}
                  value={fromDate}
                  onChange={(e) => onFromDateChange(e.target.value)}
                />
              </div>
              <div className={styles.calendarSection}>
                <label className={styles.calendarLabel}>To Date</label>
                <input
                  type="date"
                  className={styles.calendarInput}
                  value={toDate}
                  onChange={(e) => onToDateChange(e.target.value)}
                />
              </div>
            </div>
          </div>

          <div className={styles.datePickerFooter}>
            <button className={styles.todayButton} onClick={onToday}>
              Today
            </button>
            <div className={styles.datePickerActions}>
              <button className={styles.cancelButton} onClick={onCancel}>
                Cancel
              </button>
              <button
                className={styles.applyButton}
                onClick={onApply}
                disabled={!fromDate || !toDate}
              >
                Apply
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }
);

CustomDatePickerModal.displayName = 'CustomDatePickerModal';
