/**
 * ScheduleEmptyState Component Types
 */

export type EmptyStateVariant = 'no-store' | 'no-schedule' | 'error';

export interface ScheduleEmptyStateProps {
  /**
   * Type of empty state to display
   */
  variant: EmptyStateVariant;

  /**
   * Custom title (optional)
   */
  title?: string;

  /**
   * Custom message (optional)
   */
  message?: string;

  /**
   * Error message for error variant
   */
  error?: string;

  /**
   * Action button click handler
   */
  onAction?: () => void;

  /**
   * Action button text
   */
  actionText?: string;
}
