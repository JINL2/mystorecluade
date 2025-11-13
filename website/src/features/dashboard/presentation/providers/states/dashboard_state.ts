/**
 * Dashboard State Interface
 * State interface definition for dashboard feature
 *
 * Following 2025 Best Practice:
 * - Zustand for state management
 * - Async operations in store
 * - Repository pattern integration
 */

import type { DashboardData } from '../../../domain/entities/DashboardData';
import type { DashboardErrorDialog } from './types';

export interface DashboardState {
  // ============================================
  // STATE
  // ============================================
  data: DashboardData | null;
  loading: boolean;
  error: string | null;
  errorDialog: DashboardErrorDialog;

  // ============================================
  // SYNCHRONOUS ACTIONS
  // ============================================
  setData: (data: DashboardData | null) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
  clearError: () => void;

  // ============================================
  // ASYNCHRONOUS ACTIONS
  // ============================================
  loadDashboardData: (companyId: string, currentDate: string) => Promise<void>;
  refresh: (companyId: string) => Promise<void>;
}
