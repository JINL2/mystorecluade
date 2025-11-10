/**
 * AddEmployeeModal Component
 * Modal for adding an employee to a shift on a specific date
 */

import React, { useState, useEffect } from 'react';
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
  const [error, setError] = useState<string>('');

  // Reset form when modal opens
  useEffect(() => {
    if (isOpen) {
      setSelectedShiftId('');
      setSelectedEmployeeId('');
      setError('');
    }
  }, [isOpen]);

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
    // Validation
    if (!selectedShiftId) {
      setError('Please select a shift');
      return;
    }
    if (!selectedEmployeeId) {
      setError('Please select an employee');
      return;
    }

    setError('');

    try {
      await onAddEmployee(selectedShiftId, selectedEmployeeId, selectedDate);
      onClose();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to add employee');
    }
  };

  // Handle backdrop click
  const handleBackdropClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget && !loading) {
      onClose();
    }
  };

  // Close icon SVG
  const CloseIcon = () => (
    <svg
      className={styles.closeIcon}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <line x1="18" y1="6" x2="6" y2="18" />
      <line x1="6" y1="6" x2="18" y2="18" />
    </svg>
  );

  // Calendar icon SVG
  const CalendarIcon = () => (
    <svg
      className={styles.calendarIcon}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
      <line x1="16" y1="2" x2="16" y2="6" />
      <line x1="8" y1="2" x2="8" y2="6" />
      <line x1="3" y1="10" x2="21" y2="10" />
    </svg>
  );

  // Chevron down icon SVG
  const ChevronDownIcon = () => (
    <svg
      className={styles.selectIcon}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <polyline points="6 9 12 15 18 9" />
    </svg>
  );

  // Alert icon SVG
  const AlertIcon = () => (
    <svg
      className={styles.errorIcon}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <circle cx="12" cy="12" r="10" />
      <line x1="12" y1="8" x2="12" y2="12" />
      <line x1="12" y1="16" x2="12.01" y2="16" />
    </svg>
  );

  // Plus icon SVG
  const PlusIcon = () => (
    <svg
      className={styles.buttonIcon}
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

          {/* Error Message */}
          {error && (
            <div className={styles.error}>
              <AlertIcon />
              <span>{error}</span>
            </div>
          )}

          {/* Shift Selection */}
          <div className={styles.formSection}>
            <label className={styles.label} htmlFor="shift-select">
              Select Shift
            </label>
            <div className={styles.selectWrapper}>
              <select
                id="shift-select"
                className={styles.select}
                value={selectedShiftId}
                onChange={(e) => setSelectedShiftId(e.target.value)}
                disabled={loading}
              >
                <option value="">Choose a shift...</option>
                {shifts.map((shift) => (
                  <option key={shift.shiftId} value={shift.shiftId}>
                    {shift.shiftName} ({shift.timeRange})
                  </option>
                ))}
              </select>
              <ChevronDownIcon />
            </div>
          </div>

          {/* Employee Selection */}
          <div className={styles.formSection}>
            <label className={styles.label} htmlFor="employee-select">
              Select Employee
            </label>
            <div className={styles.selectWrapper}>
              <select
                id="employee-select"
                className={styles.select}
                value={selectedEmployeeId}
                onChange={(e) => setSelectedEmployeeId(e.target.value)}
                disabled={loading}
              >
                <option value="">Choose an employee...</option>
                {employees.map((employee) => (
                  <option key={employee.userId} value={employee.userId}>
                    {employee.fullName} - {employee.displayRole}
                  </option>
                ))}
              </select>
              <ChevronDownIcon />
            </div>
          </div>
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
