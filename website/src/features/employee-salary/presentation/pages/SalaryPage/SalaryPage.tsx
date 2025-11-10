/**
 * SalaryPage Component
 * Employee salary management with expandable card layout (Backup design)
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useSalary } from '../../hooks/useSalary';
import { useAppState } from '@/app/providers/app_state_provider';
import type { SalaryPageProps } from './SalaryPage.types';
import styles from './SalaryPage.module.css';

export const SalaryPage: React.FC<SalaryPageProps> = ({ initialMonth }) => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const [selectedStore, setSelectedStore] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [filterType, setFilterType] = useState<'all' | 'monthly' | 'hourly' | 'problems' | 'overtime'>('all');
  const [expandedCards, setExpandedCards] = useState<Set<string>>(new Set());
  const [storeDropdownOpen, setStoreDropdownOpen] = useState(false);

  const {
    records,
    summary,
    loading,
    error,
    currentMonth,
    exporting,
    refresh,
    goToPreviousMonth,
    goToNextMonth,
    exportToExcel,
  } = useSalary(companyId, initialMonth);

  // Format month display (e.g., "2025-11")
  const formatMonthDisplay = (month: string): string => {
    return month;
  };

  // Toggle card expansion
  const toggleCard = (userId: string) => {
    const newExpanded = new Set(expandedCards);
    if (newExpanded.has(userId)) {
      newExpanded.delete(userId);
    } else {
      newExpanded.add(userId);
    }
    setExpandedCards(newExpanded);
  };

  // Filter records
  const filteredRecords = records.filter((record) => {
    // Search filter
    if (searchQuery && !record.fullName.toLowerCase().includes(searchQuery.toLowerCase())) {
      return false;
    }
    // Store filter
    if (selectedStore !== 'all' && record.storeName !== selectedStore) {
      return false;
    }
    // Type filter (monthly/hourly - we'll use role as proxy)
    if (filterType === 'monthly' && !record.roleName.toLowerCase().includes('monthly')) {
      return false;
    }
    if (filterType === 'hourly' && !record.roleName.toLowerCase().includes('hourly')) {
      return false;
    }
    if (filterType === 'problems' && record.status !== 'pending') {
      return false;
    }
    return true;
  });

  // Get employee initials
  const getInitials = (name: string): string => {
    if (!name) return '??';
    return name
      .split(' ')
      .map((n) => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2) || '??';
  };

  // Show loading if no company selected yet
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.pageContainer}>
          <div className={styles.salaryContainer}>
            <div className={styles.loadingState}>
              <div className={styles.spinner}>Please select a company first...</div>
            </div>
          </div>
        </div>
      </>
    );
  }

  if (loading) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.pageContainer}>
          <div className={styles.salaryContainer}>
            <div className={styles.loadingState}>
              <div className={styles.spinner}>Loading salary data...</div>
            </div>
          </div>
        </div>
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.pageContainer}>
          <div className={styles.salaryContainer}>
            <div className={styles.errorContainer}>
              <div className={styles.errorIcon}>⚠️</div>
              <h2 className={styles.errorTitle}>Failed to Load Salary Data</h2>
              <p className={styles.errorMessage}>{error}</p>
              <button onClick={refresh} className={styles.retryButton}>
                Try Again
              </button>
            </div>
          </div>
        </div>
      </>
    );
  }

  // Get unique stores for filter
  const stores = currentCompany?.stores || [];

  return (
    <>
      <Navbar activeItem="employee" />
      <div className={styles.pageContainer}>
        <div className={styles.salaryContainer}>
          {/* Header Section */}
          <div className={styles.salaryHeader}>
            <div className={styles.salaryTitleSection}>
              <h1 className={styles.salaryTitle}>Salary Management</h1>
              <p className={styles.salarySubtitle}>Manage employee compensation and payroll</p>
            </div>

            <div className={styles.periodControlsWrapper}>
              {/* Export Excel Button */}
              <button
                className={styles.exportExcelBtn}
                onClick={exportToExcel}
                disabled={exporting || records.length === 0}
              >
                {exporting ? (
                  <>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" className={styles.spinAnimation}>
                      <path d="M12,4V2A10,10 0 0,0 2,12H4A8,8 0 0,1 12,4Z" />
                    </svg>
                    <span>Exporting...</span>
                  </>
                ) : (
                  <>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z" />
                    </svg>
                    <span>Export Excel</span>
                  </>
                )}
              </button>

              {/* Period Selector */}
              <div className={styles.periodControls}>
                <button className={styles.periodNavBtn} onClick={goToPreviousMonth}>
                  ‹
                </button>
                <div className={styles.periodDisplay}>{formatMonthDisplay(currentMonth)}</div>
                <button className={styles.periodNavBtn} onClick={goToNextMonth}>
                  ›
                </button>
              </div>
            </div>
          </div>

          {/* Store Filter */}
          <div className={styles.controlsCard}>
            <div
              className={`${styles.controlSection} ${storeDropdownOpen ? styles.dropdownOpen : ''}`}
              onClick={() => setStoreDropdownOpen(!storeDropdownOpen)}
            >
              <svg className={styles.controlIcon} viewBox="0 0 24 24" fill="currentColor">
                <path d="M12,5.5A3.5,3.5 0 0,1 15.5,9A3.5,3.5 0 0,1 12,12.5A3.5,3.5 0 0,1 8.5,9A3.5,3.5 0 0,1 12,5.5M5,8C5.56,8 6.08,8.15 6.53,8.42C6.38,9.85 6.8,11.27 7.66,12.38C7.16,13.34 6.16,14 5,14A3,3 0 0,1 2,11A3,3 0 0,1 5,8M19,8A3,3 0 0,1 22,11A3,3 0 0,1 19,14C17.84,14 16.84,13.34 16.34,12.38C17.2,11.27 17.62,9.85 17.47,8.42C17.92,8.15 18.44,8 19,8M5.5,18.25C5.5,16.18 8.41,14.5 12,14.5C15.59,14.5 18.5,16.18 18.5,18.25V20H5.5V18.25M0,20V18.5C0,17.11 1.89,15.94 4.45,15.6C3.86,16.28 3.5,17.22 3.5,18.25V20H0M24,20H20.5V18.25C20.5,17.22 20.14,16.28 19.55,15.6C22.11,15.94 24,17.11 24,18.5V20Z" />
              </svg>
              <span className={styles.controlLabel}>
                {selectedStore === 'all' ? 'All Stores' : stores.find((s) => s.store_id === selectedStore)?.store_name}
              </span>
              <svg className={styles.controlDropdown} viewBox="0 0 24 24" fill="currentColor">
                <path d="M7,10L12,15L17,10H7Z" />
              </svg>

              {/* Store Dropdown */}
              {storeDropdownOpen && (
                <div
                  className={`${styles.storeFilterDropdown} ${storeDropdownOpen ? styles.active : ''}`}
                  onClick={(e) => e.stopPropagation()}
                >
                  <div
                    className={`${styles.storeFilterDropdownOption} ${selectedStore === 'all' ? styles.selected : ''}`}
                    onClick={() => {
                      setSelectedStore('all');
                      setStoreDropdownOpen(false);
                    }}
                  >
                    <svg className={styles.storeFilterDropdownOptionIcon} viewBox="0 0 24 24" fill="currentColor">
                      <path d="M12,5.5A3.5,3.5 0 0,1 15.5,9A3.5,3.5 0 0,1 12,12.5A3.5,3.5 0 0,1 8.5,9A3.5,3.5 0 0,1 12,5.5M5,8C5.56,8 6.08,8.15 6.53,8.42C6.38,9.85 6.8,11.27 7.66,12.38C7.16,13.34 6.16,14 5,14A3,3 0 0,1 2,11A3,3 0 0,1 5,8M19,8A3,3 0 0,1 22,11A3,3 0 0,1 19,14C17.84,14 16.84,13.34 16.34,12.38C17.2,11.27 17.62,9.85 17.47,8.42C17.92,8.15 18.44,8 19,8M5.5,18.25C5.5,16.18 8.41,14.5 12,14.5C15.59,14.5 18.5,16.18 18.5,18.25V20H5.5V18.25M0,20V18.5C0,17.11 1.89,15.94 4.45,15.6C3.86,16.28 3.5,17.22 3.5,18.25V20H0M24,20H20.5V18.25C20.5,17.22 20.14,16.28 19.55,15.6C22.11,15.94 24,17.11 24,18.5V20Z" />
                    </svg>
                    <span className={styles.storeFilterDropdownOptionText}>All Stores</span>
                    {selectedStore === 'all' && (
                      <svg className={styles.storeFilterDropdownOptionCheck} viewBox="0 0 24 24" fill="currentColor">
                        <path d="M21,7L9,19L3.5,13.5L4.91,12.09L9,16.17L19.59,5.59L21,7Z" />
                      </svg>
                    )}
                  </div>
                  {stores.map((store) => (
                    <div
                      key={store.store_id}
                      className={`${styles.storeFilterDropdownOption} ${selectedStore === store.store_id ? styles.selected : ''}`}
                      onClick={() => {
                        setSelectedStore(store.store_id);
                        setStoreDropdownOpen(false);
                      }}
                    >
                      <svg className={styles.storeFilterDropdownOptionIcon} viewBox="0 0 24 24" fill="currentColor">
                        <path d="M18,6H16V4A2,2 0 0,0 14,2H10A2,2 0 0,0 8,4V6H6A2,2 0 0,0 4,8V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8A2,2 0 0,0 18,6M10,4H14V6H10V4M18,20H6V8H18V20Z" />
                      </svg>
                      <span className={styles.storeFilterDropdownOptionText}>{store.store_name}</span>
                      {selectedStore === store.store_id && (
                        <svg className={styles.storeFilterDropdownOptionCheck} viewBox="0 0 24 24" fill="currentColor">
                          <path d="M21,7L9,19L3.5,13.5L4.91,12.09L9,16.17L19.59,5.59L21,7Z" />
                        </svg>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>

          {/* Summary Cards */}
          {summary && (
            <div className={styles.summarySection}>
              <div className={styles.summaryCard}>
                <div className={styles.summaryLabel}>
                  <svg className={styles.summaryIcon} viewBox="0 0 24 24" fill="currentColor">
                    <path d="M16,13C15.71,13 15.38,13 15.03,13.05C16.19,13.89 17,15 17,16.5V19H23V16.5C23,14.17 18.33,13 16,13M8,13C5.67,13 1,14.17 1,16.5V19H15V16.5C15,14.17 10.33,13 8,13M8,11A3,3 0 0,0 11,8A3,3 0 0,0 8,5A3,3 0 0,0 5,8A3,3 0 0,0 8,11M16,11A3,3 0 0,0 19,8A3,3 0 0,0 16,5A3,3 0 0,0 13,8A3,3 0 0,0 16,11Z" />
                  </svg>
                  Total Employees
                </div>
                <div className={styles.summaryValue}>{summary.totalEmployees}</div>
                <div className={styles.summaryDetail}>Monthly: {filteredRecords.length} | Hourly: 0</div>
              </div>

              <div className={styles.summaryCard}>
                <div className={styles.summaryLabel}>
                  <svg className={styles.summaryIcon} viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4M11,17V16H9V14H13V13H10A1,1 0 0,1 9,12V9A1,1 0 0,1 10,8H11V7H13V8H15V10H11V11H14A1,1 0 0,1 15,12V15A1,1 0 0,1 14,16H13V17H11Z" />
                  </svg>
                  Total Payment
                </div>
                <div className={`${styles.summaryValue} ${styles.total}`}>{summary.formattedTotalSalary}</div>
                <div className={styles.summaryDetail}>Base: {summary.formattedTotalSalary}</div>
              </div>

              <div className={styles.summaryCard}>
                <div className={styles.summaryLabel}>
                  <svg className={styles.summaryIcon} viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12,2A2,2 0 0,1 14,4C14,4.74 13.6,5.39 13,5.73V7H14A7,7 0 0,1 21,14H22A1,1 0 0,1 23,15V18A1,1 0 0,1 22,19H21V20A2,2 0 0,1 19,22H5A2,2 0 0,1 3,20V19H2A1,1 0 0,1 1,18V15A1,1 0 0,1 2,14H3A7,7 0 0,1 10,7H11V5.73C10.4,5.39 10,4.74 10,4A2,2 0 0,1 12,2M7.5,13A2.5,2.5 0 0,0 5,15.5A2.5,2.5 0 0,0 7.5,18A2.5,2.5 0 0,0 10,15.5A2.5,2.5 0 0,0 7.5,13M16.5,13A2.5,2.5 0 0,0 14,15.5A2.5,2.5 0 0,0 16.5,18A2.5,2.5 0 0,0 19,15.5A2.5,2.5 0 0,0 16.5,13Z" />
                  </svg>
                  Problems
                </div>
                <div className={`${styles.summaryValue} ${styles.problems}`}>0</div>
                <div className={styles.summaryDetail}>Total: 0 | Solved: 0</div>
              </div>
            </div>
          )}

          {/* Filter Bar */}
          <div className={styles.filterBar}>
            <div className={styles.searchBox}>
              <svg className={styles.searchIcon} viewBox="0 0 24 24" fill="currentColor">
                <path d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z" />
              </svg>
              <input
                type="text"
                className={styles.searchInput}
                placeholder="Search by employee name..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
            </div>

            <button
              className={`${styles.filterChip} ${filterType === 'all' ? styles.active : ''}`}
              onClick={() => setFilterType('all')}
            >
              All Employees
            </button>
            <button
              className={`${styles.filterChip} ${filterType === 'monthly' ? styles.active : ''}`}
              onClick={() => setFilterType('monthly')}
            >
              Monthly
            </button>
            <button
              className={`${styles.filterChip} ${filterType === 'hourly' ? styles.active : ''}`}
              onClick={() => setFilterType('hourly')}
            >
              Hourly
            </button>
            <button
              className={`${styles.filterChip} ${filterType === 'problems' ? styles.active : ''}`}
              onClick={() => setFilterType('problems')}
            >
              Has Problems
            </button>
            <button
              className={`${styles.filterChip} ${filterType === 'overtime' ? styles.active : ''}`}
              onClick={() => setFilterType('overtime')}
            >
              Overtime
            </button>
          </div>

          {/* Employee List */}
          {filteredRecords.length === 0 ? (
            <div className={styles.emptyState}>
              <div className={styles.emptyIcon}>📋</div>
              <h3 className={styles.emptyTitle}>No Salary Records</h3>
              <p className={styles.emptyText}>No employees found matching your criteria</p>
            </div>
          ) : (
            <div className={styles.employeeList}>
              {filteredRecords.map((record) => (
                <div
                  key={record.userId}
                  className={`${styles.employeeCard} ${expandedCards.has(record.userId) ? styles.expanded : ''}`}
                >
                  {/* Employee Header */}
                  <div className={styles.employeeHeader} onClick={() => toggleCard(record.userId)}>
                    <div className={styles.employeeMainInfo}>
                      <div className={styles.employeeIdentity}>
                        <div className={styles.employeeAvatar}>{getInitials(record.fullName)}</div>
                        <div className={styles.employeeInfo}>
                          <div className={styles.employeeName}>{record.fullName}</div>
                          <span className={`${styles.employeeType} ${styles.monthly}`}>Monthly</span>
                        </div>
                      </div>

                      <div className={styles.employeeSalarySummary}>
                        <div className={styles.totalPayment}>{record.formattedTotalSalary}</div>
                        <div className={styles.paymentBreakdown}>Base: {record.formattedBaseSalary}</div>
                      </div>
                    </div>

                    {/* Store Badges */}
                    <div className={styles.employeeStores}>
                      <span className={styles.storeBadge}>{record.storeName}</span>
                    </div>

                    {/* Quick Stats */}
                    <div className={styles.employeeQuickStats}>
                      <div className={styles.quickStat}>
                        <span className={styles.quickStatLabel}>Late:</span>
                        <span className={styles.quickStatValue}>0 times</span>
                      </div>
                      <div className={styles.quickStat}>
                        <span className={styles.quickStatLabel}>Overtime:</span>
                        <span className={styles.quickStatValue}>0 hours</span>
                      </div>
                      <div className={styles.quickStat}>
                        <span className={styles.quickStatLabel}>Bonus:</span>
                        <span className={`${styles.quickStatValue} ${styles.positive}`}>{record.formattedBonuses}</span>
                      </div>
                    </div>

                    <svg className={styles.expandIcon} viewBox="0 0 24 24" fill="currentColor">
                      <path d="M7,10L12,15L17,10H7Z" />
                    </svg>
                  </div>

                  {/* Employee Details (Expandable) */}
                  {expandedCards.has(record.userId) && (
                    <div className={styles.employeeDetails}>
                      <div className={styles.detailsContent}>
                        {/* Salary Breakdown Section */}
                        <div className={styles.detailSection}>
                          <h3 className={styles.detailSectionTitle}>Salary Breakdown</h3>
                          <div className={styles.salaryBreakdownTable}>
                            <div className={styles.breakdownRow}>
                              <span className={styles.breakdownLabel}>Base Salary</span>
                              <span className={styles.breakdownValue}>{record.formattedBaseSalary}</span>
                            </div>
                            <div className={styles.breakdownRow}>
                              <span className={styles.breakdownLabel}>Late Deduction</span>
                              <span className={`${styles.breakdownValue} ${styles.negative}`}>-{record.formattedDeductions}</span>
                            </div>
                            <div className={styles.breakdownRow}>
                              <span className={styles.breakdownLabel}>Overtime Payment</span>
                              <span className={`${styles.breakdownValue} ${styles.positive}`}>+{record.currencySymbol}0</span>
                            </div>
                            <div className={styles.breakdownRow}>
                              <span className={styles.breakdownLabel}>Bonus</span>
                              <span className={`${styles.breakdownValue} ${styles.positive}`}>+{record.formattedBonuses}</span>
                            </div>
                            <div className={styles.breakdownRow}>
                              <span className={styles.breakdownLabel}>Total Payment</span>
                              <span className={styles.breakdownValue}>{record.formattedTotalSalary}</span>
                            </div>
                          </div>
                        </div>

                        {/* Bank Information Section */}
                        <div className={styles.detailSection}>
                          <h3 className={styles.detailSectionTitle}>Bank Information</h3>
                          <div className={styles.salaryBreakdownTable}>
                            <div className={styles.breakdownRow}>
                              <span className={styles.breakdownLabel}>Bank Name</span>
                              <span className={`${styles.breakdownValue} ${styles.notRegistered}`}>Not registered</span>
                            </div>
                            <div className={styles.breakdownRow}>
                              <span className={styles.breakdownLabel}>Account Number</span>
                              <span className={`${styles.breakdownValue} ${styles.notRegistered}`}>Not registered</span>
                            </div>
                          </div>
                        </div>

                        {/* Store Assignments Section */}
                        <div className={styles.detailSection}>
                          <h3 className={styles.detailSectionTitle}>Store Assignments</h3>
                          <div className={styles.employeeStores}>
                            {record.storeName.split(', ').map((store, idx) => (
                              <span key={idx} className={styles.storeBadge}>{store}</span>
                            ))}
                          </div>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </>
  );
};

export default SalaryPage;
