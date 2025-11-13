/**
 * Invoice State Types
 * Shared type definitions for invoice state management
 */

import type { PaginationInfo, InvoiceDetailResult } from '../../../domain/repositories/IInvoiceRepository';

/**
 * Date filter type for invoice queries
 * Must match DateFilterTabs component type exactly
 */
export type DateFilterType = 'all' | 'today' | 'yesterday' | 'this-week' | 'this-month' | 'last-month' | 'custom';

/**
 * Date range for invoice filtering
 */
export interface DateRange {
  start: string;
  end: string;
}

/**
 * Invoice filters
 */
export interface InvoiceFilters {
  storeId: string | null;
  searchQuery: string;
  dateRange: DateRange;
  dateFilterType: DateFilterType;
}

/**
 * Invoice detail data (imported from repository)
 */
export type InvoiceDetail = NonNullable<InvoiceDetailResult['data']>;

/**
 * Repository response type
 */
export interface RepositoryResponse<T> {
  success: boolean;
  data?: T;
  pagination?: PaginationInfo;
  error?: string;
  message?: string;
}

/**
 * Refund result type
 */
export interface RefundResult {
  success: boolean;
  message?: string;
  error?: string;
}
