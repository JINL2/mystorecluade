/**
 * DashboardPage Component
 * Main dashboard page with financial overview
 * Uses ErrorMessage component for consistent error handling
 */

import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useDashboard } from '../../hooks/useDashboard';
import { OverviewCard } from '../../components/OverviewCard';
import { ExpenseChart } from '../../components/ExpenseChart';
import { Navbar } from '@/shared/components/common/Navbar';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useAppState } from '@/app/providers/app_state_provider';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import { DashboardMessages } from '@/features/dashboard/domain/constants/DashboardMessages';
import type { DashboardPageProps } from './DashboardPage.types';
import styles from './DashboardPage.module.css';

// Transaction History feature ID for permission check
const TRANSACTION_HISTORY_FEATURE_ID = '7e1fd11a-f632-427d-aefc-8b3dd6734faa';

export const DashboardPage: React.FC<DashboardPageProps> = () => {
  const navigate = useNavigate();
  const { currentCompany, permissions } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const { data, loading, errorDialog, refresh, clearError } = useDashboard(companyId);
  const [showPermissionError, setShowPermissionError] = useState(false);

  // Handle View All click with permission check
  const handleViewAllClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
    e.preventDefault();

    const hasAccess = permissions.includes(TRANSACTION_HISTORY_FEATURE_ID);

    if (hasAccess) {
      navigate('/finance/transaction-history');
    } else {
      setShowPermissionError(true);
    }
  };

  // Show loading if no company selected yet
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="dashboard" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <LoadingAnimation size="large" fullscreen={true} />
          </div>
        </div>
      </>
    );
  }

  if (loading) {
    return (
      <>
        <Navbar activeItem="dashboard" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <LoadingAnimation size="large" fullscreen={true} />
          </div>
        </div>
      </>
    );
  }

  if (!data && !loading) {
    return (
      <>
        <Navbar activeItem="dashboard" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <div className={styles.header}>
              <h1 className={styles.title}>Dashboard</h1>
            </div>
            <div className={styles.emptyState}>
              <p>{DashboardMessages.emptyStates.noDashboardData}</p>
            </div>
          </div>
        </div>

        {/* ErrorMessage Dialog */}
        <ErrorMessage
          variant={errorDialog.variant}
          title={errorDialog.title}
          message={errorDialog.message}
          isOpen={errorDialog.isOpen}
          onClose={clearError}
          confirmText={DashboardMessages.actions.retry}
          onConfirm={refresh}
        />
      </>
    );
  }

  // Calculate change percentages
  // Note: Today revenue change calculation requires historical data
  const todayRevenueChange = 0; // Reserved for future implementation
  const thisMonthChange = data?.monthOverMonthGrowth || 0;

  return (
    <>
      <Navbar activeItem="dashboard" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          {/* Page Header */}
          <div className={styles.header}>
            <h1 className={styles.title}>Dashboard</h1>
          </div>

          {/* Overview Cards Grid */}
          <div className={styles.overviewGrid}>
          <OverviewCard
            key="today-revenue"
            title="Today Revenue"
            value={data?.formattedTodayRevenue || '₫0'}
            icon={
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M11.8,10.9C9.53,10.31 8.8,9.7 8.8,8.75C8.8,7.66 9.81,6.9 11.5,6.9C13.28,6.9 13.94,7.75 14,9H16.21C16.14,7.28 15.09,5.7 13,5.19V3H10V5.16C8.06,5.58 6.5,6.84 6.5,8.77C6.5,11.08 8.41,12.23 11.2,12.9C13.7,13.5 14.2,14.38 14.2,15.31C14.2,16 13.71,17.1 11.5,17.1C9.44,17.1 8.63,16.18 8.52,15H6.32C6.44,17.19 8.08,18.42 10,18.83V21H13V18.85C14.95,18.5 16.5,17.35 16.5,15.3C16.5,12.46 14.07,11.5 11.8,10.9Z"/>
              </svg>
            }
            changePercentage={todayRevenueChange}
            isPositive={todayRevenueChange >= 0}
          />
          <OverviewCard
            key="today-expense"
            title="Today Expense"
            value={data?.formattedTodayExpense || '₫0'}
            icon={
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M3,6H21V18H3V6M12,9A3,3 0 0,1 15,12A3,3 0 0,1 12,15A3,3 0 0,1 9,12A3,3 0 0,1 12,9M7,8A2,2 0 0,1 5,10V14A2,2 0 0,1 7,16H17A2,2 0 0,1 19,14V10A2,2 0 0,1 17,8H7Z"/>
              </svg>
            }
          />
          <OverviewCard
            key="this-month-revenue"
            title="This Month Revenue"
            value={data?.formattedThisMonthRevenue || '₫0'}
            icon={
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M16,6L18.29,8.29L13.41,13.17L9.41,9.17L2,16.59L3.41,18L9.41,12L13.41,16L19.71,9.71L22,12V6H16Z"/>
              </svg>
            }
            changePercentage={thisMonthChange}
            isPositive={data?.isGrowthPositive || false}
          />
          <OverviewCard
            key="last-month-revenue"
            title="Last Month Revenue"
            value={data?.formattedLastMonthRevenue || '₫0'}
            icon={
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M22,21H2V3H4V19H6V10H10V19H12V6H16V19H18V14H22V21Z"/>
              </svg>
            }
          />
        </div>

        {/* 2-Column Layout: Expenses + Recent Activity */}
        <div className={styles.contentGrid}>
          {/* Left Column: This Month Expenses */}
          <div className={styles.contentSection}>
            <div className={styles.sectionHeader}>
              <h2 className={styles.sectionTitle}>This Month Expenses</h2>
            </div>
            <div className={styles.sectionContent}>
              <ExpenseChart
                data={data?.expenseBreakdown || []}
                formatCurrency={data?.formatCurrency || ((amount: number) => `₫${amount.toLocaleString()}`)}
              />
            </div>
          </div>

          {/* Right Column: Recent Activity */}
          <div className={styles.contentSection}>
            <div className={styles.sectionHeader}>
              <h2 className={styles.sectionTitle}>Recent Activity</h2>
              <a
                href="/finance/transaction-history"
                className={styles.viewAllLink}
                onClick={handleViewAllClick}
              >
                View All
              </a>
            </div>
            <div className={styles.sectionContent}>
              {data && data.recentTransactions.length > 0 ? (
                <div className={styles.transactionsList}>
                  {data.recentTransactions.slice(0, 5).map((transaction) => (
                    <div key={transaction.id} className={styles.transactionItem}>
                      <div className={styles.transactionIcon}>
                        {transaction.type === 'income' ? (
                          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M7,15H9C9,16.08 10.37,17 12,17C13.63,17 15,16.08 15,15C15,13.9 13.96,13.5 11.76,12.97C9.64,12.44 7,11.78 7,9C7,7.21 8.47,5.69 10.5,5.18V3H13.5V5.18C15.53,5.69 17,7.21 17,9H15C15,7.92 13.63,7 12,7C10.37,7 9,7.92 9,9C9,10.1 10.04,10.5 12.24,11.03C14.36,11.56 17,12.22 17,15C17,16.79 15.53,18.31 13.5,18.82V21H10.5V18.82C8.47,18.31 7,16.79 7,15Z"/>
                          </svg>
                        ) : (
                          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z"/>
                          </svg>
                        )}
                      </div>
                      <div className={styles.transactionInfo}>
                        <p className={styles.transactionDescription}>{transaction.description}</p>
                        <p className={styles.transactionDate}>
                          {DateTimeUtils.formatTransactionDate(transaction.date)}
                        </p>
                      </div>
                      <div
                        className={`${styles.transactionAmount} ${
                          transaction.type === 'income' ? styles.income : styles.expense
                        }`}
                      >
                        {transaction.type === 'income' ? '+' : '-'}
                        {data?.formatCurrency(transaction.amount) || `₫${transaction.amount.toLocaleString()}`}
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className={styles.emptyTransactions}>
                  <p>{DashboardMessages.emptyStates.noTransactions}</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>

      {/* ErrorMessage Dialog - Data Loading Errors */}
      <ErrorMessage
        variant={errorDialog.variant}
        title={errorDialog.title}
        message={errorDialog.message}
        isOpen={errorDialog.isOpen}
        onClose={clearError}
        confirmText={DashboardMessages.actions.retry}
        onConfirm={refresh}
      />

      {/* ErrorMessage Dialog - Permission Error */}
      <ErrorMessage
        variant="warning"
        title="Access Denied"
        message="You don't have permission to access the Transaction History page. Please contact your administrator."
        isOpen={showPermissionError}
        onClose={() => setShowPermissionError(false)}
        confirmText="OK"
      />
    </>
  );
};

export default DashboardPage;
