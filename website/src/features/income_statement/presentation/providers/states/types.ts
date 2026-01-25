/**
 * Income Statement State Types
 * Shared type definitions for income statement state management
 */

import type {
  MonthlyIncomeStatementData,
  TwelveMonthIncomeStatementData
} from '../../../domain/entities/IncomeStatementData';

/**
 * Filter type for income statement queries
 */
export type IncomeStatementType = 'monthly' | '12month';

/**
 * Income statement filters
 */
export interface IncomeStatementFilters {
  type: IncomeStatementType;
  store: string | null;
  fromDate: string;
  toDate: string;
}

/**
 * Message state for error/success notifications
 */
export interface MessageState {
  isOpen: boolean;
  variant: 'error' | 'warning' | 'info' | 'success';
  title: string;
  message: string;
}

/**
 * Repository response type
 */
export interface RepositoryResponse<T> {
  success: boolean;
  data?: T;
  currency?: string;
  error?: string;
}
