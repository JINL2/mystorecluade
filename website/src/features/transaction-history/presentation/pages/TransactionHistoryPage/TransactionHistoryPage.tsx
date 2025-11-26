/**
 * TransactionHistoryPage Component
 * Complete ledger view with journal entry grouping
 */

import React, { useEffect, useMemo } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { useAppState } from '@/app/providers/app_state_provider';
import { useJournalHistory } from '../../hooks/useJournalHistory';
import { TransactionFilter, TransactionFilterValues } from '../../components/TransactionFilter';
import { JournalEntry } from '../../../domain/entities/JournalEntry';
import styles from './TransactionHistoryPage.module.css';

export const TransactionHistoryPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const { messageState, closeMessage, showError } = useErrorMessage();

  const {
    journalEntries,
    loading,
    error,
    hasSearched,
    employees,
    accounts,
    currentCreatedBy,
    currentAccountId,
    currentStoreId,
    currentStartDate,
    currentEndDate,
    searchJournalEntries,
    setCreatedByFilter,
    setAccountFilter,
    clearSearch,
  } = useJournalHistory(companyId);

  // Transform employees to TossSelector options
  const employeeOptions = useMemo(() => {
    return [
      { value: '', label: 'All' },
      ...employees.map((emp) => ({
        value: emp.userId,
        label: emp.fullName,
      })),
    ];
  }, [employees]);

  // Transform accounts to TossSelector options
  const accountOptions = useMemo(() => {
    return [
      { value: '', label: 'All' },
      ...accounts.map((acc) => ({
        value: acc.accountId,
        label: acc.accountName,
      })),
    ];
  }, [accounts]);

  // Show error dialog when error occurs
  useEffect(() => {
    if (error) {
      showError({
        title: 'Failed to Load Transactions',
        message: error,
        confirmText: 'OK',
      });
    }
  }, [error, showError]);

  const handleSearch = (filters: TransactionFilterValues) => {
    // Reset filters on new search
    setCreatedByFilter(null);
    setAccountFilter(null);
    searchJournalEntries(
      filters.storeId,
      filters.fromDate || null,
      filters.toDate || null,
      null,
      null
    );
  };

  const handleCreatedByChange = (userId: string) => {
    const newCreatedBy = userId || null;
    setCreatedByFilter(newCreatedBy);

    // Re-search if already searched
    if (hasSearched) {
      searchJournalEntries(currentStoreId, currentStartDate, currentEndDate, newCreatedBy, currentAccountId);
    }
  };

  const handleAccountChange = (accountId: string) => {
    const newAccountId = accountId || null;
    setAccountFilter(newAccountId);

    // Re-search if already searched
    if (hasSearched) {
      searchJournalEntries(currentStoreId, currentStartDate, currentEndDate, currentCreatedBy, newAccountId);
    }
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
      <h3 className={styles.emptyTitle}>No Transactions Found</h3>
      <p className={styles.emptyText}>
        No transactions found for the selected period. Try adjusting your search filters.
      </p>
    </div>
  );

  const renderJournalEntry = (journal: JournalEntry, index: number) => (
    <React.Fragment key={journal.journalId}>
      {/* Journal Header Row */}
      <tr className={`${styles.journalHeader} ${index > 0 ? styles.journalSeparator : ''}`}>
        <td>
          <div className={styles.journalDate}>{journal.formattedDate}</div>
          <div className={styles.journalTime}>{journal.formattedTime}</div>
        </td>
        <td>-</td>
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
      {journal.sortedLines.map((line, lineIndex) => {
        const alternateClass = lineIndex % 2 === 1 ? styles.alternate : '';

        // Build full description with counterparty and location
        let fullDescription = line.description || '';
        if (line.displayCounterparty && line.displayLocation) {
          fullDescription = fullDescription ? `${fullDescription} • ${line.displayCounterparty} • ${line.displayLocation}` : `${line.displayCounterparty} • ${line.displayLocation}`;
        } else if (line.displayCounterparty) {
          fullDescription = fullDescription ? `${fullDescription} • ${line.displayCounterparty}` : line.displayCounterparty;
        } else if (line.displayLocation) {
          fullDescription = fullDescription ? `${fullDescription} • ${line.displayLocation}` : line.displayLocation;
        }

        return (
          <tr key={line.lineId} className={`${styles.lineRow} ${alternateClass}`}>
            <td>-</td>
            <td className={styles.accountCell}>
              <strong>{line.accountName}</strong>
            </td>
            <td className={styles.lineDescription}>{fullDescription || '-'}</td>
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
        <td colSpan={5} className={styles.totalLabel}>
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
            <th style={{ width: '140px' }}>DATE & TIME</th>
            <th style={{ width: '200px' }}>
              <div className={styles.headerWithFilter}>
                <span>ACCOUNT</span>
                <TossSelector
                  value={currentAccountId || ''}
                  options={accountOptions}
                  onChange={handleAccountChange}
                  placeholder="All"
                  searchable
                  className={styles.accountSelector}
                />
              </div>
            </th>
            <th style={{ width: '180px' }}>DESCRIPTION</th>
            <th style={{ width: '100px' }}>STORE</th>
            <th style={{ width: '180px' }}>
              <div className={styles.headerWithFilter}>
                <span>CREATED BY</span>
                <TossSelector
                  value={currentCreatedBy || ''}
                  options={employeeOptions}
                  onChange={handleCreatedByChange}
                  placeholder="All"
                  searchable
                  className={styles.createdBySelector}
                />
              </div>
            </th>
            <th style={{ width: '100px' }}>DEBIT</th>
            <th style={{ width: '100px' }}>CREDIT</th>
          </tr>
        </thead>
        <tbody>{journalEntries.map(renderJournalEntry)}</tbody>
      </table>
    </div>
  );

  return (
    <>
      <Navbar activeItem="finance" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          <div className={styles.pageHeader}>
            <h1 className={styles.title}>Transaction History</h1>
            <p className={styles.subtitle}>View all transactions</p>
          </div>

          <TransactionFilter onSearch={handleSearch} onClear={handleClear} />

          <div className={styles.contentCard}>
            {loading && renderLoadingState()}
            {!loading && !hasSearched && renderInitialState()}
            {!loading && hasSearched && journalEntries.length === 0 && renderEmptyResults()}
            {!loading && hasSearched && journalEntries.length > 0 && renderTransactionTable()}
          </div>
        </div>
      </div>

      {/* Error Message Dialog */}
      <ErrorMessage
        variant={messageState.variant}
        title={messageState.title}
        message={messageState.message}
        isOpen={messageState.isOpen}
        onClose={closeMessage}
        confirmText={messageState.confirmText || 'OK'}
      />
    </>
  );
};

export default TransactionHistoryPage;
