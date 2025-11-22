/**
 * CashEndingDifferenceItem Component
 * Single difference row with action buttons
 */

import React from 'react';
import type { CashEndingDifferenceItemProps } from './CashEndingDifferenceItem.types';
import styles from './CashEndingDifferenceItem.module.css';

export const CashEndingDifferenceItem: React.FC<CashEndingDifferenceItemProps> = ({
  cashEndingId,
  locationName,
  difference,
  formatCurrency,
  onMakeError,
  onExchangeTranslation,
}) => {
  const differenceClass =
    difference > 0
      ? styles.differencePositive
      : difference < 0
      ? styles.differenceNegative
      : styles.differenceZero;

  return (
    <div className={styles.differenceItem}>
      <div className={styles.differenceLocationName}>{locationName}</div>
      <div className={styles.differenceAmountActions}>
        <div className={`${styles.differenceAmount} ${differenceClass}`}>
          {difference > 0 ? '+' : ''}
          {formatCurrency(Math.abs(difference))}
        </div>
        <div className={styles.actionButtonsSimple}>
          <button
            className={`${styles.actionBtnSimple} ${styles.errorBtnSimple}`}
            onClick={onMakeError}
            disabled={difference === 0}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M13,14H11V10H13M13,18H11V16H13M1,21H23L12,2L1,21Z" />
            </svg>
            Make Error
          </button>
          <button
            className={`${styles.actionBtnSimple} ${styles.exchangeBtnSimple}`}
            onClick={onExchangeTranslation}
            disabled={difference === 0}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M17.9,17.39C17.64,16.59 16.89,16 16,16H15V13A1,1 0 0,0 14,12H8V10H10A1,1 0 0,0 11,9V7H13A2,2 0 0,0 15,5V4.59C17.93,5.77 20,8.64 20,12C20,14.08 19.2,15.97 17.9,17.39M11,19.93C7.05,19.44 4,16.08 4,12C4,11.38 4.08,10.78 4.21,10.21L9,15V16A2,2 0 0,0 11,18M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z" />
            </svg>
            Foreign Currency Translation
          </button>
        </div>
      </div>
    </div>
  );
};
