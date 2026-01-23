/**
 * useScheduleDragDrop Hook
 * Presentation layer - Drag & drop logic for schedule assignments
 */

import { useState, useCallback } from 'react';
import type { ScheduleEmployee } from '../../domain/entities/ScheduleEmployee';
import type { ScheduleShift } from '../../domain/entities/ScheduleShift';
import type { ScheduleAssignment } from '../../domain/entities/ScheduleAssignment';

export interface DropTarget {
  shiftId: string;
  date: string;
}

export interface PendingAssignment {
  employeeId: string;
  employeeName: string;
  shiftId: string;
  shiftName: string;
  date: string;
}

export interface UseScheduleDragDropProps {
  employees: ScheduleEmployee[];
  shifts: ScheduleShift[];
  getAssignmentsForDate: (date: string) => ScheduleAssignment[];
  showNotification: (notification: {
    variant: 'success' | 'error' | 'warning' | 'info';
    title?: string;
    message: string;
  }) => void;
}

export interface UseScheduleDragDropReturn {
  // State
  draggedEmployeeId: string | null;
  dropTarget: DropTarget | null;
  isConfirmModalOpen: boolean;
  pendingAssignment: PendingAssignment | null;

  // Handlers
  handleEmployeeDragStart: (e: React.DragEvent<HTMLDivElement>, employeeId: string) => void;
  handleEmployeeDragEnd: () => void;
  handleCellDragOver: (e: React.DragEvent<HTMLDivElement>) => void;
  handleCellDragEnter: (shiftId: string, date: string) => void;
  handleCellDragLeave: () => void;
  handleCellDrop: (e: React.DragEvent<HTMLDivElement>, shiftId: string, date: string) => void;
  handleConfirmAssignment: () => void;
  handleCancelAssignment: () => void;

  // Setters for external control
  setIsConfirmModalOpen: (isOpen: boolean) => void;
  setPendingAssignment: (assignment: PendingAssignment | null) => void;
}

export const useScheduleDragDrop = ({
  employees,
  shifts,
  getAssignmentsForDate,
  showNotification,
}: UseScheduleDragDropProps): UseScheduleDragDropReturn => {
  const [draggedEmployeeId, setDraggedEmployeeId] = useState<string | null>(null);
  const [dropTarget, setDropTarget] = useState<DropTarget | null>(null);
  const [isConfirmModalOpen, setIsConfirmModalOpen] = useState(false);
  const [pendingAssignment, setPendingAssignment] = useState<PendingAssignment | null>(null);

  const handleEmployeeDragStart = useCallback(
    (e: React.DragEvent<HTMLDivElement>, employeeId: string) => {
      setDraggedEmployeeId(employeeId);
      e.dataTransfer.effectAllowed = 'copy';
    },
    []
  );

  const handleEmployeeDragEnd = useCallback(() => {
    setDraggedEmployeeId(null);
    setDropTarget(null);
  }, []);

  const handleCellDragOver = useCallback((e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'copy';
  }, []);

  const handleCellDragEnter = useCallback(
    (shiftId: string, date: string) => {
      if (draggedEmployeeId) {
        setDropTarget({ shiftId, date });
      }
    },
    [draggedEmployeeId]
  );

  const handleCellDragLeave = useCallback(() => {
    setDropTarget(null);
  }, []);

  const handleCellDrop = useCallback(
    (e: React.DragEvent<HTMLDivElement>, shiftId: string, date: string) => {
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
          assignment.userId === draggedEmployeeId && assignment.shift.shiftId === shiftId
      );

      if (isDuplicate) {
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
    },
    [draggedEmployeeId, employees, shifts, getAssignmentsForDate, showNotification]
  );

  const handleConfirmAssignment = useCallback(() => {
    // This will be handled by the parent component
    // The parent should call the actual assignment creation
  }, []);

  const handleCancelAssignment = useCallback(() => {
    setIsConfirmModalOpen(false);
    setPendingAssignment(null);
  }, []);

  return {
    // State
    draggedEmployeeId,
    dropTarget,
    isConfirmModalOpen,
    pendingAssignment,

    // Handlers
    handleEmployeeDragStart,
    handleEmployeeDragEnd,
    handleCellDragOver,
    handleCellDragEnter,
    handleCellDragLeave,
    handleCellDrop,
    handleConfirmAssignment,
    handleCancelAssignment,

    // Setters
    setIsConfirmModalOpen,
    setPendingAssignment,
  };
};
