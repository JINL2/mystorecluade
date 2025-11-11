/**
 * TransactionHistoryPage Component
 * Complete ledger view with journal entry grouping
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useJournalHistory } from '../../hooks/useJournalHistory';
import { TransactionFilter, TransactionFilterValues } from '../../components/TransactionFilter';
import { JournalEntry } from '../../../domain/entities/JournalEntry';
import styles from './TransactionHistoryPage.module.css';

export const TransactionHistoryPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';

  const {
    journalEntries,
    loading,
    error,
    hasSearched,
    searchJournalEntries,
    clearSearch,
  } = useJournalHistory(companyId);

  const handleSearch = (filters: TransactionFilterValues) => {
    searchJournalEntries(filters.storeId, filters.fromDate || null, filters.toDate || null);
  };

  const handleClear = () => {
    clearSearch();
  };

  const renderInitialState = () => (
    <div className={styles.emptyState}>
      <div className={styles.emptyIcon}>
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <circle cx="11" cy="11" r="8" />
          <path d="m21 21-4.35-4.35" />
        </svg>
      </div>
      <h3 className={styles.emptyTitle}>Search Transactions</h3>
      <p className={styles.emptyText}>
        Select filters and click Search to view transaction history
      </p>
    </div>
  );

  const renderLoadingState = () => (
    <div className={styles.loadingState}>
      <div className={styles.spinner}>
        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M12 2v4m0 12v4m10-10h-4M6 12H2" />
        </svg>
      </div>
      <h3 className={styles.loadingTitle}>Loading Transactions...</h3>
      <p className={styles.loadingText}>Please wait while we fetch your transaction history.</p>
    </div>
  );

  const renderErrorState = () => (
    <div className={styles.errorState}>
      <div className={styles.errorIcon}>
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <circle cx="12" cy="12" r="10" />
          <path d="M12 8v4m0 4h.01" />
        </svg>
      </div>
      <h3 className={styles.errorTitle}>Failed to Load Transactions</h3>
      <p className={styles.errorText}>{error}</p>
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
      <h3 className={styles.emptyTitle}>No Transactions Found</h3>
      <p className={styles.emptyText}>
        No transactions found for the selected period. Try adjusting your search filters.
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
        <h3 className={styles.tableTitle}>Transaction History</h3>
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
    <>
      <Navbar activeItem="finance" />
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <h1 className={styles.title}>Transaction History</h1>
          <p className={styles.subtitle}>View all transactions</p>
        </div>

        <TransactionFilter onSearch={handleSearch} onClear={handleClear} />

        <div className={styles.contentCard}>
          {loading && renderLoadingState()}
          {error && !loading && renderErrorState()}
          {!loading && !error && !hasSearched && renderInitialState()}
          {!loading && !error && hasSearched && journalEntries.length === 0 && renderEmptyResults()}
          {!loading && !error && hasSearched && journalEntries.length > 0 && renderTransactionTable()}
        </div>
      </div>
    </>
  );
};

export default TransactionHistoryPage;
