/**
 * Schedule State Types
 * Type definitions for schedule state management
 */

export interface WeekRange {
  startDate: string;
  endDate: string;
}

export interface ScheduleNotification {
  variant: 'success' | 'error' | 'warning' | 'info';
  title?: string;
  message: string;
}
