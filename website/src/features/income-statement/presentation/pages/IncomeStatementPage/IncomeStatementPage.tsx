/**
 * IncomeStatementPage Component
 * Complete implementation following ARCHITECTURE.md pattern
 *
 * State Management:
 * - Uses Zustand provider (no local useState)
 * - All state managed by income_statement_provider
 * - Clean separation of concerns
 */

import React, { useEffect } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useAppState } from '@/app/providers/app_state_provider';
import { IncomeStatementFilter } from '../../components/IncomeStatementFilter';
import { useIncomeStatement } from '../../hooks/useIncomeStatement';
import type { IncomeStatementFilters } from '../../components/IncomeStatementFilter';
import type {
  MonthlyIncomeStatementData,
  TwelveMonthIncomeStatementData
} from '../../../domain/entities/IncomeStatementData';
import styles from './IncomeStatementPage.module.css';

export const IncomeStatementPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const {
    monthlyData,
    twelveMonthData,
    currentFilters,
    currency,
    loading,
    messageState,
    closeMessage,
    loadMonthlyData,
    load12MonthData,
    clearData,
    setCurrentFilters,
  } = useIncomeStatement();

  // Handle company change
  useEffect(() => {
    clearData();
  }, [currentCompany?.company_id, clearData]);

  // Handle search
  const handleSearch = async (filters: IncomeStatementFilters) => {
    if (!currentCompany?.company_id) {
      console.error('No company selected');
      return;
    }

    // Update filters in provider
    setCurrentFilters(filters);

    const storeId = filters.store || null;

    if (filters.type === 'monthly') {
      await loadMonthlyData(
        currentCompany.company_id,
        storeId,
        filters.fromDate,
        filters.toDate
      );
    } else {
      await load12MonthData(
        currentCompany.company_id,
        storeId,
        filters.fromDate,
        filters.toDate
      );
    }
  };

  // Handle clear
  const handleClear = () => {
    clearData();
  };

  // Format number with currency
  const formatAmount = (amount: number | string | undefined | null): string => {
    if (amount === null || amount === undefined) return `${currency}0`;
    if (typeof amount === 'string') return amount;
    return `${currency}${amount.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 })}`;
  };

  // Calculate financial ratios from monthly data
  const calculateRatios = (data: MonthlyIncomeStatementData) => {
    let revenue = 0;
    let grossProfit = 0;
    let operatingIncome = 0;
    let netIncome = 0;
    let grossMargin = 0;
    let operatingMargin = 0;
    let netMargin = 0;
    let ebitda = 0;

    data.forEach((section) => {
      const sectionName = section.section.toLowerCase();

      if (sectionName === 'revenue') {
        revenue = typeof section.section_total === 'number' ? section.section_total : 0;
      } else if (sectionName === 'gross profit') {
        grossProfit = typeof section.section_total === 'number' ? section.section_total : 0;
      } else if (sectionName === 'operating income') {
        operatingIncome = typeof section.section_total === 'number' ? section.section_total : 0;
      } else if (sectionName === 'net income') {
        netIncome = typeof section.section_total === 'number' ? section.section_total : 0;
      } else if (sectionName === 'gross margin') {
        grossMargin = typeof section.section_total === 'number' ? section.section_total : 0;
      } else if (sectionName === 'operating margin') {
        operatingMargin = typeof section.section_total === 'number' ? section.section_total : 0;
      } else if (sectionName === 'net margin') {
        netMargin = typeof section.section_total === 'number' ? section.section_total : 0;
      } else if (sectionName === 'ebitda') {
        ebitda = typeof section.section_total === 'number' ? section.section_total : 0;
      }
    });

    return {
      revenue,
      grossProfit,
      operatingIncome,
      netIncome,
      grossMargin,
      operatingMargin,
      netMargin,
      ebitda,
    };
  };

  // Format date range for display
  const formatDateRange = (filters: IncomeStatementFilters | null): string => {
    if (!filters) return '';

    // Parse YYYY-MM-DD string safely (avoid timezone issues)
    const [fromYear, fromMonth, fromDay] = filters.fromDate.split('-').map(Number);
    const [toYear, toMonth, toDay] = filters.toDate.split('-').map(Number);

    const fromDate = new Date(fromYear, fromMonth - 1, fromDay);
    const toDate = new Date(toYear, toMonth - 1, toDay);

    const options: Intl.DateTimeFormatOptions = { year: 'numeric', month: 'short', day: 'numeric' };
    return `${fromDate.toLocaleDateString('en-US', options)} - ${toDate.toLocaleDateString('en-US', options)}`;
  };

  // Render Monthly View
  const renderMonthlyView = (data: MonthlyIncomeStatementData) => {
    const ratios = calculateRatios(data);

    return (
      <div className={styles.contentWrapper}>
        {/* Summary Cards */}
        <div className={styles.summaryCards}>
          <div className={`${styles.summaryCard} ${styles.revenue}`}>
            <div className={styles.cardLabel}>TOTAL REVENUE</div>
            <div className={styles.cardValue}>{formatAmount(ratios.revenue)}</div>
            <div className={styles.cardPercent}>{ratios.grossMargin.toFixed(2)}% Gross Margin</div>
          </div>
          <div className={`${styles.summaryCard} ${styles.profit}`}>
            <div className={styles.cardLabel}>GROSS PROFIT</div>
            <div className={styles.cardValue}>{formatAmount(ratios.grossProfit)}</div>
            <div className={styles.cardPercent}>{ratios.operatingMargin.toFixed(2)}% Operating Margin</div>
          </div>
          <div className={`${styles.summaryCard} ${styles.operating}`}>
            <div className={styles.cardLabel}>OPERATING INCOME</div>
            <div className={styles.cardValue}>{formatAmount(ratios.operatingIncome)}</div>
            <div className={styles.cardPercent}>EBITDA: {formatAmount(ratios.ebitda)}</div>
          </div>
          <div className={`${styles.summaryCard} ${styles.net}`}>
            <div className={styles.cardLabel}>NET INCOME</div>
            <div className={styles.cardValue}>{formatAmount(ratios.netIncome)}</div>
            <div className={styles.cardPercent}>{ratios.netMargin.toFixed(2)}% Net Margin</div>
          </div>
        </div>

        {/* Income Statement Table */}
        <div className={styles.tableContainer}>
          <div className={styles.tableHeader}>
            <h3 className={styles.tableTitle}>Income Statement</h3>
            <div className={styles.periodInfo}>For the Period Ended {formatDateRange(currentFilters)}</div>
          </div>

          <table className={styles.incomeTable}>
            <thead>
              <tr>
                <th className={styles.descriptionColumn}>Description</th>
                <th className={styles.amountColumn}>
                  Amount<br/>
                  <small className={styles.currencyNote}>(in {currency})</small>
                </th>
              </tr>
            </thead>
            <tbody>
              {data.map((section, sIdx) => {
                // Skip margin sections as they're shown in summary cards
                if (section.section.toLowerCase().includes('margin')) return null;

                // Determine section type for styling
                const sectionType = section.section.toLowerCase().replace(/ /g, '-');

                return (
                  <React.Fragment key={sIdx}>
                    {/* Section Header */}
                    <tr className={`${styles.sectionHeader} ${styles[sectionType] || ''}`}>
                      <td colSpan={2}>{section.section.toUpperCase()}</td>
                    </tr>

                    {/* Subcategories and Accounts */}
                    {section.subcategories && section.subcategories.map((subcategory, subIdx) => (
                      <React.Fragment key={`${sIdx}-${subIdx}`}>
                        {/* Subcategory Header */}
                        {subcategory.subcategory && (
                          <tr className={styles.subsectionHeader}>
                            <td colSpan={2}>{subcategory.subcategory}</td>
                          </tr>
                        )}

                        {/* Account Rows */}
                        {subcategory.accounts && subcategory.accounts.map((account, accIdx) => (
                          <tr key={`${sIdx}-${subIdx}-${accIdx}`} className={styles.accountRow}>
                            <td className={styles.accountName}>{account.account_name}</td>
                            <td className={styles.accountAmount}>{account.net_amount.toLocaleString('en-US')}</td>
                          </tr>
                        ))}
                      </React.Fragment>
                    ))}
                  </React.Fragment>
                );
              })}
            </tbody>
          </table>
        </div>

        {/* Key Financial Ratios */}
        <div className={styles.ratiosSection}>
          <h3 className={styles.ratiosTitle}>Key Financial Ratios</h3>
          <div className={styles.ratiosGrid}>
            <div className={styles.ratioCard}>
              <div className={styles.ratioLabel}>GROSS MARGIN</div>
              <div className={styles.ratioValue}>{ratios.grossMargin.toFixed(2)}%</div>
            </div>
            <div className={styles.ratioCard}>
              <div className={styles.ratioLabel}>OPERATING MARGIN</div>
              <div className={styles.ratioValue}>{ratios.operatingMargin.toFixed(2)}%</div>
            </div>
            <div className={styles.ratioCard}>
              <div className={styles.ratioLabel}>NET MARGIN</div>
              <div className={styles.ratioValue}>{ratios.netMargin.toFixed(2)}%</div>
            </div>
            <div className={styles.ratioCard}>
              <div className={styles.ratioLabel}>EBITDA MARGIN</div>
              <div className={styles.ratioValue}>
                {ratios.revenue !== 0 ? ((ratios.ebitda / ratios.revenue) * 100).toFixed(2) : '0.00'}%
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  };

  // Format month display (2025-01 -> 2025 JAN)
  const formatMonthDisplay = (monthString: string): string => {
    const [year, month] = monthString.split('-');
    const monthNames = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                       'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    const monthIndex = parseInt(month, 10) - 1;
    return `${year} ${monthNames[monthIndex]}`;
  };

  // Render 12-Month View
  const render12MonthView = (data: TwelveMonthIncomeStatementData) => {
    const { months, sections, summary } = data;

    return (
      <div className={styles.contentWrapper}>
        {/* Header Section */}
        <div className={styles.tableHeader}>
          <h3 className={styles.tableTitle}>Income Statement - 12 Month View</h3>
          <div className={styles.periodInfo}>
            Period: {summary?.period_info?.start_date || 'N/A'} to {summary?.period_info?.end_date || 'N/A'}
            {summary?.period_info?.store_name && ` (${summary.period_info.store_name})`}
            {!summary?.period_info?.store_name && ' (ALL STORES)'}
          </div>
        </div>

        <div className={styles.tableContainer}>
          <div className={styles.horizontalScroll}>
            <table className={`${styles.monthlyTable} ${styles.table12Month}`}>
              <thead>
                <tr>
                  <th className={styles.accountColumn}>
                    ACCOUNT<br/>
                    <small className={styles.currencyNote}>(in {currency})</small>
                  </th>
                  {months.map((month, idx) => (
                    <th key={idx} className={styles.monthColumn}>{formatMonthDisplay(month)}</th>
                  ))}
                  <th className={styles.totalColumn}>TOTAL</th>
                </tr>
              </thead>
              <tbody>
                {sections.map((section, sIdx) => {
                  // Skip margin sections
                  if (section.section.toLowerCase().includes('margin')) return null;

                  // Determine section type for styling
                  const sectionType = section.section.toLowerCase().replace(/ /g, '-');

                  return (
                  <React.Fragment key={sIdx}>
                    {/* Section Header Row */}
                    <tr className={`${styles.sectionHeader} ${styles[sectionType] || ''}`}>
                      <td colSpan={months.length + 2}>{section.section.toUpperCase()}</td>
                    </tr>

                    {/* Subcategories and Accounts */}
                    {section.subcategories && section.subcategories.map((subcategory, subIdx) => (
                      <React.Fragment key={`${sIdx}-${subIdx}`}>
                        {/* Subcategory Header */}
                        {subcategory.subcategory && (
                          <tr className={styles.subsectionHeader}>
                            <td colSpan={months.length + 2}>{subcategory.subcategory}</td>
                          </tr>
                        )}

                        {/* Account Rows */}
                        {subcategory.accounts && subcategory.accounts.map((account, accIdx) => (
                          <tr key={`${sIdx}-${subIdx}-${accIdx}`} className={styles.accountRow}>
                            <td className={styles.accountName}>{account.account_name}</td>
                            {months.map((month, mIdx) => (
                              <td key={mIdx} className={styles.accountAmount}>
                                {formatAmount(account.monthly_amounts?.[month] || 0)}
                              </td>
                            ))}
                            <td className={styles.accountAmount}>
                              {formatAmount(account.total || account.net_amount)}
                            </td>
                          </tr>
                        ))}

                        {/* Subcategory Total Row */}
                        {subcategory.subcategory && (
                          <tr className={styles.totalRow}>
                            <td className={styles.totalLabel}>Total {subcategory.subcategory}</td>
                            {months.map((month, mIdx) => (
                              <td key={mIdx} className={styles.totalAmount}>
                                {formatAmount(subcategory.subcategory_monthly_totals?.[month] || 0)}
                              </td>
                            ))}
                            <td className={styles.totalAmount}>
                              {formatAmount(subcategory.subcategory_total)}
                            </td>
                          </tr>
                        )}
                      </React.Fragment>
                    ))}

                    {/* Section Total Row */}
                    <tr className={`${styles.sectionTotal} ${styles[sectionType] || ''}`}>
                      <td className={styles.sectionTotalLabel}><strong>{section.section}</strong></td>
                      {months.map((month, mIdx) => (
                        <td key={mIdx} className={styles.sectionTotalAmount}>
                          {formatAmount(section.section_monthly_totals?.[month] || 0)}
                        </td>
                      ))}
                      <td className={styles.sectionTotalAmount}>
                        {formatAmount(section.section_total)}
                      </td>
                    </tr>
                  </React.Fragment>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
  };

  return (
    <>
      <Navbar activeItem="finance" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          <div className={styles.pageHeader}>
            <h1 className={styles.pageTitle}>Income Statement</h1>
            <p className={styles.pageSubtitle}>View revenue and expenses</p>
          </div>

          {/* Filter Section */}
          <IncomeStatementFilter
            onSearch={handleSearch}
            onClear={handleClear}
            className={styles.filterSection}
          />

          {/* Content Section */}
          <div className={styles.contentSection}>
          {loading && (
            <LoadingAnimation fullscreen size="large" />
          )}

          {!loading && !monthlyData && !twelveMonthData && (
            <div className={styles.emptyState}>
              <div className={styles.emptyIcon}>
                <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
                  <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>
                  <rect x="35" y="40" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
                  <rect x="40" y="35" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
                  <line x1="48" y1="45" x2="75" y2="45" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
                  <line x1="48" y1="52" x2="70" y2="52" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
                  <line x1="48" y1="59" x2="72" y2="59" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
                  <circle cx="60" cy="75" r="12" fill="#0064FF"/>
                  <path d="M56 75 L58 77 L64 71" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </div>
              <h2 className={styles.emptyTitle}>Select Filters to Load Income Statement</h2>
              <p className={styles.emptyText}>Choose Monthly type and date range, then click Search to view the income statement.</p>
            </div>
          )}

          {!loading && monthlyData && currentFilters?.type === 'monthly' && (
            renderMonthlyView(monthlyData)
          )}

          {!loading && twelveMonthData && currentFilters?.type === '12month' && (
            render12MonthView(twelveMonthData)
          )}
          </div>

          {/* ErrorMessage Dialog */}
          <ErrorMessage
            variant={messageState.variant}
            title={messageState.title}
            message={messageState.message}
            isOpen={messageState.isOpen}
            onClose={closeMessage}
          />
        </div>
      </div>
    </>
  );
};

export default IncomeStatementPage;
