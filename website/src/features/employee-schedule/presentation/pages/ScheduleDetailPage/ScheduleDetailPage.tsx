/**
 * ScheduleDetailPage Component
 * Weekly schedule view for a specific store
 */

import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossButton } from '@/shared/components/toss/TossButton';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { useAppState } from '@/app/providers/app_state_provider';
import { useSchedule } from '../../hooks/useSchedule';
import { AddEmployeeModal } from '../../components/AddEmployeeModal';
import type { ScheduleDetailPageProps } from './ScheduleDetailPage.types';
import styles from './ScheduleDetailPage.module.css';

export const ScheduleDetailPage: React.FC<ScheduleDetailPageProps> = () => {
  const { storeId } = useParams<{ storeId: string }>();
  const navigate = useNavigate();
  const { currentCompany } = useAppState();

  const companyId = currentCompany?.company_id || '';
  const scheduleStoreId = storeId || '';

  const {
    shifts,
    employees,
    loading,
    loadingEmployees,
    error,
    refresh,
    goToPreviousWeek,
    goToNextWeek,
    goToCurrentWeek,
    getAssignmentsForDate,
    getWeekDays,
    createAssignment,
  } = useSchedule(companyId, scheduleStoreId);

  // Modal state
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedDate, setSelectedDate] = useState<string>('');
  const [addingEmployee, setAddingEmployee] = useState(false);

  // Get selected store name
  const stores = currentCompany?.stores || [];
  const selectedStore = stores.find((s) => s.store_id === scheduleStoreId);
  const selectedStoreName = selectedStore?.store_name || 'Store';

  // Handler to go back to dashboard
  const handleBackToDashboard = () => {
    navigate('/employee/schedule');
  };

  // Handler to open add employee modal
  const handleOpenAddEmployeeModal = (date: string) => {
    setSelectedDate(date);
    setIsModalOpen(true);
  };

  // Handler to close modal
  const handleCloseModal = () => {
    setIsModalOpen(false);
    setSelectedDate('');
  };

  // Handler to add employee to shift
  const handleAddEmployee = async (shiftId: string, employeeId: string, date: string) => {
    setAddingEmployee(true);
    try {
      const result = await createAssignment(shiftId, employeeId, date);

      if (!result.success) {
        throw new Error(result.error || 'Failed to add employee to shift');
      }

      // Success - modal will close automatically
    } catch (error) {
      console.error('Failed to add employee:', error);
      throw error;
    } finally {
      setAddingEmployee(false);
    }
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
  if (!currentCompany || !storeId) {
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

  if (loading) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.container}>
          <div className={styles.header}>
            <div className={styles.breadcrumb}>
              <TossButton variant="ghost" size="sm" onClick={handleBackToDashboard}>
                ← Back to Dashboard
              </TossButton>
            </div>
            <h1 className={styles.title}>{selectedStoreName} - Schedule</h1>
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
            <div className={styles.breadcrumb}>
              <TossButton variant="ghost" size="sm" onClick={handleBackToDashboard}>
                ← Back to Dashboard
              </TossButton>
            </div>
            <h1 className={styles.title}>{selectedStoreName} - Schedule</h1>
          </div>
          <div className={styles.errorContainer}>
            <div className={styles.errorIcon}>
              <svg width="64" height="64" viewBox="0 0 24 24" fill="currentColor">
                <path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
              </svg>
            </div>
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
              <div className={styles.emptyIcon}>
                <svg width="64" height="64" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/>
                </svg>
              </div>
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
                        <>
                          {dayAssignments.map((assignment) => (
                            <div
                              key={assignment.assignmentId}
                              className={styles.assignmentCard}
                              style={{ borderLeftColor: assignment.shift.color }}
                            >
                              <div className={styles.assignmentName}>
                                {assignment.fullName || 'Unknown Employee'}
                              </div>
                              <div className={styles.assignmentShift}>
                                {assignment.shift.shiftName}
                              </div>
                              <div className={styles.assignmentTime}>{assignment.shift.timeRange}</div>
                              <span className={`${styles.statusBadge} ${styles[assignment.status]}`}>
                                {assignment.status}
                              </span>
                            </div>
                          ))}
                        </>
                      )}

                      {/* Add Employee Button */}
                      <button
                        className={styles.addEmployeeButton}
                        onClick={() => handleOpenAddEmployeeModal(date)}
                      >
                        <svg
                          className={styles.addIcon}
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="2"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        >
                          <line x1="12" y1="5" x2="12" y2="19" />
                          <line x1="5" y1="12" x2="19" y2="12" />
                        </svg>
                        <span>Add Employee</span>
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Employee List */}
        <div className={styles.employeeSection}>
          <h3 className={styles.sectionTitle}>Employees ({employees.length})</h3>
          {loadingEmployees ? (
            <div className={styles.employeeLoading}>Loading employees...</div>
          ) : employees.length === 0 ? (
            <div className={styles.noEmployees}>No employees found for this store</div>
          ) : (
            <div className={styles.employeeGrid}>
              {employees.map((employee) => (
                <div key={employee.userId} className={styles.employeeCard}>
                  <div className={styles.employeeAvatar}>{employee.initials}</div>
                  <div className={styles.employeeInfo}>
                    <div className={styles.employeeName}>{employee.fullName}</div>
                    <div className={styles.employeeRole}>{employee.displayRole}</div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Add Employee Modal */}
      <AddEmployeeModal
        isOpen={isModalOpen}
        onClose={handleCloseModal}
        selectedDate={selectedDate}
        shifts={shifts}
        employees={employees}
        onAddEmployee={handleAddEmployee}
        loading={addingEmployee}
      />
    </>
  );
};

export default ScheduleDetailPage;
