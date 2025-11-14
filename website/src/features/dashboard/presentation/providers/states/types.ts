/**
 * Dashboard State Types
 * Type definitions for dashboard state management
 */

import type { ErrorMessageVariant } from '@/shared/components/common/ErrorMessage';

export interface DashboardErrorDialog {
  variant: ErrorMessageVariant;
  title: string;
  message: string;
  isOpen: boolean;
}
