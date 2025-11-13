/**
 * IconTabContent Component
 * Icon-based journal entry input with transaction cards
 */

import React from 'react';
import { TossButton } from '@/shared/components/toss/TossButton';
import { formatCurrency, formatCategoryTag } from '@/core/utils/formatters';
import type { IconTabContentProps } from './IconTabContent.types';
import styles from './IconTabContent.module.css';

export const IconTabContent: React.FC<IconTabContentProps> = ({
  journalEntry,
  submitting,
  onAddTransaction,
  onEditTransaction,
  onDeleteTransaction,
  onSubmit,
}) => {
  // Get submit button text based on state
  const getSubmitButtonText = () => {
    if (journalEntry.transactionLines.length === 0) return 'Add transactions to submit';
    if (!journalEntry.isBalanced) return 'Balance debits and credits';
    return 'Submit Journal Entry';
  };

  const handleAddDebit = () => {
    onAddTransaction();
  };

  const handleAddCredit = () => {
    onAddTransaction();
  };

  return (
    <>
      {/* Balance Summary */}
      <div className={styles.balanceSummaryCard}>
        <div className={styles.balanceSummaryGrid}>
          <div className={`${styles.balanceItem} ${styles.clickable}`} onClick={handleAddDebit}>
            <div className={styles.balanceLabel}>Debits</div>
            <div className={`${styles.balanceAmount} ${styles.debit}`}>
              {formatCurrency(journalEntry.totalDebits)}
            </div>
            <div className={styles.balanceCount}>{journalEntry.debitCount} items</div>
          </div>
          <div className={styles.balanceDivider}></div>
          <div className={`${styles.balanceItem} ${styles.clickable}`} onClick={handleAddCredit}>
            <div className={styles.balanceLabel}>Credits</div>
            <div className={`${styles.balanceAmount} ${styles.credit}`}>
              {formatCurrency(journalEntry.totalCredits)}
            </div>
            <div className={styles.balanceCount}>{journalEntry.creditCount} items</div>
          </div>
          <div className={styles.balanceDivider}></div>
          <div className={styles.balanceItem}>
            <div className={styles.balanceLabel}>Difference</div>
            <div
              className={`${styles.balanceAmount} ${styles.difference} ${
                !journalEntry.isBalanced ? styles.unbalanced : ''
              }`}
            >
              {formatCurrency(Math.abs(journalEntry.difference))}
            </div>
            <div className={styles.balanceCount}>&nbsp;</div>
          </div>
        </div>
      </div>

      {/* Description Input */}
      <div className={styles.descriptionCard}>
        <label className={styles.descriptionLabel} htmlFor="journalDescription">
          Description (Optional)
        </label>
        <textarea
          id="journalDescription"
          className={styles.descriptionTextarea}
          rows={2}
          placeholder="Enter journal description..."
        />
      </div>

      {/* Transaction Lines */}
      <div className={styles.transactionSection}>
        {journalEntry.transactionLines.length === 0 ? (
          <div className={styles.emptyState}>
            <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
              {/* Background Circle */}
              <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

              {/* Document Stack */}
              <rect x="35" y="40" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
              <rect x="40" y="35" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>

              {/* Document Lines */}
              <line x1="48" y1="45" x2="75" y2="45" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="48" y1="52" x2="70" y2="52" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="48" y1="59" x2="72" y2="59" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

              {/* Plus Symbol */}
              <circle cx="60" cy="75" r="12" fill="#0064FF"/>
              <path d="M56 75 H64 M60 71 V79" stroke="white" strokeWidth="2.5" strokeLinecap="round"/>
            </svg>
            <h3 className={styles.emptyTitle}>No transactions added</h3>
            <p className={styles.emptyText}>Click Debits or Credits above to add transactions</p>
          </div>
        ) : (
          <>
            {journalEntry.transactionLines.map((line, index) => (
              <div key={index} className={styles.transactionLineCard}>
                <div
                  className={`${styles.transactionLineHeader} ${
                    line.isDebit ? styles.debit : styles.credit
                  }`}
                >
                  <div
                    className={`${styles.transactionLineType} ${
                      line.isDebit ? styles.debit : styles.credit
                    }`}
                  >
                    {line.typeDisplay}
                  </div>
                  <div className={styles.transactionLineAccount}>
                    {line.accountName || 'No Account Selected'}
                  </div>
                  <div
                    className={`${styles.transactionLineAmount} ${
                      line.isDebit ? styles.debit : styles.credit
                    }`}
                  >
                    {formatCurrency(line.amount)}
                  </div>
                </div>
                <div className={styles.transactionLineBody}>
                  {line.description && (
                    <div className={styles.transactionLineDescription}>
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M14,10H19.5L14,4.5V10M5,3H15L21,9V19A2,2 0 0,1 19,21H5C3.89,21 3,20.1 3,19V5C3,3.89 3.89,3 5,3M9,12H16V14H9V12M9,16H14V18H9V16Z" />
                      </svg>
                      <span>{line.description}</span>
                    </div>
                  )}
                  <div className={styles.transactionLineTags}>
                    {line.categoryTag && (
                      <div className={`${styles.transactionTag} ${styles.category}`}>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M17.63,5.84C17.27,5.33 16.67,5 16,5L5,5.01C3.9,5.01 3,5.9 3,7V17C3,18.1 3.9,19 5,19H16C16.67,19 17.27,18.67 17.63,18.16L22,12L17.63,5.84Z" />
                        </svg>
                        {formatCategoryTag(line.categoryTag)}
                      </div>
                    )}
                    {line.cashLocationName && (
                      <div className={`${styles.transactionTag} ${styles.cash}`}>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M11,8C11,9.66 9.66,11 8,11C6.34,11 5,9.66 5,8C5,6.34 6.34,5 8,5C9.66,5 11,6.34 11,8M14,20H2V18C2,15.79 4.69,14 8,14C11.31,14 14,15.79 14,18V20M22,8V18H24V8H22M18,10V16H20V10H18M16,13V16H17V13H16Z" />
                        </svg>
                        {line.cashLocationName}
                      </div>
                    )}
                    {line.counterpartyName && (
                      <div className={`${styles.transactionTag} ${styles.counterparty}`}>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                          <path d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4M12,6A6,6 0 0,0 6,12A6,6 0 0,0 12,18A6,6 0 0,0 18,12A6,6 0 0,0 12,6Z" />
                        </svg>
                        {line.counterpartyName}
                      </div>
                    )}
                  </div>
                  <div className={styles.transactionLineActions}>
                    <button
                      className={`${styles.transactionActionBtn} ${styles.edit}`}
                      onClick={() => onEditTransaction(index)}
                    >
                      <svg className={styles.actionIcon} viewBox="0 0 24 24" fill="currentColor">
                        <path d="M20.71,7.04C21.1,6.65 21.1,6 20.71,5.63L18.37,3.29C18,2.9 17.35,2.9 16.96,3.29L15.12,5.12L18.87,8.87M3,17.25V21H6.75L17.81,9.93L14.06,6.18L3,17.25Z" />
                      </svg>
                      Edit
                    </button>
                    <button
                      className={`${styles.transactionActionBtn} ${styles.delete}`}
                      onClick={() => onDeleteTransaction(index)}
                    >
                      <svg className={styles.actionIcon} viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19,4H15.5L14.5,3H9.5L8.5,4H5V6H19M6,19A2,2 0 0,0 8,21H16A2,2 0 0,0 18,19V7H6V19Z" />
                      </svg>
                      Delete
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </>
        )}

        {/* Actions Footer */}
        <div className={styles.actionsFooter}>
          <TossButton
            variant="outline"
            size="lg"
            onClick={onAddTransaction}
            className={styles.addTransactionBtn}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style={{ marginRight: '8px' }}>
              <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
            </svg>
            Add Transaction
          </TossButton>
          <TossButton
            variant="primary"
            size="lg"
            onClick={onSubmit}
            disabled={!journalEntry.canSubmit()}
            loading={submitting}
            className={styles.submitBtn}
          >
            {getSubmitButtonText()}
          </TossButton>
        </div>
      </div>
    </>
  );
};

export default IconTabContent;
