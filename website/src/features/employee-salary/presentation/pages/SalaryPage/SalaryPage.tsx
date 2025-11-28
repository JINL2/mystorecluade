/**
 * SalaryPage Component
 * Employee salary management with expandable card layout and LeftFilter integration
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { SelectModal } from '@/shared/components/common/SelectModal';
import type { SelectOption } from '@/shared/components/common/SelectModal';
import { useSalary } from '../../hooks/useSalary';
import { useAppState } from '@/app/providers/app_state_provider';
import type { SalaryPageProps } from './SalaryPage.types';
import styles from './SalaryPage.module.css';

export const SalaryPage: React.FC<SalaryPageProps> = ({ initialMonth }) => {
  const { currentCompany, currentStore, setCurrentStore } = useAppState();
  const companyId = currentCompany?.company_id || '';
  const [searchQuery, setSearchQuery] = useState('');
  const [filterType, setFilterType] = useState<'all' | 'monthly' | 'hourly' | 'problems' | 'overtime'>('all');
  const [expandedCards, setExpandedCards] = useState<Set<string>>(new Set());
  const [showExportModal, setShowExportModal] = useState(false);

  // Use app state's currentStore for selected store
  const selectedStoreId = currentStore?.store_id || null;

  const {
    records,
    summary,
    loading,
    error,
    currentMonth,
    exporting,
    notification,
    setNotification,
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

  // Handler to select store - sync with App State
  const handleStoreSelect = (storeId: string | null) => {
    // Find the store object
    const selectedStore = stores.find((s) => s.store_id === storeId) || null;

    // Update App State (this will also update localStorage)
    setCurrentStore(selectedStore);
  };

  // Get stores for filter
  const stores = currentCompany?.stores || [];

  // Filter records
  const filteredRecords = records.filter((record) => {
    // Search filter
    if (searchQuery && !record.fullName.toLowerCase().includes(searchQuery.toLowerCase())) {
      return false;
    }
    // Store filter - null means "All Stores"
    // Check if the employee has actual payment in the selected store
    if (selectedStoreId) {
      // Use hasPaymentInStore to check if employee has payment > 0 in this store
      if (!record.hasPaymentInStore(selectedStoreId)) {
        return false;
      }
    }
    // Type filter (monthly/hourly - use salaryType field)
    if (filterType === 'monthly' && record.salaryType !== 'monthly') {
      return false;
    }
    if (filterType === 'hourly' && record.salaryType !== 'hourly') {
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

  // Handle export option selection
  const handleExportSelect = (value: string) => {
    setShowExportModal(false);
    const companyName = currentCompany?.company_name || 'Company';

    if (value === 'store') {
      // Export selected store only
      const storeName = currentStore?.store_name || 'Store';
      exportToExcel(selectedStoreId, companyName, storeName);
    } else {
      // Export entire company (null storeId)
      exportToExcel(null, companyName, 'AllStores');
    }
  };

  // Build export options for SelectModal
  const buildExportOptions = (): SelectOption[] => {
    const options: SelectOption[] = [];

    // Only show "Selected Store" option if a store is selected
    if (selectedStoreId && currentStore) {
      options.push({
        value: 'store',
        label: 'Selected Store Only',
        description: `Export data for "${currentStore.store_name}" only`,
        icon: (
          <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12,3L2,12H5V20H19V12H22L12,3M12,8.75A2.25,2.25 0 0,1 14.25,11A2.25,2.25 0 0,1 12,13.25A2.25,2.25 0 0,1 9.75,11A2.25,2.25 0 0,1 12,8.75M12,15C13.5,15 16.5,15.75 16.5,17.25V18H7.5V17.25C7.5,15.75 10.5,15 12,15Z" />
          </svg>
        ),
      });
    }

    // Always show "Entire Company" option
    options.push({
      value: 'company',
      label: 'Entire Company',
      description: 'Export data for all stores in the company',
      icon: (
        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
          <path d="M18,15H16V17H18M18,11H16V13H18M20,19H12V17H14V15H12V13H14V11H12V9H20M10,7H8V5H10M10,11H8V9H10M10,15H8V13H10M10,19H8V17H10M6,7H4V5H6M6,11H4V9H6M6,15H4V13H6M6,19H4V17H6M12,7V3H2V21H22V7H12Z" />
        </svg>
      ),
    });

    return options;
  };

  // Show loading if no company selected yet
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <LoadingAnimation size="large" fullscreen />
          </div>
        </div>
      </>
    );
  }

  if (loading) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <LoadingAnimation size="large" fullscreen />
          </div>
        </div>
      </>
    );
  }

  // Error handling moved to ErrorMessage component below

  // Build LeftFilter sections
  const filterSections: FilterSection[] = [
    {
      id: 'store-selector',
      title: 'Store',
      type: 'custom',
      customContent: (
        <StoreSelector
          stores={stores}
          selectedStoreId={selectedStoreId}
          onStoreSelect={handleStoreSelect}
          companyId={companyId}
          width="100%"
          showAllStoresOption={true}
        />
      ),
      defaultExpanded: true,
    },
    {
      id: 'search',
      title: 'Search',
      type: 'input',
      defaultExpanded: true,
      selectedValues: searchQuery,
      placeholder: 'Search by employee name...',
      onInputChange: setSearchQuery,
    },
    {
      id: 'employee-type',
      title: 'Employee Type',
      type: 'radio',
      defaultExpanded: true,
      selectedValues: filterType,
      options: [
        { value: 'all', label: 'All Employees' },
        { value: 'monthly', label: 'Monthly' },
        { value: 'hourly', label: 'Hourly' },
        { value: 'problems', label: 'Has Problems' },
        { value: 'overtime', label: 'Overtime' },
      ],
      onSelect: (value) => setFilterType(value as any),
    },
  ];

  return (
    <>
      <Navbar activeItem="employee" />
      <div className={styles.pageLayout}>
        {/* Left Sidebar Filter */}
        <div className={styles.sidebarWrapper}>
          <LeftFilter sections={filterSections} width={240} topOffset={64} />
        </div>

        {/* Main Content */}
        <div className={styles.mainContent}>
          <div className={styles.container}>
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
                onClick={() => setShowExportModal(true)}
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

          {/* Search Bar */}
          <div className={styles.searchBar}>
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
          </div>

          {/* Employee List */}
          {filteredRecords.length === 0 ? (
            <div className={styles.emptyState}>
              <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
                {/* Background Circle */}
                <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

                {/* Wallet/Card Base */}
                <rect x="30" y="45" width="60" height="40" rx="6" fill="white" stroke="#0064FF" strokeWidth="2"/>

                {/* Card Stripe */}
                <rect x="30" y="55" width="60" height="8" fill="#0064FF"/>

                {/* Card Chip */}
                <rect x="38" y="68" width="12" height="10" rx="2" fill="#E9ECEF"/>
                <line x1="41" y1="68" x2="41" y2="78" stroke="#ADB5BD" strokeWidth="1"/>
                <line x1="47" y1="68" x2="47" y2="78" stroke="#ADB5BD" strokeWidth="1"/>

                {/* Money Symbol */}
                <circle cx="75" cy="73" r="10" fill="#0064FF"/>
                <text x="75" y="78" textAnchor="middle" fill="white" fontSize="14" fontWeight="600">$</text>
              </svg>
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
                          <span className={`${styles.employeeType} ${styles[record.salaryType]}`}>
                            {record.salaryType === 'monthly' ? 'Monthly' : 'Hourly'}
                          </span>
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

          {/* Export Excel Modal */}
          <SelectModal
            isOpen={showExportModal}
            onClose={() => setShowExportModal(false)}
            onSelect={handleExportSelect}
            title="Export Excel"
            message="Select the scope of data to export"
            options={buildExportOptions()}
            cancelText="Cancel"
            isLoading={exporting}
          />

          {/* Error Message Modal */}
          {notification && (
        <ErrorMessage
          variant={notification.variant}
          title={notification.title}
          message={notification.message}
          isOpen={true}
          onClose={() => setNotification(null)}
          autoCloseDuration={notification.variant === 'success' ? 2000 : 0}
        />
          )}

          {/* Data Loading Error Modal */}
          {error && (
            <ErrorMessage
              variant="error"
              title="Failed to Load Salary Data"
              message={error}
              isOpen={true}
              onClose={() => {}}
              confirmText="Try Again"
              onConfirm={refresh}
            />
          )}
          </div>
        </div>
      </div>
    </>
  );
};

export default SalaryPage;
