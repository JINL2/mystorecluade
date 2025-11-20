/**
 * RecentTransactionHistory Component
 * Displays last 30 days of transaction history
 * Used in Journal Input page (Icon and Excel tabs)
 */

import React, { useEffect, useMemo } from 'react';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useJournalHistory } from '@/features/transaction-history/presentation/hooks/useJournalHistory';
import { JournalEntry } from '@/features/transaction-history/domain/entities/JournalEntry';
import type { RecentTransactionHistoryProps } from './RecentTransactionHistory.types';
import styles from './RecentTransactionHistory.module.css';

export const RecentTransactionHistory: React.FC<RecentTransactionHistoryProps> = ({ companyId }) => {
  const {
    journalEntries,
    loading,
    searchJournalEntries,
  } = useJournalHistory(companyId);

  // Calculate date range: 30 days ago to today (local time)
  const dateRange = useMemo(() => {
    const today = new Date();
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(today.getDate() - 30);

    // Format as YYYY-MM-DD in local time
    const formatDate = (date: Date) => {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    };

    return {
      fromDate: formatDate(thirtyDaysAgo),
      toDate: formatDate(today),
    };
  }, []);

  // Auto-load data on mount
  useEffect(() => {
    if (companyId) {
      searchJournalEntries(null, dateRange.fromDate, dateRange.toDate);
    }
  }, [companyId, dateRange.fromDate, dateRange.toDate, searchJournalEntries]);

  const renderLoadingState = () => (
    <div className={styles.loadingState}>
      <LoadingAnimation size="large" />
    </div>
  );

  const renderEmptyResults = () => (
    <div className={styles.emptyState}>
      <div className={styles.emptyIcon}>
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M3 3v18h18" />
          <path d="M18 17V9" />
          <path d="M13 17V5" />
          <path d="M8 17v-3" />
        </svg>
      </div>
      <h3 className={styles.emptyTitle}>No Recent Transactions</h3>
      <p className={styles.emptyText}>
        No transactions found in the last 30 days.
      </p>
    </div>
  );

  const renderJournalEntry = (journal: JournalEntry) => (
    <React.Fragment key={journal.journalId}>
      {/* Journal Header Row */}
      <tr className={styles.journalHeader}>
        <td>
          <div className={styles.journalDate}>{journal.formattedDate}</div>
          <div className={styles.journalTime}>{journal.formattedTime}</div>
        </td>
        <td>{journal.description || '-'}</td>
        <td>
          {journal.storeName ? (
            <span className={styles.storeBadge}>{journal.storeName}</span>
          ) : (
            'All Stores'
          )}
        </td>
        <td>{journal.createdByName}</td>
        <td className={`${styles.amountCell} ${styles.debitAmount}`}>
          {journal.formatCurrency(journal.totalDebit)}
        </td>
        <td className={`${styles.amountCell} ${styles.creditAmount}`}>
          {journal.formatCurrency(journal.totalCredit)}
        </td>
      </tr>

      {/* Journal Lines */}
      {journal.sortedLines.map((line, index) => {
        const alternateClass = index % 2 === 1 ? styles.alternate : '';

        // Build full description with counterparty and location
        let fullDescription = line.description || line.accountName;
        if (line.displayCounterparty && line.displayLocation) {
          fullDescription = `${fullDescription} • ${line.displayCounterparty} • ${line.displayLocation}`;
        } else if (line.displayCounterparty) {
          fullDescription = `${fullDescription} • ${line.displayCounterparty}`;
        } else if (line.displayLocation) {
          fullDescription = `${fullDescription} • ${line.displayLocation}`;
        }

        return (
          <tr key={line.lineId} className={`${styles.lineRow} ${alternateClass}`}>
            <td className={styles.accountCell}>
              <strong>{line.accountName}</strong>
            </td>
            <td className={styles.lineDescription}>{fullDescription}</td>
            <td>-</td>
            <td>-</td>
            <td className={`${styles.amountCell} ${styles.debitAmount}`}>
              {line.debit > 0 ? line.debit.toLocaleString('en-US') : '-'}
            </td>
            <td className={`${styles.amountCell} ${styles.creditAmount}`}>
              {line.credit > 0 ? line.credit.toLocaleString('en-US') : '-'}
            </td>
          </tr>
        );
      })}

      {/* Total Row */}
      <tr className={styles.totalRow}>
        <td colSpan={4} className={styles.totalLabel}>
          Total:
        </td>
        <td className={`${styles.amountCell} ${styles.debitAmount}`}>
          {journal.totalDebit > 0 ? journal.totalDebit.toLocaleString('en-US') : '-'}
        </td>
        <td className={`${styles.amountCell} ${styles.creditAmount}`}>
          {journal.totalCredit > 0 ? journal.totalCredit.toLocaleString('en-US') : '-'}
        </td>
      </tr>
    </React.Fragment>
  );

  const renderTransactionTable = () => (
    <div className={styles.tableWrapper}>
      <div className={styles.tableHeader}>
        <h3 className={styles.tableTitle}>Recent Transactions (Last 30 Days)</h3>
        <p className={styles.tableSubtitle}>
          Found {journalEntries.length} journal{journalEntries.length !== 1 ? 's' : ''}
        </p>
      </div>

      <table className={styles.transactionTable}>
        <thead>
          <tr>
            <th style={{ width: '160px' }}>DATE & TIME</th>
            <th style={{ width: '200px' }}>DESCRIPTION</th>
            <th style={{ width: '120px' }}>STORE</th>
            <th style={{ width: '120px' }}>CREATED BY</th>
            <th style={{ width: '120px' }}>DEBIT</th>
            <th style={{ width: '120px' }}>CREDIT</th>
          </tr>
        </thead>
        <tbody>{journalEntries.map(renderJournalEntry)}</tbody>
      </table>
    </div>
  );

  return (
    <div className={styles.container}>
      {loading && renderLoadingState()}
      {!loading && journalEntries.length === 0 && renderEmptyResults()}
      {!loading && journalEntries.length > 0 && renderTransactionTable()}
    </div>
  );
};

export default RecentTransactionHistory;
