/**
 * SchedulePage Component
 * Employee schedule management with weekly calendar view
 * Integrated single-page design with LeftFilter + StoreSelector
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';
import { AddEmployeeModal } from '../../components/AddEmployeeModal';
import { ErrorMessage } from '@/shared/components/common/ErrorMessage';
import { ConfirmModal } from '@/shared/components/common/ConfirmModal';
import { useSchedule } from '../../hooks/useSchedule';
import { TossButton } from '@/shared/components/toss/TossButton';
import { useAppState } from '@/app/providers/app_state_provider';
import type { SchedulePageProps } from './SchedulePage.types';
import styles from './SchedulePage.module.css';

export const SchedulePage: React.FC<SchedulePageProps> = () => {
  const { currentCompany, currentUser, currentStore, setCurrentStore } = useAppState();

  const companyId = currentCompany?.company_id || '';
  const currentUserId = currentUser?.user_id || '';

  // Drag and drop state
  const [draggedEmployeeId, setDraggedEmployeeId] = useState<string | null>(null);
  const [dropTarget, setDropTarget] = useState<{ shiftId: string; date: string } | null>(null);
  const [isConfirmModalOpen, setIsConfirmModalOpen] = useState(false);
  const [pendingAssignment, setPendingAssignment] = useState<{
    employeeId: string;
    employeeName: string;
    shiftId: string;
    shiftName: string;
    date: string;
  } | null>(null);

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
    addingEmployee,
    notification,
    openAddEmployeeModal,
    closeAddEmployeeModal,
    setAddingEmployee,
    showNotification,
    clearNotification,
    createAssignment,
  } = useSchedule(companyId);

  // Use Schedule provider's selectedStoreId for display
  const selectedStoreId = scheduleStoreId;

  // Get all stores from current company
  const stores = currentCompany?.stores || [];

  // Sync App State's currentStore to Schedule provider on mount and when currentStore changes
  React.useEffect(() => {
    const appStateStoreId = currentStore?.store_id || null;
    if (appStateStoreId !== scheduleStoreId) {
      setScheduleStoreId(appStateStoreId);
    }
  }, [currentStore, scheduleStoreId, setScheduleStoreId]);

  // Handler to select store - sync with App State
  const handleStoreSelect = (storeId: string | null) => {
    // Find the store object
    const selectedStore = stores.find((s) => s.store_id === storeId) || null;

    // Update App State (this will also update localStorage)
    setCurrentStore(selectedStore);

    // Update Schedule provider state
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

  // Drag and drop handlers
  const handleEmployeeDragStart = (e: React.DragEvent<HTMLDivElement>, employeeId: string) => {
    setDraggedEmployeeId(employeeId);
    e.dataTransfer.effectAllowed = 'copy';
  };

  const handleEmployeeDragEnd = () => {
    setDraggedEmployeeId(null);
    setDropTarget(null);
  };

  const handleCellDragOver = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'copy';
  };

  const handleCellDragEnter = (shiftId: string, date: string) => {
    if (draggedEmployeeId) {
      setDropTarget({ shiftId, date });
    }
  };

  const handleCellDragLeave = () => {
    setDropTarget(null);
  };

  const handleCellDrop = (e: React.DragEvent<HTMLDivElement>, shiftId: string, date: string) => {
    e.preventDefault();
    setDropTarget(null);

    if (!draggedEmployeeId) return;

    // Find employee and shift details
    const employee = employees.find((emp) => emp.userId === draggedEmployeeId);
    const shift = shifts.find((s) => s.shiftId === shiftId);

    if (!employee || !shift) {
      setDraggedEmployeeId(null);
      return;
    }

    // Check for duplicate assignment (same user_id, same shift, same date)
    const dayAssignments = getAssignmentsForDate(date);
    const isDuplicate = dayAssignments.some(
      (assignment) =>
        assignment.userId === draggedEmployeeId &&
        assignment.shift.shiftId === shiftId
    );

    if (isDuplicate) {
      // Show error message for duplicate assignment
      showNotification({
        variant: 'error',
        title: 'Duplicate Assignment',
        message: `${employee.fullName} is already assigned to ${shift.shiftName} on this date.`,
      });
      setDraggedEmployeeId(null);
      return;
    }

    // Set pending assignment and show confirmation modal
    setPendingAssignment({
      employeeId: draggedEmployeeId,
      employeeName: employee.fullName,
      shiftId: shift.shiftId,
      shiftName: shift.shiftName,
      date,
    });
    setIsConfirmModalOpen(true);
    setDraggedEmployeeId(null);
  };

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

  const handleCancelAssignment = () => {
    setIsConfirmModalOpen(false);
    setPendingAssignment(null);
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
            {!selectedStoreId && (
              <div className={styles.emptyState}>
                <svg
                  className={styles.emptyIcon}
                  width="120"
                  height="120"
                  viewBox="0 0 120 120"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  {/* Background Circle */}
                  <circle cx="60" cy="60" r="50" fill="#F0F6FF" />

                  {/* Calendar Base */}
                  <rect x="30" y="35" width="60" height="55" rx="6" fill="white" stroke="#0064FF" strokeWidth="2" />

                  {/* Calendar Header */}
                  <rect x="30" y="35" width="60" height="15" rx="6" fill="#0064FF" />
                  <rect x="30" y="43" width="60" height="7" fill="#0064FF" />

                  {/* Calendar Rings */}
                  <circle cx="42" cy="35" r="3" fill="white" />
                  <circle cx="60" cy="35" r="3" fill="white" />
                  <circle cx="78" cy="35" r="3" fill="white" />

                  {/* Calendar Grid - Week Days */}
                  <line x1="37" y1="58" x2="47" y2="58" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />
                  <line x1="52" y1="58" x2="62" y2="58" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />
                  <line x1="67" y1="58" x2="77" y2="58" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />

                  <line x1="37" y1="68" x2="47" y2="68" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />
                  <line x1="52" y1="68" x2="62" y2="68" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />
                  <line x1="67" y1="68" x2="77" y2="68" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />

                  <line x1="37" y1="78" x2="47" y2="78" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />
                  <line x1="52" y1="78" x2="62" y2="78" stroke="#0064FF" strokeWidth="3" strokeLinecap="round" />
                  <line x1="67" y1="78" x2="77" y2="78" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round" />

                  {/* Arrow pointing left */}
                  <path d="M20 60 L30 55 L30 65 Z" fill="#0064FF" />
                </svg>
                <h3 className={styles.emptyTitle}>Select a Store</h3>
                <p className={styles.emptyText}>Choose a store from the sidebar to view its schedule</p>
              </div>
            )}

            {/* Store Selected - Show Schedule */}
            {selectedStoreId && (
              <>
                {loading ? (
                  <LoadingAnimation fullscreen />
                ) : error ? (
                  <div className={styles.errorContainer}>
                    <svg
                      className={styles.errorIcon}
                      width="120"
                      height="120"
                      viewBox="0 0 120 120"
                      fill="none"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      {/* Background Circle */}
                      <circle cx="60" cy="60" r="50" fill="#FFEFED" />

                      {/* Error Triangle */}
                      <path d="M60 30 L90 80 L30 80 Z" fill="white" stroke="#FF5847" strokeWidth="2" />

                      {/* Exclamation Mark */}
                      <line x1="60" y1="50" x2="60" y2="65" stroke="#FF5847" strokeWidth="3" strokeLinecap="round" />
                      <circle cx="60" cy="72" r="2" fill="#FF5847" />
                    </svg>
                    <h2 className={styles.errorTitle}>Failed to Load Schedule</h2>
                    <p className={styles.errorMessage}>{error}</p>
                    <TossButton onClick={refresh} variant="primary">
                      Try Again
                    </TossButton>
                  </div>
                ) : (
                  <>
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

                    {/* Schedule Grid */}
                    <div className={styles.scheduleSection}>
                      {weekDays.length === 0 || shifts.length === 0 ? (
                        <div className={styles.emptyState}>
                          <svg
                            className={styles.emptyIcon}
                            width="120"
                            height="120"
                            viewBox="0 0 120 120"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                          >
                            {/* Background Circle */}
                            <circle cx="60" cy="60" r="50" fill="#F0F6FF" />

                            {/* Calendar Base */}
                            <rect
                              x="30"
                              y="35"
                              width="60"
                              height="55"
                              rx="6"
                              fill="white"
                              stroke="#0064FF"
                              strokeWidth="2"
                            />

                            {/* Calendar Header */}
                            <rect x="30" y="35" width="60" height="15" rx="6" fill="#0064FF" />
                            <rect x="30" y="43" width="60" height="7" fill="#0064FF" />

                            {/* Calendar Rings */}
                            <circle cx="42" cy="35" r="3" fill="white" />
                            <circle cx="60" cy="35" r="3" fill="white" />
                            <circle cx="78" cy="35" r="3" fill="white" />

                            {/* Calendar Grid - Week Days */}
                            <line
                              x1="37"
                              y1="58"
                              x2="47"
                              y2="58"
                              stroke="#E9ECEF"
                              strokeWidth="2"
                              strokeLinecap="round"
                            />
                            <line
                              x1="52"
                              y1="58"
                              x2="62"
                              y2="58"
                              stroke="#E9ECEF"
                              strokeWidth="2"
                              strokeLinecap="round"
                            />
                            <line
                              x1="67"
                              y1="58"
                              x2="77"
                              y2="58"
                              stroke="#E9ECEF"
                              strokeWidth="2"
                              strokeLinecap="round"
                            />

                            <line
                              x1="37"
                              y1="68"
                              x2="47"
                              y2="68"
                              stroke="#E9ECEF"
                              strokeWidth="2"
                              strokeLinecap="round"
                            />
                            <line
                              x1="52"
                              y1="68"
                              x2="62"
                              y2="68"
                              stroke="#E9ECEF"
                              strokeWidth="2"
                              strokeLinecap="round"
                            />
                            <line
                              x1="67"
                              y1="68"
                              x2="77"
                              y2="68"
                              stroke="#E9ECEF"
                              strokeWidth="2"
                              strokeLinecap="round"
                            />

                            <line
                              x1="37"
                              y1="78"
                              x2="47"
                              y2="78"
                              stroke="#E9ECEF"
                              strokeWidth="2"
                              strokeLinecap="round"
                            />
                            <line
                              x1="52"
                              y1="78"
                              x2="62"
                              y2="78"
                              stroke="#0064FF"
                              strokeWidth="3"
                              strokeLinecap="round"
                            />
                            <line
                              x1="67"
                              y1="78"
                              x2="77"
                              y2="78"
                              stroke="#E9ECEF"
                              strokeWidth="2"
                              strokeLinecap="round"
                            />

                            {/* Empty State Icon - Question Mark Circle */}
                            <circle cx="60" cy="95" r="14" fill="#0064FF" />
                            <path
                              d="M60 88 Q60 85 63 85 Q66 85 66 88 Q66 91 63 93 L60 95"
                              stroke="white"
                              strokeWidth="2.5"
                              fill="none"
                              strokeLinecap="round"
                            />
                            <circle cx="60" cy="99" r="1.5" fill="white" />
                          </svg>
                          <h3 className={styles.emptyTitle}>No Schedule Available</h3>
                          <p className={styles.emptyText}>
                            {shifts.length === 0 ? 'No shifts configured for this store' : 'No schedule data for the selected week'}
                          </p>
                        </div>
                      ) : (
                        <div className={styles.scheduleGridContainer}>
                          {/* Header Row */}
                          <div className={styles.scheduleHeader}>
                            <div className={styles.shiftHeaderCell}>Shifts</div>
                            {weekDays.map((date) => {
                              const isTodayDate = isToday(date);
                              return (
                                <div
                                  key={date}
                                  className={`${styles.dateHeaderCell} ${isTodayDate ? styles.today : ''}`}
                                >
                                  <div className={styles.dayName}>{formatDayHeader(date)}</div>
                                  {isTodayDate && <span className={styles.todayBadge}>Today</span>}
                                </div>
                              );
                            })}
                          </div>

                          {/* Shift Rows */}
                          {shifts.map((shift) => (
                            <div key={shift.shiftId} className={styles.shiftRow}>
                              {/* Shift Info Cell */}
                              <div className={styles.shiftInfoCell} style={{ borderLeftColor: shift.color }}>
                                <div className={styles.shiftName}>{shift.shiftName}</div>
                                <div className={styles.shiftTime}>{shift.timeRange}</div>
                              </div>

                              {/* Date Cells */}
                              {weekDays.map((date) => {
                                const isTodayDate = isToday(date);
                                const dayAssignments = getAssignmentsForDate(date);
                                const shiftAssignments = dayAssignments.filter(
                                  (assignment) => assignment.shift.shiftId === shift.shiftId
                                );
                                const isDropTarget = dropTarget?.shiftId === shift.shiftId && dropTarget?.date === date;

                                return (
                                  <div
                                    key={date}
                                    className={`${styles.assignmentCell} ${isTodayDate ? styles.today : ''} ${isDropTarget ? styles.dropTarget : ''}`}
                                    onDragOver={handleCellDragOver}
                                    onDragEnter={() => handleCellDragEnter(shift.shiftId, date)}
                                    onDragLeave={handleCellDragLeave}
                                    onDrop={(e) => handleCellDrop(e, shift.shiftId, date)}
                                  >
                                    {shiftAssignments.length === 0 ? (
                                      <button
                                        className={styles.addEmployeeCellButton}
                                        onClick={() => openAddEmployeeModal(date)}
                                        title="Add Employee"
                                      >
                                        <svg
                                          className={styles.addIconSmall}
                                          viewBox="0 0 24 24"
                                          fill="none"
                                          stroke="currentColor"
                                          strokeWidth="2"
                                        >
                                          <line x1="12" y1="5" x2="12" y2="19" />
                                          <line x1="5" y1="12" x2="19" y2="12" />
                                        </svg>
                                      </button>
                                    ) : (
                                      <div className={styles.employeeList}>
                                        {shiftAssignments.map((assignment) => (
                                          <div
                                            key={assignment.assignmentId}
                                            className={styles.employeeChip}
                                            title={`${assignment.fullName} - ${assignment.status}`}
                                          >
                                            <span className={styles.employeeName}>
                                              {assignment.fullName || 'Unknown'}
                                            </span>
                                            <span className={`${styles.statusDot} ${styles[assignment.status]}`}></span>
                                          </div>
                                        ))}
                                        <button
                                          className={styles.addEmployeeCellButtonSmall}
                                          onClick={() => openAddEmployeeModal(date)}
                                          title="Add Another Employee"
                                        >
                                          +
                                        </button>
                                      </div>
                                    )}
                                  </div>
                                );
                              })}
                            </div>
                          ))}
                        </div>
                      )}
                    </div>

                    {/* Employee List */}
                    <div className={styles.employeeSection}>
                      <h3 className={styles.sectionTitle}>
                        Employees ({employees.length})
                        <span className={styles.dragHint}>Drag employees to schedule cells</span>
                      </h3>
                      {loadingEmployees ? (
                        <LoadingAnimation />
                      ) : employees.length === 0 ? (
                        <div className={styles.noEmployees}>No employees found for this store</div>
                      ) : (
                        <div className={styles.employeeGrid}>
                          {employees.map((employee) => (
                            <div
                              key={employee.userId}
                              className={`${styles.employeeCard} ${draggedEmployeeId === employee.userId ? styles.dragging : ''}`}
                              draggable={true}
                              onDragStart={(e) => handleEmployeeDragStart(e, employee.userId)}
                              onDragEnd={handleEmployeeDragEnd}
                            >
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
    </>
  );
};

export default SchedulePage;
