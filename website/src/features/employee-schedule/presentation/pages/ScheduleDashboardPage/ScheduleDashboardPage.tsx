/**
 * ScheduleDashboardPage Component
 * Overview of all stores and scheduling status
 */

import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useSchedule } from '../../hooks/useSchedule';
import type { ScheduleDashboardPageProps } from './ScheduleDashboardPage.types';
import styles from './ScheduleDashboardPage.module.css';

export const ScheduleDashboardPage: React.FC<ScheduleDashboardPageProps> = () => {
  const navigate = useNavigate();
  const { currentCompany, currentStore } = useAppState();

  const companyId = currentCompany?.company_id || '';
  const storeId = currentStore?.store_id || '';

  // Get shifts data for displaying in store cards
  const { shifts } = useSchedule(companyId, storeId);

  // Get all stores from current company
  const stores = currentCompany?.stores || [];

  // Calculate total employees across all stores (placeholder - need actual data)
  const totalEmployees = stores.length * 8; // Placeholder calculation

  // Handler to navigate to schedule detail page
  const handleStoreClick = (selectedStoreId: string) => {
    navigate(`/employee/schedule/${selectedStoreId}`);
  };

  // Show loading if app state is not ready
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Dashboard</h1>
          </div>
          <div className={styles.loadingState}>
            <div className={styles.spinner}>Loading company data...</div>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Navbar activeItem="employee" />
      <div className={styles.container}>
        {/* Dashboard View */}
        <div className={styles.header}>
          <h1 className={styles.title}>Dashboard</h1>
          <p className={styles.subtitle}>Overview of all stores and scheduling status</p>
        </div>

        {/* Overview Cards */}
        <div className={styles.overviewGrid}>
          <div className={styles.overviewCard}>
            <div className={styles.overviewIcon}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="currentColor">
                <path d="M20 4H4v2h16V4zm1 10v-2l-1-5H4l-1 5v2h1v6h10v-6h4v6h2v-6h1zm-9 4H6v-4h6v4z"/>
              </svg>
            </div>
            <div className={styles.overviewContent}>
              <div className={styles.overviewNumber}>{stores.length}</div>
              <div className={styles.overviewLabel}>Total Stores</div>
            </div>
          </div>
          <div className={styles.overviewCard}>
            <div className={styles.overviewIcon}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="currentColor">
                <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
              </svg>
            </div>
            <div className={styles.overviewContent}>
              <div className={styles.overviewNumber}>{totalEmployees}</div>
              <div className={styles.overviewLabel}>Total Employees</div>
            </div>
          </div>
          <div className={styles.overviewCard}>
            <div className={styles.overviewIcon}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
              </svg>
            </div>
            <div className={styles.overviewContent}>
              <div className={styles.overviewNumber}>0</div>
              <div className={styles.overviewLabel}>Total Requests</div>
            </div>
          </div>
          <div className={styles.overviewCard}>
            <div className={styles.overviewIcon}>
              <svg width="48" height="48" viewBox="0 0 24 24" fill="currentColor">
                <path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
              </svg>
            </div>
            <div className={styles.overviewContent}>
              <div className={styles.overviewNumber}>0</div>
              <div className={styles.overviewLabel}>Problems</div>
            </div>
          </div>
        </div>

        {/* Store Cards Grid */}
        <div className={styles.storesGrid}>
          {stores.map((store) => (
            <div
              key={store.store_id}
              className={styles.storeCard}
              onClick={() => handleStoreClick(store.store_id)}
            >
              <div className={styles.storeHeader}>
                <div className={styles.storeIcon}>
                  <svg width="32" height="32" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M20 4H4v2h16V4zm1 10v-2l-1-5H4l-1 5v2h1v6h10v-6h4v6h2v-6h1zm-9 4H6v-4h6v4z"/>
                  </svg>
                </div>
                <h3 className={styles.storeName}>{store.store_name}</h3>
              </div>
              <div className={styles.storeStats}>
                <div className={styles.employeeCount}>
                  <span className={styles.statNumber}>8</span>
                  <span className={styles.statLabel}>EMPLOYEES</span>
                </div>
              </div>
              <div className={styles.storeScheduleSection}>
                <h4 className={styles.scheduleSectionTitle}>SHIFT SCHEDULE</h4>
                <div className={styles.scheduleInfo}>
                  {shifts.length > 0 ? (
                    shifts.slice(0, 3).map((shift) => (
                      <div key={shift.shiftId} className={styles.shiftItem}>
                        <span className={styles.shiftName}>{shift.shiftName}</span>
                        <span className={styles.shiftTime}>{shift.timeRange}</span>
                      </div>
                    ))
                  ) : (
                    <div className={styles.noShifts}>No shifts scheduled</div>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </>
  );
};

export default ScheduleDashboardPage;
