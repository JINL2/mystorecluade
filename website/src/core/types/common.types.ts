/**
 * Common Types
 * Shared TypeScript types used across the application
 */

/**
 * API Response wrapper
 */
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

/**
 * Pagination params
 */
export interface PaginationParams {
  page: number;
  pageSize: number;
  totalCount?: number;
}

/**
 * Sort params
 */
export interface SortParams {
  column: string;
  ascending: boolean;
}

/**
 * Filter params
 */
export type FilterParams = Record<string, any>;

/**
 * Query options
 */
export interface QueryOptions {
  select?: string;
  filters?: FilterParams;
  orderBy?: SortParams;
  limit?: number;
  offset?: number;
}

/**
 * User session data
 */
export interface UserSessionData {
  userId: string;
  email: string;
  companyId?: string;
  storeId?: string;
}

/**
 * Loading state
 */
export interface LoadingState {
  loading: boolean;
  error: string | null;
}

/**
 * Form validation error
 */
export interface ValidationError {
  field: string;
  message: string;
}
