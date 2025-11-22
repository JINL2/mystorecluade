/**
 * CashEndingEmptyState Component
 * Empty state display when no cash endings exist
 */

import React from 'react';
import styles from './CashEndingEmptyState.module.css';

export const CashEndingEmptyState: React.FC = () => {
  return (
    <div className={styles.emptyState}>
      <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
        {/* Background Circle */}
        <circle cx="60" cy="60" r="50" fill="#F0F6FF" />
        {/* Cash Stack */}
        <ellipse cx="60" cy="45" rx="25" ry="8" fill="white" stroke="#0064FF" strokeWidth="2" />
        <path
          d="M35 45 V55 C35 58 45 61 60 61 C75 61 85 58 85 55 V45"
          fill="white"
          stroke="#0064FF"
          strokeWidth="2"
        />
        <path
          d="M35 55 V65 C35 68 45 71 60 71 C75 71 85 68 85 65 V55"
          fill="white"
          stroke="#0064FF"
          strokeWidth="2"
        />
        {/* Dollar Sign */}
        <circle cx="60" cy="80" r="12" fill="#0064FF" />
        <path
          d="M58 74 L58 86 M62 74 L62 86 M56 77 L60 77 C61.5 77 63 78 63 80 C63 82 61.5 83 60 83 L56 83 M60 83 L64 83 C65.5 83 67 82 67 80"
          stroke="white"
          strokeWidth="2"
          strokeLinecap="round"
        />
      </svg>
      <h3 className={styles.emptyTitle}>No Cash Endings</h3>
      <p className={styles.emptyText}>No cash ending records found for the selected period</p>
    </div>
  );
};
