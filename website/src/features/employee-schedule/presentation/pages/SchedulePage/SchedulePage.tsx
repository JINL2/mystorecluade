/**
 * SchedulePage Component
 * Employee schedule management with weekly calendar view
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useSchedule } from '../../hooks/useSchedule';
import { TossButton } from '@/shared/components/toss/TossButton';
import { useAppState } from '@/app/providers/app_state_provider';
import type { SchedulePageProps } from './SchedulePage.types';
import styles from './SchedulePage.module.css';

export const SchedulePage: React.FC<SchedulePageProps> = () => {
  const { currentCompany, currentStore } = useAppState();
  const [selectedStoreForSchedule, setSelectedStoreForSchedule] = useState<string | null>(null);

  const companyId = currentCompany?.company_id || '';

  // Use selected store for schedule, or current store as fallback
  const scheduleStoreId = selectedStoreForSchedule || currentStore?.store_id || '';

  const {
    shifts,
    loading,
    error,
    refresh,
    goToPreviousWeek,
    goToNextWeek,
    goToCurrentWeek,
    getAssignmentsForDate,
    getWeekDays,
  } = useSchedule(companyId, scheduleStoreId);

  // Get all stores from current company
  const stores = currentCompany?.stores || [];

  // Calculate total employees across all stores (placeholder - need actual data)
  const totalEmployees = stores.length * 8; // Placeholder calculation

  // Handler to show schedule for selected store
  const handleStoreClick = (storeId: string) => {
    setSelectedStoreForSchedule(storeId);
  };

  // Handler to go back to dashboard
  const handleBackToDashboard = () => {
    setSelectedStoreForSchedule(null);
  };

  // Format week display
  const formatWeekDisplay = (): string => {
    const weekDays = getWeekDays();
    if (weekDays.length === 0) return '';

    const start = new Date(weekDays[0]);
    const end = new Date(weekDays[weekDays.length - 1]);

    return `${start.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })} - ${end.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}`;
  };

  // Format day header
  const formatDayHeader = (date: string): string => {
    const d = new Date(date);
    return d.toLocaleDateString('en-US', { weekday: 'short', month: 'numeric', day: 'numeric' });
  };

  // Check if date is today
  const isToday = (date: string): boolean => {
    const today = new Date().toISOString().split('T')[0];
    return date === today;
  };

  // Show loading if app state is not ready
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Employee Schedule</h1>
          </div>
          <LoadingAnimation fullscreen />
        </div>
      </>
    );
  }

  // If no store is selected for schedule, show dashboard
  if (!selectedStoreForSchedule) {
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
  }

  if (loading) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.container}>
          <div className={styles.header}>
            <h1 className={styles.title}>Employee Schedule</h1>
          </div>
          <LoadingAnimation fullscreen />
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
            <h1 className={styles.title}>Employee Schedule</h1>
          </div>
          <div className={styles.errorContainer}>
            <svg className={styles.errorIcon} width="120" height="120" viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
              {/* Background Circle */}
              <circle cx="60" cy="60" r="50" fill="#FFEFED"/>

              {/* Error Triangle */}
              <path d="M60 30 L90 80 L30 80 Z" fill="white" stroke="#FF5847" strokeWidth="2"/>

              {/* Exclamation Mark */}
              <line x1="60" y1="50" x2="60" y2="65" stroke="#FF5847" strokeWidth="3" strokeLinecap="round"/>
              <circle cx="60" cy="72" r="2" fill="#FF5847"/>
            </svg>
            <h2 className={styles.errorTitle}>Failed to Load Schedule</h2>
            <p className={styles.errorMessage}>{error}</p>
            <TossButton onClick={refresh} variant="primary">
              Try Again
            </TossButton>
          </div>
        </div>
      </>
    );
  }

  const weekDays = getWeekDays();

  // Get selected store name
  const selectedStore = stores.find((s) => s.store_id === selectedStoreForSchedule);
  const selectedStoreName = selectedStore?.store_name || 'Store';

  return (
    <>
      <Navbar activeItem="employee" />
      <div className={styles.container}>
      {/* Page Header with Back Button */}
      <div className={styles.header}>
        <div>
          <div className={styles.breadcrumb}>
            <TossButton variant="ghost" size="sm" onClick={handleBackToDashboard}>
              ← Back to Dashboard
            </TossButton>
          </div>
          <h1 className={styles.title}>{selectedStoreName} - Schedule</h1>
          <p className={styles.subtitle}>Manage work shifts and assignments</p>
        </div>
      </div>

      {/* Week Navigator */}
      <div className={styles.weekNavigator}>
        <TossButton variant="outline" size="sm" onClick={goToPreviousWeek}>
          ◀ Previous Week
        </TossButton>
        <div className={styles.weekDisplay}>{formatWeekDisplay()}</div>
        <TossButton variant="outline" size="sm" onClick={goToNextWeek}>
          Next Week ▶
        </TossButton>
        <TossButton variant="outline" size="sm" onClick={goToCurrentWeek}>
          This Week
        </TossButton>
      </div>

      {/* Shift Legend */}
      {shifts.length > 0 && (
        <div className={styles.shiftLegend}>
          <h3 className={styles.legendTitle}>Shifts</h3>
          <div className={styles.legendItems}>
            {shifts.map((shift) => (
              <div key={shift.shiftId} className={styles.legendItem}>
                <div
                  className={styles.legendColor}
                  style={{ backgroundColor: shift.color }}
                ></div>
                <div className={styles.legendInfo}>
                  <span className={styles.legendName}>{shift.shiftName}</span>
                  <span className={styles.legendTime}>{shift.timeRange}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Schedule Grid */}
      <div className={styles.scheduleSection}>
        {weekDays.length === 0 ? (
          <div className={styles.emptyState}>
            <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
              {/* Background Circle */}
              <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

              {/* Calendar Base */}
              <rect x="30" y="35" width="60" height="55" rx="6" fill="white" stroke="#0064FF" strokeWidth="2"/>

              {/* Calendar Header */}
              <rect x="30" y="35" width="60" height="15" rx="6" fill="#0064FF"/>
              <rect x="30" y="43" width="60" height="7" fill="#0064FF"/>

              {/* Calendar Rings */}
              <circle cx="42" cy="35" r="3" fill="white"/>
              <circle cx="60" cy="35" r="3" fill="white"/>
              <circle cx="78" cy="35" r="3" fill="white"/>

              {/* Calendar Grid - Week Days */}
              <line x1="37" y1="58" x2="47" y2="58" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="52" y1="58" x2="62" y2="58" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="67" y1="58" x2="77" y2="58" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

              <line x1="37" y1="68" x2="47" y2="68" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="52" y1="68" x2="62" y2="68" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="67" y1="68" x2="77" y2="68" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

              <line x1="37" y1="78" x2="47" y2="78" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
              <line x1="52" y1="78" x2="62" y2="78" stroke="#0064FF" strokeWidth="3" strokeLinecap="round"/>
              <line x1="67" y1="78" x2="77" y2="78" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

              {/* Empty State Icon - Question Mark Circle */}
              <circle cx="60" cy="95" r="14" fill="#0064FF"/>
              <path d="M60 88 Q60 85 63 85 Q66 85 66 88 Q66 91 63 93 L60 95" stroke="white" strokeWidth="2.5" fill="none" strokeLinecap="round"/>
              <circle cx="60" cy="99" r="1.5" fill="white"/>
            </svg>
            <h3 className={styles.emptyTitle}>No Schedule Available</h3>
            <p className={styles.emptyText}>No schedule data for the selected week</p>
          </div>
        ) : (
          <div className={styles.scheduleGrid}>
            {weekDays.map((date) => {
              const dayAssignments = getAssignmentsForDate(date);
              const isTodayDate = isToday(date);

              return (
                <div
                  key={date}
                  className={`${styles.dayColumn} ${isTodayDate ? styles.today : ''}`}
                >
                  <div className={styles.dayHeader}>
                    <div className={styles.dayName}>{formatDayHeader(date)}</div>
                    {isTodayDate && <span className={styles.todayBadge}>Today</span>}
                  </div>
                  <div className={styles.assignmentList}>
                    {dayAssignments.length === 0 ? (
                      <div className={styles.noAssignments}>No shifts</div>
                    ) : (
                      dayAssignments.map((assignment) => (
                        <div
                          key={assignment.assignmentId}
                          className={styles.assignmentCard}
                          style={{ borderLeftColor: assignment.shift.color }}
                        >
                          <div className={styles.assignmentName}>{assignment.fullName}</div>
                          <div className={styles.assignmentShift}>
                            {assignment.shift.shiftName}
                          </div>
                          <div className={styles.assignmentTime}>{assignment.shift.timeRange}</div>
                          <span className={`${styles.statusBadge} ${styles[assignment.status]}`}>
                            {assignment.status}
                          </span>
                        </div>
                      ))
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
    </>
  );
};

export default SchedulePage;
