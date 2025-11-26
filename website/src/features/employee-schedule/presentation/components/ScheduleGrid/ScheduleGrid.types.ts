/**
 * ScheduleGrid Component Types
 */

import type { ScheduleShift } from '../../../domain/entities/ScheduleShift';
import type { ScheduleAssignment } from '../../../domain/entities/ScheduleAssignment';
import type { DropTarget } from '../../hooks/useScheduleDragDrop';

export interface ScheduleGridProps {
  /**
   * Array of week days (ISO date strings)
   */
  weekDays: string[];

  /**
   * Available shifts
   */
  shifts: ScheduleShift[];

  /**
   * Get assignments for a specific date
   */
  getAssignmentsForDate: (date: string) => ScheduleAssignment[];

  /**
   * Current drop target for drag & drop
   */
  dropTarget: DropTarget | null;

  /**
   * Open add employee modal for a date
   */
  onOpenAddEmployeeModal: (date: string) => void;

  /**
   * Handle cell drag over
   */
  onCellDragOver: (e: React.DragEvent<HTMLDivElement>) => void;

  /**
   * Handle cell drag enter
   */
  onCellDragEnter: (shiftId: string, date: string) => void;

  /**
   * Handle cell drag leave
   */
  onCellDragLeave: () => void;

  /**
   * Handle cell drop
   */
  onCellDrop: (e: React.DragEvent<HTMLDivElement>, shiftId: string, date: string) => void;
}
