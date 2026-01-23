/**
 * EmployeeSection Component Types
 */

import type { ScheduleEmployee } from '../../../domain/entities/ScheduleEmployee';

export interface EmployeeSectionProps {
  /**
   * List of employees
   */
  employees: ScheduleEmployee[];

  /**
   * Whether employees are loading
   */
  loading: boolean;

  /**
   * Currently dragged employee ID
   */
  draggedEmployeeId: string | null;

  /**
   * Show drag hint
   */
  showDragHint?: boolean;

  /**
   * Handle drag start
   */
  onDragStart: (e: React.DragEvent<HTMLDivElement>, employeeId: string) => void;

  /**
   * Handle drag end
   */
  onDragEnd: () => void;
}
