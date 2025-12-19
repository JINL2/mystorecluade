/**
 * CustomDatePickerModal Component
 * Modal for selecting custom date range
 */

import React from 'react';
import { formatDateDisplay } from '../../../hooks/useProductReceiveList';
import styles from '../ProductReceivePage.module.css';

interface CustomDatePickerModalProps {
  isOpen: boolean;
  tempFromDate: string;
  tempToDate: string;
  datePickerRef: React.RefObject<HTMLDivElement>;
  onFromDateChange: (date: string) => void;
  onToDateChange: (date: string) => void;
  onSetToday: () => void;
  onCancel: () => void;
  onApply: () => void;
}

export const CustomDatePickerModal: React.FC<CustomDatePickerModalProps> = ({
  isOpen,
  tempFromDate,
  tempToDate,
  datePickerRef,
  onFromDateChange,
  onToDateChange,
  onSetToday,
  onCancel,
  onApply,
}) => {
  if (!isOpen) return null;

  return (
    <div className={styles.datePickerOverlay}>
      <div className={styles.datePickerModal} ref={datePickerRef}>
        <div className={styles.datePickerHeader}>
          <span>From date: <strong>{formatDateDisplay(tempFromDate) || 'Select'}</strong></span>
          <span> - </span>
          <span>To date: <strong>{formatDateDisplay(tempToDate) || 'Select'}</strong></span>
        </div>

        <div className={styles.datePickerBody}>
          <div className={styles.calendarContainer}>
            <div className={styles.calendarSection}>
              <label className={styles.calendarLabel}>From Date</label>
              <input
                type="date"
                className={styles.calendarInput}
                value={tempFromDate}
                onChange={(e) => onFromDateChange(e.target.value)}
              />
            </div>
            <div className={styles.calendarSection}>
              <label className={styles.calendarLabel}>To Date</label>
              <input
                type="date"
                className={styles.calendarInput}
                value={tempToDate}
                onChange={(e) => onToDateChange(e.target.value)}
              />
            </div>
          </div>
        </div>

        <div className={styles.datePickerFooter}>
          <button className={styles.todayButton} onClick={onSetToday}>
            Today
          </button>
          <div className={styles.datePickerActions}>
            <button className={styles.cancelButton} onClick={onCancel}>
              Cancel
            </button>
            <button
              className={styles.applyButton}
              onClick={onApply}
              disabled={!tempFromDate || !tempToDate}
            >
              Apply
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
