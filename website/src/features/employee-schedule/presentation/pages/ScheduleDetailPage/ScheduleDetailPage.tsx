/**
 * ScheduleDetailPage Component
 * Weekly schedule view for a specific store
 */

import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Navbar } from '@/shared/components/common/Navbar';
import { TossButton } from '@/shared/components/toss/TossButton';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { useAppState } from '@/app/providers/app_state_provider';
import { useSchedule } from '../../hooks/useSchedule';
import { AddEmployeeModal } from '../../components/AddEmployeeModal';
import type { ScheduleDetailPageProps } from './ScheduleDetailPage.types';
import styles from './ScheduleDetailPage.module.css';

export const ScheduleDetailPage: React.FC<ScheduleDetailPageProps> = () => {
  const { storeId } = useParams<{ storeId: string }>();
  const navigate = useNavigate();
  const { currentCompany, currentUser } = useAppState();

  const companyId = currentCompany?.company_id || '';
  const scheduleStoreId = storeId || '';
  const currentUserId = currentUser?.user_id || '';

  // Get all state and actions from provider
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
    isAddEmployeeModalOpen,
    selectedDate,
    addingEmployee,
    notification,
    openAddEmployeeModal,
    closeAddEmployeeModal,
    setAddingEmployee,
    showNotification,
    clearNotification,
  } = useSchedule(companyId, scheduleStoreId);

  // Get selected store name
  const stores = currentCompany?.stores || [];
  const selectedStore = stores.find((s) => s.store_id === scheduleStoreId);
  const selectedStoreName = selectedStore?.store_name || 'Store';

  // Handler to go back to dashboard
  const handleBackToDashboard = () => {
    navigate('/employee/schedule');
  };

  // Handler to add employee to shift
  const handleAddEmployee = async (shiftId: string, employeeId: string, date: string) => {
    setAddingEmployee(true);
    try {
      if (!currentUserId) {
        showNotification({
          variant: 'error',
          title: 'Authentication Error',
          message: 'You must be logged in to add employees to shifts',
        });
        return;
      }

      const result = await createAssignment(shiftId, employeeId, date, currentUserId);

      if (!result.success) {
        showNotification({
          variant: 'error',
          title: 'Failed to Add Employee',
          message: result.error || 'Failed to add employee to shift',
        });
        return;
      }

      // Success - show success message and close modal
      showNotification({
        variant: 'success',
        title: 'Success',
        message: 'Employee successfully added to shift',
      });
      closeAddEmployeeModal();

      // Refresh schedule data after successful creation
      refresh();
    } catch (error) {
      showNotification({
        variant: 'error',
        title: 'Unexpected Error',
        message: error instanceof Error ? error.message : 'An unexpected error occurred',
      });
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
        <div className={styles.pageLayout}>
          <div className={styles.container}>
            <div className={styles.header}>
              <h1 className={styles.title}>Employee Schedule</h1>
            </div>
            <LoadingAnimation fullscreen />
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
        </div>
      </>
    );
  }

  // Show error dialog if loading schedule failed
  if (error) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.pageLayout}>
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
        </div>
        <ErrorMessage
          variant="error"
          title="Failed to Load Schedule"
          message={error}
          isOpen={true}
          onClose={handleBackToDashboard}
          confirmText="Try Again"
          onConfirm={refresh}
        />
      </>
    );
  }

  const weekDays = getWeekDays();

  return (
    <>
      <Navbar activeItem="employee" />
      <div className={styles.pageLayout}>
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
                        onClick={() => openAddEmployeeModal(date)}
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
            <LoadingAnimation />
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

        {/* Add Employee Modal */}
        <AddEmployeeModal
          isOpen={isAddEmployeeModalOpen}
          onClose={closeAddEmployeeModal}
          selectedDate={selectedDate}
          shifts={shifts}
          employees={employees}
          onAddEmployee={handleAddEmployee}
          loading={addingEmployee}
        />

        {/* Notification Dialog */}
        {notification && (
          <ErrorMessage
            variant={notification.variant}
            title={notification.title}
            message={notification.message}
            isOpen={true}
            onClose={clearNotification}
          />
        )}
        </div>
      </div>
    </>
  );
};

export default ScheduleDetailPage;
