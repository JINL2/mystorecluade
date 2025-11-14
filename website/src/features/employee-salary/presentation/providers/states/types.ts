/**
 * Shared Types for Salary State
 * Following 2025 Best Practice
 */

/**
 * Async operation result type
 */
export interface AsyncOperationResult {
  success: boolean;
  error?: string;
}

/**
 * Notification variant types
 */
export type NotificationVariant = 'success' | 'error' | 'warning' | 'info';

/**
 * Salary notification type
 */
export interface SalaryNotification {
  variant: NotificationVariant;
  message: string;
  title?: string;
}
