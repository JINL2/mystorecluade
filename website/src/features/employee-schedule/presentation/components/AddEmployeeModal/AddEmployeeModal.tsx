/**
 * AddEmployeeModal Component
 * Modal for adding an employee to a shift on a specific date
 */

import React, { useState, useEffect } from 'react';
import { TossSelector } from '@/shared/components/selectors/TossSelector';
import type { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';
import styles from './AddEmployeeModal.module.css';
import type { AddEmployeeModalProps } from './AddEmployeeModal.types';

export const AddEmployeeModal: React.FC<AddEmployeeModalProps> = ({
  isOpen,
  onClose,
  selectedDate,
  shifts,
  employees,
  onAddEmployee,
  loading = false,
}) => {
  const [selectedShiftId, setSelectedShiftId] = useState<string>('');
  const [selectedEmployeeId, setSelectedEmployeeId] = useState<string>('');

  // Reset form when modal opens
  useEffect(() => {
    if (isOpen) {
      setSelectedShiftId('');
      setSelectedEmployeeId('');
    }
  }, [isOpen]);

  // Convert shifts to TossSelector options
  const shiftOptions: TossSelectorOption[] = shifts.map((shift) => ({
    value: shift.shiftId,
    label: shift.shiftName,
    description: shift.timeRange,
  }));

  // Convert employees to TossSelector options
  const employeeOptions: TossSelectorOption[] = employees.map((employee) => ({
    value: employee.userId,
    label: employee.fullName,
    description: employee.displayRole,
  }));

  // Format date display
  const formatDateDisplay = (dateStr: string): string => {
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  };

  // Handle submit
  const handleSubmit = async () => {
    // Validation and error handling is now in parent component (ScheduleDetailPage)
    await onAddEmployee(selectedShiftId, selectedEmployeeId, selectedDate);
  };

  // Handle backdrop click
  const handleBackdropClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget && !loading) {
      onClose();
    }
  };

  // Close icon SVG (Material Design - 24px for modal header)
  const CloseIcon = () => (
    <svg
      className={styles.closeIcon}
      viewBox="0 0 24 24"
      fill="currentColor"
    >
      <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
    </svg>
  );

  // Calendar icon SVG (Material Design - 20px)
  const CalendarIcon = () => (
    <svg
      className={styles.calendarIcon}
      viewBox="0 0 24 24"
      fill="currentColor"
    >
      <path d="M19,19H5V8H19M16,1V3H8V1H6V3H5C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5C21,3.89 20.1,3 19,3H18V1M17,12H12V17H17V12Z"/>
    </svg>
  );

  // Plus icon SVG (Material Design - 18px for button)
  const PlusIcon = () => (
    <svg
      className={styles.buttonIcon}
      viewBox="0 0 24 24"
      fill="currentColor"
    >
      <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
    </svg>
  );

  if (!isOpen) return null;

  return (
    <div className={styles.modalOverlay} onClick={handleBackdropClick}>
      <div className={styles.modalContent}>
        {/* Header */}
        <div className={styles.modalHeader}>
          <h3 className={styles.modalTitle}>Add Employee to Shift</h3>
          <button
            className={styles.closeButton}
            onClick={onClose}
            disabled={loading}
            aria-label="Close modal"
          >
            <CloseIcon />
          </button>
        </div>

        {/* Body */}
        <div className={styles.modalBody}>
          {/* Date Display */}
          <div className={styles.dateDisplay}>
            <CalendarIcon />
            <span className={styles.dateText}>
              Selected Date: <span className={styles.dateValue}>{formatDateDisplay(selectedDate)}</span>
            </span>
          </div>

          {/* Shift Selection */}
          <TossSelector
            id="shift-select"
            label="Select Shift"
            placeholder="Choose a shift..."
            value={selectedShiftId}
            options={shiftOptions}
            onChange={(value) => setSelectedShiftId(value)}
            disabled={loading}
            fullWidth
            showDescriptions
            required
          />

          {/* Employee Selection */}
          <TossSelector
            id="employee-select"
            label="Select Employee"
            placeholder="Choose an employee..."
            value={selectedEmployeeId}
            options={employeeOptions}
            onChange={(value) => setSelectedEmployeeId(value)}
            disabled={loading}
            fullWidth
            showDescriptions
            searchable
            required
          />
        </div>

        {/* Footer */}
        <div className={styles.modalFooter}>
          <button
            className={styles.cancelButton}
            onClick={onClose}
            disabled={loading}
          >
            Cancel
          </button>
          <button
            className={styles.addButton}
            onClick={handleSubmit}
            disabled={loading || !selectedShiftId || !selectedEmployeeId}
          >
            <PlusIcon />
            {loading ? 'Adding...' : 'Add Employee'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default AddEmployeeModal;
