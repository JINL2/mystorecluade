/**
 * SchedulePage Component
 * Employee schedule management with weekly calendar view
 * Integrated single-page design with LeftFilter + StoreSelector
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { AddEmployeeModal } from '../../components/AddEmployeeModal';
import { WeekNavigator } from '../../components/WeekNavigator';
import { ScheduleGrid } from '../../components/ScheduleGrid';
import { EmployeeSection } from '../../components/EmployeeSection';
import { ScheduleEmptyState } from '../../components/ScheduleEmptyState';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { SelectorModal } from '@/shared/components/common/SelectorModal';
import { useSchedule } from '../../hooks/useSchedule';
import { useScheduleDragDrop } from '../../hooks/useScheduleDragDrop';
import { useAppState } from '@/app/providers/app_state_provider';
import type { SchedulePageProps } from './SchedulePage.types';
import type { ScheduleAssignment } from '../../../domain/entities/ScheduleAssignment';
import styles from './SchedulePage.module.css';

export const SchedulePage: React.FC<SchedulePageProps> = () => {
  const { currentCompany, currentUser, currentStore, setCurrentStore } = useAppState();

  const companyId = currentCompany?.company_id || '';
  const currentUserId = currentUser?.user_id || '';

  // Get all state from provider
  const {
    shifts,
    assignments,
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
    selectedStoreId: scheduleStoreId,
    setSelectedStore: setScheduleStoreId,
    isAddEmployeeModalOpen,
    selectedDate,
    selectedShiftId,
    addingEmployee,
    isApprovalModalOpen,
    selectedAssignment,
    updatingApproval,
    notification,
    openAddEmployeeModal,
    closeAddEmployeeModal,
    setAddingEmployee,
    openApprovalModal,
    closeApprovalModal,
    setUpdatingApproval,
    toggleApproval,
    showNotification,
    clearNotification,
    createAssignment,
  } = useSchedule(companyId);

  // Use Schedule provider's selectedStoreId for display
  const selectedStoreId = scheduleStoreId;

  // Drag and drop hook
  const {
    draggedEmployeeId,
    dropTarget,
    isConfirmModalOpen,
    pendingAssignment,
    handleEmployeeDragStart,
    handleEmployeeDragEnd,
    handleCellDragOver,
    handleCellDragEnter,
    handleCellDragLeave,
    handleCellDrop,
    handleCancelAssignment,
    setIsConfirmModalOpen,
    setPendingAssignment,
  } = useScheduleDragDrop({
    employees,
    shifts,
    getAssignmentsForDate,
    showNotification,
  });

  // Get all stores from current company
  const stores = currentCompany?.stores || [];

  // Sync App State's currentStore to Schedule provider on mount
  React.useEffect(() => {
    const appStateStoreId = currentStore?.store_id || null;
    if (appStateStoreId !== scheduleStoreId) {
      setScheduleStoreId(appStateStoreId);
    }
  }, [currentStore, scheduleStoreId, setScheduleStoreId]);

  // Handler to select store - sync with App State
  const handleStoreSelect = (storeId: string | null) => {
    const selectedStore = stores.find((s) => s.store_id === storeId) || null;
    setCurrentStore(selectedStore);
    setScheduleStoreId(storeId);
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

  // Handle confirm assignment from drag & drop
  const handleConfirmAssignment = async () => {
    if (!pendingAssignment) return;

    await handleAddEmployee(
      pendingAssignment.shiftId,
      pendingAssignment.employeeId,
      pendingAssignment.date
    );

    setIsConfirmModalOpen(false);
    setPendingAssignment(null);
  };

  // Handle assignment card click (for approval status toggle)
  const handleAssignmentClick = (assignment: ScheduleAssignment) => {
    openApprovalModal(assignment);
  };

  // Handle approval modal option selection
  const handleApprovalSelect = async (optionId: string) => {
    if (!selectedAssignment || !currentUserId) return;

    setUpdatingApproval(true);
    try {
      // Call toggle_shift_approval_v3 RPC
      const result = await toggleApproval([selectedAssignment.assignmentId], currentUserId);

      if (!result.success) {
        showNotification({
          variant: 'error',
          title: 'Failed to Update',
          message: result.error || 'Failed to update approval status',
        });
        return;
      }

      // Show success notification
      if (optionId === 'approve') {
        showNotification({
          variant: 'success',
          title: 'Approved',
          message: `${selectedAssignment.fullName}'s shift has been approved`,
        });
      } else if (optionId === 'unapprove') {
        showNotification({
          variant: 'success',
          title: 'Unapproved',
          message: `${selectedAssignment.fullName}'s shift has been unapproved`,
        });
      }

      closeApprovalModal();
      // Refresh to get updated data
      refresh();
    } catch (err) {
      showNotification({
        variant: 'error',
        title: 'Unexpected Error',
        message: err instanceof Error ? err.message : 'An unexpected error occurred',
      });
    } finally {
      setUpdatingApproval(false);
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

  // Get selected store name
  const selectedStore = stores.find((s) => s.store_id === selectedStoreId);
  const selectedStoreName = selectedStore?.store_name || 'Store';

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
          showAllStoresOption={false}
        />
      ),
      defaultExpanded: true,
    },
  ];

  const weekDays = getWeekDays();

  // Show loading if app state is not ready
  if (!currentCompany) {
    return (
      <>
        <Navbar activeItem="employee" />
        <div className={styles.pageLayout}>
          <div className={styles.mainContent}>
            <div className={styles.container}>
              <div className={styles.header}>
                <h1 className={styles.title}>Employee Schedule</h1>
              </div>
              <LoadingAnimation fullscreen />
            </div>
          </div>
        </div>
      </>
    );
  }

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
            {/* Page Header */}
            <div className={styles.header}>
              <h1 className={styles.title}>
                {selectedStoreId ? `${selectedStoreName} - Schedule` : 'Employee Schedule'}
              </h1>
              <p className={styles.subtitle}>
                {selectedStoreId
                  ? 'Manage work shifts and assignments'
                  : 'Select a store from the left to view and manage schedules'}
              </p>
            </div>

            {/* No Store Selected State */}
            {!selectedStoreId && <ScheduleEmptyState variant="no-store" />}

            {/* Store Selected - Show Schedule */}
            {selectedStoreId && (
              <>
                {loading ? (
                  <LoadingAnimation fullscreen />
                ) : error ? (
                  <ScheduleEmptyState
                    variant="error"
                    error={error}
                    onAction={refresh}
                    actionText="Try Again"
                  />
                ) : (
                  <>
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
                          dropTarget={dropTarget}
                          onOpenAddEmployeeModal={openAddEmployeeModal}
                          onAssignmentClick={handleAssignmentClick}
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
                      draggedEmployeeId={draggedEmployeeId}
                      showDragHint={true}
                      onDragStart={handleEmployeeDragStart}
                      onDragEnd={handleEmployeeDragEnd}
                    />
                  </>
                )}
              </>
            )}
          </div>
        </div>
      </div>

      {/* Add Employee Modal */}
      {selectedStoreId && (
        <AddEmployeeModal
          isOpen={isAddEmployeeModalOpen}
          onClose={closeAddEmployeeModal}
          selectedDate={selectedDate}
          defaultShiftId={selectedShiftId}
          shifts={shifts}
          employees={employees}
          assignments={assignments}
          onAddEmployee={handleAddEmployee}
          loading={addingEmployee}
        />
      )}

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

      {/* Confirm Assignment Modal */}
      <ConfirmModal
        isOpen={isConfirmModalOpen}
        onClose={handleCancelAssignment}
        onConfirm={handleConfirmAssignment}
        variant="info"
        title="Add Employee to Shift"
        message="Do you want to add this employee to the selected shift?"
        confirmText="Add Employee"
        cancelText="Cancel"
        confirmButtonVariant="primary"
        isLoading={addingEmployee}
        closeOnBackdropClick={true}
      >
        {pendingAssignment && (
          <div className={styles.confirmContent}>
            <div className={styles.confirmRow}>
              <span className={styles.confirmLabel}>Employee:</span>
              <span className={styles.confirmValue}>{pendingAssignment.employeeName}</span>
            </div>
            <div className={styles.confirmRow}>
              <span className={styles.confirmLabel}>Shift:</span>
              <span className={styles.confirmValue}>{pendingAssignment.shiftName}</span>
            </div>
            <div className={styles.confirmRow}>
              <span className={styles.confirmLabel}>Date:</span>
              <span className={styles.confirmValue}>
                {new Date(pendingAssignment.date).toLocaleDateString('en-US', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric',
                })}
              </span>
            </div>
          </div>
        )}
      </ConfirmModal>

      {/* Approval Status Change Modal */}
      <SelectorModal
        isOpen={isApprovalModalOpen}
        onClose={closeApprovalModal}
        onSelect={handleApprovalSelect}
        variant={selectedAssignment?.isApproved ? 'warning' : 'info'}
        title={selectedAssignment?.isApproved ? 'Unapprove Shift?' : 'Approve Shift?'}
        message={
          selectedAssignment?.isApproved
            ? `Do you want to unapprove ${selectedAssignment?.fullName}'s shift assignment?`
            : `Do you want to approve ${selectedAssignment?.fullName}'s shift assignment?`
        }
        options={
          selectedAssignment?.isApproved
            ? [
                {
                  id: 'unapprove',
                  label: 'Yes, Unapprove',
                  variant: 'primary',
                },
              ]
            : [
                {
                  id: 'approve',
                  label: 'Yes, Approve',
                  variant: 'primary',
                },
              ]
        }
        cancelText="Cancel"
        showCancelButton={true}
        buttonLayout="row"
        isLoading={updatingApproval}
      >
        {selectedAssignment && (
          <div className={styles.approvalContent}>
            <div className={styles.approvalRow}>
              <span className={styles.approvalLabel}>Employee:</span>
              <span className={styles.approvalValue}>{selectedAssignment.fullName}</span>
            </div>
            <div className={styles.approvalRow}>
              <span className={styles.approvalLabel}>Shift:</span>
              <span className={styles.approvalValue}>{selectedAssignment.shift.shiftName}</span>
            </div>
            <div className={styles.approvalRow}>
              <span className={styles.approvalLabel}>Date:</span>
              <span className={styles.approvalValue}>
                {new Date(selectedAssignment.date).toLocaleDateString('en-US', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric',
                })}
              </span>
            </div>
            <div className={styles.approvalRow}>
              <span className={styles.approvalLabel}>Current Status:</span>
              <span
                className={`${styles.approvalValue} ${selectedAssignment.isApproved ? styles.statusApproved : styles.statusPending}`}
              >
                {selectedAssignment.isApproved ? '● Approved' : '● Pending'}
              </span>
            </div>
          </div>
        )}
      </SelectorModal>
    </>
  );
};

export default SchedulePage;
