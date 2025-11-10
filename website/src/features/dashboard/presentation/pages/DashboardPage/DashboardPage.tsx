/**
 * DashboardPage Component
 * Main dashboard page with financial overview
 */

import React from 'react';
import { useDashboard } from '../../hooks/useDashboard';
import { OverviewCard } from '../../components/OverviewCard';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import type { DashboardPageProps } from './DashboardPage.types';
import styles from './DashboardPage.module.css';

export const DashboardPage: React.FC<DashboardPageProps> = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const { data, loading, error } = useDashboard(companyId);

  // Show loading if no company selected yet
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="dashboard" />
        <div className={styles.container}>
          <div className={styles.dashboardMain}>
            <div className={styles.header}>
              <div className={styles.headerContent}>
                <h1 className={styles.title}>Dashboard</h1>
              </div>
            </div>
            <div className={styles.overviewGrid}>
              {[1, 2, 3, 4].map((i) => (
                <OverviewCard
                  key={`loading-${i}`}
                  title="Loading..."
                  value=""
                  icon={<span>📊</span>}
                  loading={true}
                />
              ))}
            </div>
          </div>
        </div>
      </>
    );
  }

  if (loading) {
    return (
      <>
        <Navbar activeItem="dashboard" />
        <div className={styles.container}>
          <div className={styles.dashboardMain}>
            <div className={styles.header}>
              <div className={styles.headerContent}>
                <h1 className={styles.title}>Dashboard</h1>
              </div>
            </div>
            <div className={styles.overviewGrid}>
              {[1, 2, 3, 4].map((i) => (
                <OverviewCard
                  key={`loading-card-${i}`}
                  title="Loading..."
                  value=""
                  icon={<span>📊</span>}
                  loading={true}
                />
              ))}
            </div>
          </div>
        </div>
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="dashboard" />
        <div className={styles.container}>
          <div className={styles.dashboardMain}>
            <div className={styles.header}>
              <div className={styles.headerContent}>
                <h1 className={styles.title}>Dashboard</h1>
              </div>
            </div>
            <div className={styles.errorContainer}>
              <div className={styles.errorIcon}>⚠️</div>
              <h2 className={styles.errorTitle}>Failed to Load Dashboard</h2>
              <p className={styles.errorMessage}>{error}</p>
            </div>
          </div>
        </div>
      </>
    );
  }

  if (!data) {
    return (
      <>
        <Navbar activeItem="dashboard" />
        <div className={styles.container}>
          <div className={styles.dashboardMain}>
            <div className={styles.header}>
              <div className={styles.headerContent}>
                <h1 className={styles.title}>Dashboard</h1>
              </div>
            </div>
            <div className={styles.emptyState}>
              <p>No dashboard data available</p>
            </div>
          </div>
        </div>
      </>
    );
  }

  // Calculate change percentages
  const todayRevenueChange = data.todayRevenue > 0 ? 5.2 : 0; // TODO: Calculate from actual data
  const thisMonthChange = data.monthOverMonthGrowth;

  return (
    <>
      <Navbar activeItem="dashboard" />
      <div className={styles.container}>
        {/* Dashboard Main Content */}
        <div className={styles.dashboardMain}>
          {/* Page Header */}
          <div className={styles.header}>
            <div className={styles.headerContent}>
              <h1 className={styles.title}>Dashboard</h1>
            </div>
          </div>

          {/* Overview Cards Grid */}
          <div className={styles.overviewGrid}>
          <OverviewCard
            key="today-revenue"
            title="Today Revenue"
            value={data.formattedTodayRevenue}
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
            value={data.formattedTodayExpense}
            icon={
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M3,6H21V18H3V6M12,9A3,3 0 0,1 15,12A3,3 0 0,1 12,15A3,3 0 0,1 9,12A3,3 0 0,1 12,9M7,8A2,2 0 0,1 5,10V14A2,2 0 0,1 7,16H17A2,2 0 0,1 19,14V10A2,2 0 0,1 17,8H7Z"/>
              </svg>
            }
          />
          <OverviewCard
            key="this-month-revenue"
            title="This Month Revenue"
            value={data.formattedThisMonthRevenue}
            icon={
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M16,6L18.29,8.29L13.41,13.17L9.41,9.17L2,16.59L3.41,18L9.41,12L13.41,16L19.71,9.71L22,12V6H16Z"/>
              </svg>
            }
            changePercentage={thisMonthChange}
            isPositive={data.isGrowthPositive}
          />
          <OverviewCard
            key="last-month-revenue"
            title="Last Month Revenue"
            value={data.formattedLastMonthRevenue}
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
              {data.expenseBreakdown.length > 0 ? (
                <div className={styles.expenseList}>
                  {data.expenseBreakdown.map((item) => (
                    <div key={item.category} className={styles.expenseItem}>
                      <span className={styles.expenseCategory}>{item.category}</span>
                      <span className={styles.expenseAmount}>
                        {data.formatCurrency(item.amount)} ({item.percentage.toFixed(1)}%)
                      </span>
                    </div>
                  ))}
                </div>
              ) : (
                <div className={styles.emptyChart}>
                  <p>No expense data available for this month</p>
                </div>
              )}
            </div>
          </div>

          {/* Right Column: Recent Activity */}
          <div className={styles.contentSection}>
            <div className={styles.sectionHeader}>
              <h2 className={styles.sectionTitle}>Recent Activity</h2>
              <a href="/transactions" className={styles.viewAllLink}>
                View All
              </a>
            </div>
            <div className={styles.sectionContent}>
              {data.recentTransactions.length > 0 ? (
                <div className={styles.transactionsList}>
                  {data.recentTransactions.slice(0, 5).map((transaction) => (
                    <div key={transaction.id} className={styles.transactionItem}>
                      <div className={styles.transactionIcon}>
                        <span>{transaction.type === 'income' ? '💵' : '📄'}</span>
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
                        {data.formatCurrency(transaction.amount)}
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className={styles.emptyTransactions}>
                  <p>No recent transactions</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
    </>
  );
};

export default DashboardPage;
