/**
 * ScheduleGrid Component
 * Weekly schedule grid displaying shifts and assignments
 */

import React from 'react';
import type { ScheduleGridProps } from './ScheduleGrid.types';
import styles from './ScheduleGrid.module.css';

export const ScheduleGrid: React.FC<ScheduleGridProps> = ({
  weekDays,
  shifts,
  getAssignmentsForDate,
  dropTarget,
  onOpenAddEmployeeModal,
  onCellDragOver,
  onCellDragEnter,
  onCellDragLeave,
  onCellDrop,
}) => {
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

  // Add icon SVG
  const AddIcon = () => (
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
  );

  return (
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
            const isDropTarget =
              dropTarget?.shiftId === shift.shiftId && dropTarget?.date === date;

            return (
              <div
                key={date}
                className={`${styles.assignmentCell} ${isTodayDate ? styles.today : ''} ${isDropTarget ? styles.dropTarget : ''}`}
                onDragOver={onCellDragOver}
                onDragEnter={() => onCellDragEnter(shift.shiftId, date)}
                onDragLeave={onCellDragLeave}
                onDrop={(e) => onCellDrop(e, shift.shiftId, date)}
              >
                {shiftAssignments.length === 0 ? (
                  <button
                    className={styles.addEmployeeCellButton}
                    onClick={() => onOpenAddEmployeeModal(date)}
                    title="Add Employee"
                  >
                    <AddIcon />
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
                        <span
                          className={`${styles.statusDot} ${styles[assignment.status]}`}
                        ></span>
                      </div>
                    ))}
                    <button
                      className={styles.addEmployeeCellButtonSmall}
                      onClick={() => onOpenAddEmployeeModal(date)}
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
  );
};

export default ScheduleGrid;
