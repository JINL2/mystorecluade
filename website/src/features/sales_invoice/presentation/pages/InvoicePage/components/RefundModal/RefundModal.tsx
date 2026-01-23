/**
 * RefundModal Component
 * Modal for confirming invoice refunds with notes
 */

import React, { useState } from 'react';
import type { RefundModalProps } from './RefundModal.types';
import styles from './RefundModal.module.css';

export const RefundModal: React.FC<RefundModalProps> = ({
  isOpen,
  selectedInvoices,
  onClose,
  onConfirm,
  isRefunding = false,
}) => {
  const [notes, setNotes] = useState('');

  if (!isOpen) return null;

  // Calculate total refund amount
  const totalAmount = selectedInvoices.reduce((sum, invoice) => sum + invoice.amount, 0);
  const currencySymbol = selectedInvoices[0]?.currencySymbol || '';

  const formatCurrency = (amount: number) => {
    return `${currencySymbol}${amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  };

  const handleConfirm = () => {
    onConfirm(notes);
  };

  const handleOverlayClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  return (
    <div className={styles.overlay} onClick={handleOverlayClick}>
      <div className={styles.modal}>
        <div className={styles.header}>
          <h2 className={styles.title}>Refund Invoices</h2>
          <button className={styles.closeButton} onClick={onClose} disabled={isRefunding}>
            <svg fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        <div className={styles.body}>
          <div className={styles.section}>
            <h3 className={styles.sectionTitle}>
              Invoices ({selectedInvoices.length})
            </h3>
            <div className={styles.invoiceList}>
              {selectedInvoices.map((invoice) => (
                <div key={invoice.invoiceNumber} className={styles.invoiceItem}>
                  <span className={styles.invoiceNumber}>{invoice.invoiceNumber}</span>
                  <span className={styles.invoiceAmount}>{formatCurrency(invoice.amount)}</span>
                </div>
              ))}
            </div>
          </div>

          <div className={styles.section}>
            <label htmlFor="refund-notes" className={styles.notesLabel}>
              Notes
            </label>
            <textarea
              id="refund-notes"
              className={styles.notesTextarea}
              placeholder="Add notes (optional)"
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              disabled={isRefunding}
            />
            <div className={styles.totalAmount}>
              Total: <strong>{formatCurrency(totalAmount)}</strong>
            </div>
          </div>
        </div>

        <div className={styles.footer}>
          <button
            className={styles.cancelButton}
            onClick={onClose}
            disabled={isRefunding}
          >
            Cancel
          </button>
          <button
            className={styles.refundButton}
            onClick={handleConfirm}
            disabled={isRefunding}
          >
            {isRefunding ? 'Refunding...' : 'Refund'}
          </button>
        </div>
      </div>
    </div>
  );
};
