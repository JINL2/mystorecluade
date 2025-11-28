/**
 * TransactionHistoryPage Component
 * Complete ledger view with journal entry grouping
 */

import React, { useEffect, useMemo, useRef } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';
import { useAppState } from '@/app/providers/app_state_provider';
import { useJournalHistory } from '../../hooks/useJournalHistory';
import { TransactionFilter, TransactionFilterValues, getFirstDayOfMonth, getLastDayOfMonth } from '../../components/TransactionFilter';
import { JournalEntry } from '../../../domain/entities/JournalEntry';
import styles from './TransactionHistoryPage.module.css';

export const TransactionHistoryPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const { messageState, closeMessage, showError } = useErrorMessage();
  const hasInitialLoaded = useRef(false);

  const {
    journalEntries,
    loading,
    error,
    employees,
    accounts,
    currentCreatedByIds,
    currentAccountIds,
    searchJournalEntries,
    setCreatedByFilter,
    setAccountFilter,
  } = useJournalHistory(companyId);

  // Transform employees to TossSelector options (no "All" option for multi-select)
  const employeeOptions = useMemo(() => {
    return employees.map((emp) => ({
      value: emp.userId,
      label: emp.fullName,
    }));
  }, [employees]);

  // Transform accounts to TossSelector options (no "All" option for multi-select)
  const accountOptions = useMemo(() => {
    return accounts.map((acc) => ({
      value: acc.accountId,
      label: acc.accountName,
    }));
  }, [accounts]);

  // Auto-load data on page mount with default values
  useEffect(() => {
    if (companyId && !hasInitialLoaded.current) {
      hasInitialLoaded.current = true;
      // Load with default values: current month, all stores
      searchJournalEntries(
        null, // all stores
        getFirstDayOfMonth(),
        getLastDayOfMonth()
      );
    }
  }, [companyId, searchJournalEntries]);

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

  const handleFilterChange = (filters: TransactionFilterValues) => {
    // Search calls RPC once, filters are applied client-side
    searchJournalEntries(
      filters.storeId,
      filters.fromDate || null,
      filters.toDate || null
    );
  };

  const handleCreatedByChange = (userIds: string[]) => {
    // Client-side filtering only, no RPC call
    setCreatedByFilter(userIds);
  };

  const handleAccountChange = (accountIds: string[]) => {
    // Client-side filtering only, no RPC call
    setAccountFilter(accountIds);
  };

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
                  values={currentAccountIds}
                  options={accountOptions}
                  onChangeMultiple={handleAccountChange}
                  placeholder="All"
                  searchable
                  multiple
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
                  values={currentCreatedByIds}
                  options={employeeOptions}
                  onChangeMultiple={handleCreatedByChange}
                  placeholder="All"
                  searchable
                  multiple
                  className={styles.createdBySelector}
                />
              </div>
            </th>
            <th style={{ width: '100px' }}>DEBIT</th>
            <th style={{ width: '100px' }}>CREDIT</th>
          </tr>
        </thead>
        <tbody>
          {journalEntries.length > 0 ? (
            journalEntries.map(renderJournalEntry)
          ) : (
            <tr>
              <td colSpan={7} className={styles.emptyTableCell}>
                <div className={styles.emptyTableState}>
                  <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M3 3v18h18" />
                    <path d="M18 17V9" />
                    <path d="M13 17V5" />
                    <path d="M8 17v-3" />
                  </svg>
                  <p>No transactions found for the selected filters.</p>
                </div>
              </td>
            </tr>
          )}
        </tbody>
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

          <TransactionFilter onFilterChange={handleFilterChange} />

          <div className={styles.contentCard}>
            {loading && renderLoadingState()}
            {!loading && renderTransactionTable()}
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
