/**
 * EmployeeSettingPage Component
 * Employee management page matching backup design
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useEmployees } from '../../hooks/useEmployees';
import { EmployeeCard } from '../../components/EmployeeCard';
import { EditEmployeeModal } from '../../components/EditEmployeeModal';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { useAppState } from '@/app/providers/app_state_provider';
import type { EmployeeSettingPageProps } from './EmployeeSettingPage.types';
import styles from './EmployeeSettingPage.module.css';

export const EmployeeSettingPage: React.FC<EmployeeSettingPageProps> = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';

  // Show error if no company selected
  if (!companyId) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Team Management</h1>
          </div>
          <div className={styles.errorContainer}>
            <div className={styles.errorIcon}>⚠️</div>
            <h2 className={styles.errorTitle}>No Company Selected</h2>
            <p className={styles.errorMessage}>Please select a company to view employees</p>
          </div>
        </div>
      </>
    );
  }
  const { employees, stats, loading, error, storeFilter, filterByStore, refresh } =
    useEmployees(companyId);

  // Modal state
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [selectedEmployee, setSelectedEmployee] = useState<{
    userId: string;
    fullName: string;
    email: string;
    roleName: string;
    storeName: string;
    salaryType: 'monthly' | 'hourly';
    salaryAmount: number;
    currencyId: string;
    currencyCode: string;
    salaryId: string;
    companyId: string;
    accountId: string;
    initials: string;
  } | null>(null);

  const handleEditEmployee = (userId: string) => {
    const employee = employees.find((emp) => emp.userId === userId);
    if (employee) {
      setSelectedEmployee({
        userId: employee.userId,
        fullName: employee.fullName,
        email: employee.email,
        roleName: employee.displayRole,
        storeName: employee.displayStore,
        salaryType: employee.salaryType,
        salaryAmount: employee.salaryAmount,
        currencyId: employee.currencyId,
        currencyCode: employee.currencyCode,
        salaryId: employee.salaryId,
        companyId: employee.companyId,
        accountId: employee.accountId,
        initials: employee.initials,
      });
      setIsEditModalOpen(true);
    }
  };

  const handleCloseEditModal = () => {
    setIsEditModalOpen(false);
    setSelectedEmployee(null);
  };

  const handleSaveEmployee = () => {
    // Refresh employee list after save
    refresh();
  };

  const handleDeleteEmployee = (userId: string) => {
    // TODO: Implement delete confirmation
    if (confirm('Are you sure you want to delete this employee?')) {
      alert(`Delete employee: ${userId}`);
    }
  };

  // Get stores from current company
  const stores = currentCompany?.stores || [];

  if (loading) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Team Management</h1>
          </div>
          <div className={styles.loadingState}>
            <div className={styles.spinner}>Loading employees...</div>
          </div>
        </div>
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Team Management</h1>
          </div>
          <div className={styles.errorContainer}>
            <div className={styles.errorIcon}>⚠️</div>
            <h2 className={styles.errorTitle}>Failed to Load Employees</h2>
            <p className={styles.errorMessage}>{error}</p>
            <button onClick={refresh} className={styles.retryButton}>
              Try Again
            </button>
          </div>
        </div>
      </>
    );
  }


  return (
    <>
      <Navbar activeItem="employee" />
      <div className={styles.container}>
        {/* Page Header */}
        <div className={styles.header}>
          <h1 className={styles.title}>Team Management</h1>
        </div>

        {/* Stats Card - Total Employees Only */}
        <div className={styles.statsContainer}>
          <div className={styles.statCard}>
            <div className={styles.statIcon}>
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z" />
              </svg>
            </div>
            <div className={styles.statContent}>
              <div className={styles.statLabel}>TOTAL EMPLOYEES</div>
              <div className={styles.statValue}>{stats.totalEmployees}</div>
            </div>
          </div>
        </div>

        {/* Store Filter */}
        <div className={styles.filterSection}>
          <StoreSelector
            stores={stores}
            selectedStoreId={storeFilter}
            onStoreSelect={filterByStore}
            companyId={companyId}
            width="100%"
          />
        </div>

        {/* Team Members Section */}
        <div className={styles.employeeSection}>
          <div className={styles.sectionHeader}>
            <div className={styles.sectionTitleContainer}>
              <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor" className={styles.sectionIcon}>
                <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z" />
              </svg>
              <h2 className={styles.sectionTitle}>Team Members</h2>
            </div>
            <div className={styles.memberCount}>{employees.length} members</div>
          </div>

          {employees.length === 0 ? (
            <div className={styles.emptyState}>
              <div className={styles.emptyIcon}>👤</div>
              <h3 className={styles.emptyTitle}>No Employees Found</h3>
              <p className={styles.emptyText}>
                {storeFilter
                  ? 'No employees found for the selected store'
                  : 'No employees found in this company'}
              </p>
            </div>
          ) : (
            <div className={styles.employeeGrid}>
              {employees.map((employee) => (
                <EmployeeCard
                  key={employee.userId}
                  userId={employee.userId}
                  fullName={employee.fullName}
                  email={employee.email}
                  roleName={employee.displayRole}
                  storeName={employee.displayStore}
                  formattedSalary={employee.formattedSalary}
                  salaryTypeLabel={employee.salaryTypeLabel}
                  initials={employee.initials}
                  isActive={employee.isActive}
                  onEdit={handleEditEmployee}
                  onDelete={handleDeleteEmployee}
                />
              ))}
            </div>
          )}
        </div>

        {/* Edit Employee Modal */}
        <EditEmployeeModal
          isOpen={isEditModalOpen}
          onClose={handleCloseEditModal}
          employee={selectedEmployee}
          onSave={handleSaveEmployee}
        />
      </div>
    </>
  );
};

export default EmployeeSettingPage;
