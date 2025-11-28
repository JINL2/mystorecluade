/**
 * RecentTransactionHistory Component
 * Displays transaction history with inline filters
 * Used in Journal Input page (Icon and Excel tabs)
 * Updated: Added Store/Date filters in header row + multi-select filters for CREATED BY and ACCOUNT
 */

import React, { useEffect, useMemo, useState } from 'react';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { useJournalHistory } from '@/features/transaction-history/presentation/hooks/useJournalHistory';
import { JournalEntry } from '@/features/transaction-history/domain/entities/JournalEntry';
import type { RecentTransactionHistoryProps } from './RecentTransactionHistory.types';
import styles from './RecentTransactionHistory.module.css';

// Helper functions for default date range (30 days)
const getThirtyDaysAgo = (): string => {
  const date = new Date();
  date.setDate(date.getDate() - 30);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const getToday = (): string => {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

export const RecentTransactionHistory: React.FC<RecentTransactionHistoryProps> = ({
  companyId,
  stores,
  refreshTrigger
}) => {
  const {
    journalEntries,
    loading,
    employees,
    accounts,
    currentCreatedByIds,
    currentAccountIds,
    searchJournalEntries,
    setCreatedByFilter,
    setAccountFilter,
  } = useJournalHistory(companyId);

  // Local state for filters (independent from parent - this is for filtering history only)
  const [filterStoreId, setFilterStoreId] = useState<string | null>(null);
  const [fromDate, setFromDate] = useState<string>(getThirtyDaysAgo());
  const [toDate, setToDate] = useState<string>(getToday());

  // Auto-load data on mount, when filters change, or when refreshTrigger changes
  useEffect(() => {
    if (companyId) {
      searchJournalEntries(filterStoreId, fromDate, toDate);
    }
  }, [companyId, filterStoreId, fromDate, toDate, searchJournalEntries, refreshTrigger]);

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

  // Handlers for filter changes
  const handleCreatedByChange = (userIds: string[]) => {
    setCreatedByFilter(userIds);
  };

  const handleAccountChange = (accountIds: string[]) => {
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
      <h3 className={styles.emptyTitle}>No Recent Transactions</h3>
      <p className={styles.emptyText}>
        No transactions found in the last 30 days.
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
        <div className={styles.tableHeaderRow}>
          <div className={styles.titleSection}>
            <h3 className={styles.tableTitle}>Transaction History</h3>
            <p className={styles.tableSubtitle}>
              Found {journalEntries.length} journal{journalEntries.length !== 1 ? 's' : ''}
            </p>
          </div>
          <div className={styles.filterSection}>
            <div className={styles.filterField}>
              <label className={styles.filterLabel}>STORE</label>
              <StoreSelector
                stores={stores}
                selectedStoreId={filterStoreId}
                onStoreSelect={setFilterStoreId}
                showAllStoresOption={true}
                width="160px"
              />
            </div>
            <div className={styles.filterField}>
              <label className={styles.filterLabel}>FROM DATE</label>
              <input
                type="date"
                className={styles.dateInput}
                value={fromDate}
                onChange={(e) => setFromDate(e.target.value)}
              />
            </div>
            <div className={styles.filterField}>
              <label className={styles.filterLabel}>TO DATE</label>
              <input
                type="date"
                className={styles.dateInput}
                value={toDate}
                onChange={(e) => setToDate(e.target.value)}
              />
            </div>
          </div>
        </div>
      </div>

      <table className={styles.transactionTable}>
        <thead>
          <tr>
            <th style={{ width: '140px' }}>DATE & TIME</th>
            <th style={{ width: '180px' }}>
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
            <th style={{ width: '150px' }}>DESCRIPTION</th>
            <th style={{ width: '100px' }}>STORE</th>
            <th style={{ width: '160px' }}>
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
            journalEntries.map((journal, index) => renderJournalEntry(journal, index))
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
    <div className={styles.container}>
      {loading && renderLoadingState()}
      {!loading && renderTransactionTable()}
    </div>
  );
};

export default RecentTransactionHistory;
