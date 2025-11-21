/**
 * InvoiceHeader Component
 * Search bar and action buttons for invoice page
 */

import React from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { InvoiceHeaderProps } from './InvoiceHeader.types';
import styles from './InvoiceHeader.module.css';

export const InvoiceHeader: React.FC<InvoiceHeaderProps> = ({
  localSearchQuery,
  onSearchChange,
  selectedInvoicesCount,
  onRefund,
  onNewInvoice,
}) => {
  return (
    <div className={styles.searchActionsContainer}>
      <div className={styles.searchSection}>
        <h2 className={styles.sectionTitle}>Invoices</h2>
        <div className={styles.searchWrapper}>
          <svg className={styles.searchIcon} fill="currentColor" viewBox="0 0 24 24">
            <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
          </svg>
          <input
            type="text"
            className={styles.searchInput}
            placeholder="Search invoices..."
            value={localSearchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
          />
          {localSearchQuery && (
            <button className={styles.searchClear} onClick={() => onSearchChange('')}>
              <svg fill="currentColor" viewBox="0 0 24 24" width="16" height="16">
                <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
              </svg>
            </button>
          )}
        </div>
      </div>

      <div className={styles.actionsSection}>
        <TossButton
          variant="secondary"
          size="md"
          onClick={onRefund}
          disabled={selectedInvoicesCount === 0}
          icon={
            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12.5,8C9.85,8 7.45,9 5.6,10.6L2,7V16H11L7.38,12.38C8.77,11.22 10.54,10.5 12.5,10.5C16.04,10.5 19.05,12.81 20.1,16L22.47,15.22C21.08,11.03 17.15,8 12.5,8Z"/>
            </svg>
          }
          iconPosition="left"
        >
          Refund
        </TossButton>
        <TossButton
          variant="primary"
          size="md"
          onClick={onNewInvoice}
          icon={
            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
            </svg>
          }
          iconPosition="left"
        >
          New Invoice
        </TossButton>
      </div>
    </div>
  );
};
