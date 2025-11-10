/**
 * BalanceSheetPage Component
 * Balance sheet financial statement with assets, liabilities, and equity
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useBalanceSheet } from '../../hooks/useBalanceSheet';
import { BalanceSheetFilter } from '../../components/BalanceSheetFilter/BalanceSheetFilter';
import { TossButton } from '@/shared/components/toss/TossButton';
import type { BalanceSheetPageProps } from './BalanceSheetPage.types';
import type { BalanceSheetSection } from '../../../domain/entities/BalanceSheetData';
import type { FilterValues } from '../../components/BalanceSheetFilter/BalanceSheetFilter.types';
import styles from './BalanceSheetPage.module.css';

export const BalanceSheetPage: React.FC<BalanceSheetPageProps> = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';

  const { balanceSheet, loading, error, changeDateRange, changeStore, loadBalanceSheet } =
    useBalanceSheet(companyId, null);

  const handleSearch = (filters: FilterValues) => {
    console.log('Searching with filters:', filters);
    // Update state for next time
    changeStore(filters.storeId);
    changeDateRange(filters.startDate, filters.endDate);
    // Pass filter values directly to loadBalanceSheet to avoid async state update issue
    loadBalanceSheet(filters.storeId, filters.startDate, filters.endDate);
  };

  const handleClear = () => {
    console.log('Filters cleared');
    changeStore(null);
    changeDateRange(null, null);
    // Don't load data - show empty state
  };

  const renderSection = (section: BalanceSheetSection) => {
    if (!section || section.accounts.length === 0) {
      return (
        <div className={styles.emptyState}>
          <p>No accounts in this section</p>
        </div>
      );
    }

    return (
      <div className={styles.accountList}>
        {section.accounts.map((account) => (
          <div key={account.accountId} className={styles.accountItem}>
            <span className={styles.accountName}>{account.accountName}</span>
            <span className={styles.accountBalance}>{account.formattedBalance}</span>
          </div>
        ))}
      </div>
    );
  };

  return (
    <>
      <Navbar activeItem="finance" />
      <div className={styles.pageContainer}>
        <main className={styles.pageContent}>
          {/* Page Header */}
          <div className={styles.pageHeader}>
            <h1 className={styles.pageTitle}>Balance Sheet</h1>
            <p className={styles.pageSubtitle}>View your company's financial position</p>
          </div>

        {/* Filter Component */}
        <BalanceSheetFilter onSearch={handleSearch} onClear={handleClear} />

        {/* Content Card */}
        <div className={styles.contentCard}>
          {loading && (
            <div className={styles.loadingState}>
              <div className={styles.spinner}>Loading balance sheet...</div>
            </div>
          )}

          {error && !loading && (
            <div className={styles.errorContainer}>
              <div className={styles.errorIcon}>⚠️</div>
              <h2 className={styles.errorTitle}>Failed to Load Balance Sheet</h2>
              <p className={styles.errorMessage}>{error}</p>
              <TossButton onClick={loadBalanceSheet} variant="primary">
                Try Again
              </TossButton>
            </div>
          )}

          {!balanceSheet && !loading && !error && (
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

                {/* Balance Symbol (Scale) */}
                <circle cx="60" cy="75" r="12" fill="#0064FF"/>
                <path d="M54 75 L56 77 L62 71" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
              <h3 className={styles.emptyTitle}>Select Filters to Load Balance Sheet</h3>
              <p className={styles.emptyText}>
                Choose your filters and click Search to view the balance sheet data.
              </p>
            </div>
          )}

          {balanceSheet && !loading && !error && (
            <>
              {/* Summary Cards */}
              <div className={styles.summaryCards}>
                <div className={`${styles.summaryCard} ${styles.assets}`}>
                  <div className={styles.summaryCardLabel}>Total Assets</div>
                  <div className={styles.summaryCardValue}>
                    {balanceSheet.formatCurrency(balanceSheet.totalAssets)}
                  </div>
                  <div className={styles.summaryCardPercent}>{balanceSheet.assetsPercentage}</div>
                </div>

                <div className={`${styles.summaryCard} ${styles.liabilities}`}>
                  <div className={styles.summaryCardLabel}>Total Liabilities</div>
                  <div className={styles.summaryCardValue}>
                    {balanceSheet.formatCurrency(balanceSheet.totalLiabilities)}
                  </div>
                  <div className={styles.summaryCardPercent}>
                    {balanceSheet.liabilitiesPercentage}
                  </div>
                </div>

                <div className={`${styles.summaryCard} ${styles.equity}`}>
                  <div className={styles.summaryCardLabel}>Total Equity</div>
                  <div className={styles.summaryCardValue}>
                    {balanceSheet.formatCurrency(balanceSheet.totalEquity)}
                  </div>
                  <div className={styles.summaryCardPercent}>{balanceSheet.equityPercentage}</div>
                </div>
              </div>

              {/* Two Column Layout */}
              <div className={styles.balanceSheetColumns}>
                {/* Left Column - Assets */}
                <div>
                  {/* Current Assets */}
                  <div className={styles.sectionCard}>
                    <div className={styles.sectionHeader}>
                      <h3 className={styles.sectionTitle}>{balanceSheet.currentAssets.title}</h3>
                      <div className={styles.sectionTotal}>
                        {balanceSheet.formatCurrency(balanceSheet.currentAssets.total)}
                      </div>
                    </div>
                    {renderSection(balanceSheet.currentAssets)}
                  </div>

                  {/* Non-Current Assets */}
                  <div className={styles.sectionCard}>
                    <div className={styles.sectionHeader}>
                      <h3 className={styles.sectionTitle}>{balanceSheet.nonCurrentAssets.title}</h3>
                      <div className={styles.sectionTotal}>
                        {balanceSheet.formatCurrency(balanceSheet.nonCurrentAssets.total)}
                      </div>
                    </div>
                    {renderSection(balanceSheet.nonCurrentAssets)}
                  </div>
                </div>

                {/* Right Column - Liabilities & Equity */}
                <div>
                  {/* Current Liabilities */}
                  <div className={styles.sectionCard}>
                    <div className={styles.sectionHeader}>
                      <h3 className={styles.sectionTitle}>
                        {balanceSheet.currentLiabilities.title}
                      </h3>
                      <div className={styles.sectionTotal}>
                        {balanceSheet.formatCurrency(balanceSheet.currentLiabilities.total)}
                      </div>
                    </div>
                    {renderSection(balanceSheet.currentLiabilities)}
                  </div>

                  {/* Non-Current Liabilities */}
                  <div className={styles.sectionCard}>
                    <div className={styles.sectionHeader}>
                      <h3 className={styles.sectionTitle}>
                        {balanceSheet.nonCurrentLiabilities.title}
                      </h3>
                      <div className={styles.sectionTotal}>
                        {balanceSheet.formatCurrency(balanceSheet.nonCurrentLiabilities.total)}
                      </div>
                    </div>
                    {renderSection(balanceSheet.nonCurrentLiabilities)}
                  </div>

                  {/* Equity */}
                  <div className={styles.sectionCard}>
                    <div className={styles.sectionHeader}>
                      <h3 className={styles.sectionTitle}>{balanceSheet.equity.title}</h3>
                      <div className={styles.sectionTotal}>
                        {balanceSheet.formatCurrency(balanceSheet.equity.total)}
                      </div>
                    </div>
                    {renderSection(balanceSheet.equity)}
                  </div>

                  {/* Other Comprehensive Income */}
                  {balanceSheet.comprehensiveIncome.accounts.length > 0 && (
                    <div className={styles.sectionCard}>
                      <div className={styles.sectionHeader}>
                        <h3 className={styles.sectionTitle}>{balanceSheet.comprehensiveIncome.title}</h3>
                        <div className={styles.sectionTotal}>
                          {balanceSheet.formatCurrency(balanceSheet.comprehensiveIncome.total)}
                        </div>
                      </div>
                      {renderSection(balanceSheet.comprehensiveIncome)}
                    </div>
                  )}
                </div>
              </div>

              {/* Balance Check Warning */}
              {!balanceSheet.isBalanced && (
                <div
                  style={{
                    marginTop: '16px',
                    padding: '12px',
                    background: '#FEE',
                    borderRadius: '8px',
                    color: '#C00',
                  }}
                >
                  ⚠️ Warning: Balance sheet equation not satisfied. Difference:{' '}
                  {balanceSheet.formatCurrency(Math.abs(balanceSheet.balanceDifference))}
                </div>
              )}
            </>
          )}
        </div>
        </main>
      </div>
    </>
  );
};

export default BalanceSheetPage;
