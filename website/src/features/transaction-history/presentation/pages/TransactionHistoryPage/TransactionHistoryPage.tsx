/**
 * TransactionHistoryPage Component
 * Transaction history with detailed ledger view
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useTransactionHistory } from '../../hooks/useTransactionHistory';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { TransactionHistoryPageProps } from './TransactionHistoryPage.types';
import styles from './TransactionHistoryPage.module.css';

export const TransactionHistoryPage: React.FC<TransactionHistoryPageProps> = ({
  companyId = 'default',
  storeId = null,
}) => {
  const { transactions, loading, error, refresh } = useTransactionHistory(companyId, storeId);

  if (loading) {
    return (
      <>
        <Navbar activeItem="finance" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Transaction History</h1>
          </div>
          <div className={styles.loadingState}>
            <div className={styles.spinner}>Loading transactions...</div>
          </div>
        </div>
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="finance" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Transaction History</h1>
          </div>
          <div className={styles.errorContainer}>
            <div className={styles.errorIcon}>⚠️</div>
            <h2 className={styles.errorTitle}>Failed to Load Transactions</h2>
            <p className={styles.errorMessage}>{error}</p>
            <TossButton onClick={refresh} variant="primary">
              Try Again
            </TossButton>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="finance" />
      <div className={styles.container}>
      <div className={styles.header}>
        <h1 className={styles.title}>Transaction History</h1>
        <p className={styles.subtitle}>Complete ledger of all financial transactions</p>
      </div>

      {transactions.length === 0 ? (
        <div className={styles.emptyState}>
          <div className={styles.emptyIcon}>📊</div>
          <h3 className={styles.emptyTitle}>No Transactions</h3>
          <p className={styles.emptyText}>
            No transaction records found for the selected period
          </p>
        </div>
      ) : (
        <div className={styles.tableContainer}>
          <table className={styles.table}>
            <thead className={styles.tableHeader}>
              <tr>
                <th>Date</th>
                <th>Account</th>
                <th>Description</th>
                <th>Debit</th>
                <th>Credit</th>
                <th>Balance</th>
                <th>Tags</th>
              </tr>
            </thead>
            <tbody className={styles.tableBody}>
              {transactions.map((transaction) => (
                <tr key={transaction.transactionId}>
                  <td className={styles.dateCell}>{transaction.formattedDate}</td>
                  <td className={styles.accountCell}>{transaction.accountName}</td>
                  <td className={styles.descriptionCell}>{transaction.description}</td>
                  <td className={`${styles.amountCell} ${styles.debit}`}>
                    {transaction.debitAmount > 0
                      ? transaction.formatCurrency(transaction.debitAmount)
                      : '-'}
                  </td>
                  <td className={`${styles.amountCell} ${styles.credit}`}>
                    {transaction.creditAmount > 0
                      ? transaction.formatCurrency(transaction.creditAmount)
                      : '-'}
                  </td>
                  <td className={styles.balanceCell}>
                    {transaction.formatCurrency(transaction.balance)}
                  </td>
                  <td className={styles.tagCell}>
                    {transaction.categoryTag && (
                      <span className={`${styles.tag} ${styles.category}`}>
                        {transaction.formattedCategoryTag}
                      </span>
                    )}
                    {transaction.counterpartyName && (
                      <span className={`${styles.tag} ${styles.counterparty}`}>
                        {transaction.counterpartyName}
                      </span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
    </>
  );
};

export default TransactionHistoryPage;
