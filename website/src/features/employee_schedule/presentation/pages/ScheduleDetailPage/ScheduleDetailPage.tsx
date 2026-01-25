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
import { WeekNavigator } from '../../components/WeekNavigator';
import { ScheduleGrid } from '../../components/ScheduleGrid';
import { EmployeeSection } from '../../components/EmployeeSection';
import { ScheduleEmptyState } from '../../components/ScheduleEmptyState';
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

      showNotification({
        variant: 'success',
        title: 'Success',
        message: 'Employee successfully added to shift',
      });
      closeAddEmployeeModal();
      refresh();
    } catch (err) {
      showNotification({
        variant: 'error',
        title: 'Unexpected Error',
        message: err instanceof Error ? err.message : 'An unexpected error occurred',
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

  // Dummy drag handlers (ScheduleDetailPage doesn't support drag & drop)
  const handleCellDragOver = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
  };
  const handleCellDragEnter = () => {};
  const handleCellDragLeave = () => {};
  const handleCellDrop = () => {};

  const weekDays = getWeekDays();

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
            <ScheduleEmptyState
              variant="error"
              error={error}
              onAction={refresh}
              actionText="Try Again"
            />
          </div>
        </div>
      </>
    );
  }

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
          <WeekNavigator
            weekDisplay={formatWeekDisplay()}
            onPreviousWeek={goToPreviousWeek}
            onNextWeek={goToNextWeek}
            onCurrentWeek={goToCurrentWeek}
          />

          {/* Schedule Grid */}
          <div className={styles.scheduleSection}>
            {weekDays.length === 0 || shifts.length === 0 ? (
              <ScheduleEmptyState
                variant="no-schedule"
                message={
                  shifts.length === 0
                    ? 'No shifts configured for this store'
                    : 'No schedule data for the selected week'
                }
              />
            ) : (
              <ScheduleGrid
                weekDays={weekDays}
                shifts={shifts}
                getAssignmentsForDate={getAssignmentsForDate}
                dropTarget={null}
                onOpenAddEmployeeModal={openAddEmployeeModal}
                onCellDragOver={handleCellDragOver}
                onCellDragEnter={handleCellDragEnter}
                onCellDragLeave={handleCellDragLeave}
                onCellDrop={handleCellDrop}
              />
            )}
          </div>

          {/* Employee Section */}
          <EmployeeSection
            employees={employees}
            loading={loadingEmployees}
            draggedEmployeeId={null}
            showDragHint={false}
            onDragStart={() => {}}
            onDragEnd={() => {}}
          />

          {/* Add Employee Modal */}
          <AddEmployeeModal
            isOpen={isAddEmployeeModalOpen}
            onClose={closeAddEmployeeModal}
            selectedDate={selectedDate}
            shifts={shifts}
            employees={employees}
            assignments={getAssignmentsForDate(selectedDate)}
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
