/**
 * DashboardPage Component
 * Main dashboard page with financial overview
 */

import React from 'react';
import { useDashboard } from '../../hooks/useDashboard';
import { OverviewCard } from '../../components/OverviewCard';
import type { DashboardPageProps } from './DashboardPage.types';
import styles from './DashboardPage.module.css';

export const DashboardPage: React.FC<DashboardPageProps> = ({ companyId = 'default' }) => {
  const { data, loading, error } = useDashboard(companyId);

  if (loading) {
    return (
      <div className={styles.container}>
        <div className={styles.header}>
          <h1 className={styles.title}>Dashboard</h1>
        </div>
        <div className={styles.overviewGrid}>
          {[1, 2, 3, 4].map((i) => (
            <OverviewCard
              key={i}
              title="Loading..."
              value=""
              icon={<span>📊</span>}
              loading={true}
            />
          ))}
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className={styles.container}>
        <div className={styles.header}>
          <h1 className={styles.title}>Dashboard</h1>
        </div>
        <div className={styles.errorContainer}>
          <div className={styles.errorIcon}>⚠️</div>
          <h2 className={styles.errorTitle}>Failed to Load Dashboard</h2>
          <p className={styles.errorMessage}>{error}</p>
        </div>
      </div>
    );
  }

  if (!data) {
    return (
      <div className={styles.container}>
        <div className={styles.header}>
          <h1 className={styles.title}>Dashboard</h1>
        </div>
        <div className={styles.emptyState}>
          <p>No dashboard data available</p>
        </div>
      </div>
    );
  }

  // Calculate change percentages
  const todayRevenueChange = data.todayRevenue > 0 ? 5.2 : 0; // TODO: Calculate from actual data
  const thisMonthChange = data.monthOverMonthGrowth;

  return (
    <div className={styles.container}>
      {/* Page Header */}
      <div className={styles.header}>
        <h1 className={styles.title}>Dashboard</h1>
        <div className={styles.headerActions}>
          <span className={styles.lastUpdated}>Last updated: {new Date().toLocaleTimeString()}</span>
        </div>
      </div>

      {/* Overview Cards Grid */}
      <div className={styles.overviewGrid}>
        <OverviewCard
          title="Today's Revenue"
          value={data.formattedTodayRevenue}
          icon={<span>💰</span>}
          changePercentage={todayRevenueChange}
          isPositive={todayRevenueChange >= 0}
        />
        <OverviewCard
          title="Today's Expense"
          value={data.formattedTodayExpense}
          icon={<span>💸</span>}
        />
        <OverviewCard
          title="This Month Revenue"
          value={data.formattedThisMonthRevenue}
          icon={<span>📈</span>}
          changePercentage={thisMonthChange}
          isPositive={data.isGrowthPositive}
        />
        <OverviewCard
          title="Last Month Revenue"
          value={data.formattedLastMonthRevenue}
          icon={<span>📊</span>}
        />
      </div>

      {/* Charts Section */}
      <div className={styles.chartsSection}>
        <div className={styles.chartCard}>
          <h2 className={styles.chartTitle}>Expense Breakdown</h2>
          {data.expenseBreakdown.length > 0 ? (
            <div className={styles.chartPlaceholder}>
              {/* TODO: Implement Chart.js chart */}
              <p>Chart will be implemented here</p>
              <div className={styles.expenseList}>
                {data.expenseBreakdown.map((item, index) => (
                  <div key={index} className={styles.expenseItem}>
                    <span className={styles.expenseCategory}>{item.category}</span>
                    <span className={styles.expenseAmount}>
                      {data.formatCurrency(item.amount)} ({item.percentage.toFixed(1)}%)
                    </span>
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div className={styles.emptyChart}>
              <p>No expense data available</p>
            </div>
          )}
        </div>
      </div>

      {/* Recent Transactions */}
      <div className={styles.transactionsSection}>
        <h2 className={styles.sectionTitle}>Recent Transactions</h2>
        {data.recentTransactions.length > 0 ? (
          <div className={styles.transactionsList}>
            {data.recentTransactions.map((transaction) => (
              <div key={transaction.id} className={styles.transactionItem}>
                <div className={styles.transactionInfo}>
                  <div className={styles.transactionDescription}>{transaction.description}</div>
                  <div className={styles.transactionDate}>
                    {new Date(transaction.date).toLocaleDateString()}
                  </div>
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
  );
};

export default DashboardPage;
