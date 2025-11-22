/**
 * CashEndingErrorState Component
 * Error state display when loading fails
 */

import React from 'react';
import type { CashEndingErrorStateProps } from './CashEndingErrorState.types';
import styles from './CashEndingErrorState.module.css';

export const CashEndingErrorState: React.FC<CashEndingErrorStateProps> = ({ error }) => {
  return (
    <div className={styles.errorContainer}>
      <svg className={styles.errorIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
        {/* Background Circle */}
        <circle cx="60" cy="60" r="50" fill="#FFEFED" />
        {/* Error Symbol */}
        <circle cx="60" cy="60" r="30" fill="#FF5847" />
        <path d="M60 45 L60 65" stroke="white" strokeWidth="4" strokeLinecap="round" />
        <circle cx="60" cy="73" r="2.5" fill="white" />
        {/* Document Icon */}
        <rect x="40" y="25" width="40" height="50" rx="4" fill="white" stroke="#FF5847" strokeWidth="2" />
        <line x1="48" y1="35" x2="72" y2="35" stroke="#FFE5E5" strokeWidth="2" strokeLinecap="round" />
        <line x1="48" y1="42" x2="65" y2="42" stroke="#FFE5E5" strokeWidth="2" strokeLinecap="round" />
      </svg>
      <h2 className={styles.errorTitle}>Failed to Load Cash Endings</h2>
      <p className={styles.errorMessage}>{error}</p>
    </div>
  );
};
