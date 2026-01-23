/**
 * Shared Types for Employee Setting State
 */

/**
 * Submit result interface
 */
export interface SubmitResult {
  success: boolean;
  error?: string;
}

/**
 * Selected employee data for editing
 */
export interface SelectedEmployeeData {
  userId: string;
  fullName: string;
  email: string;
  roleName: string;
  storeName: string;
  salaryType: 'monthly' | 'hourly';
  salaryAmount: number;
  currencyId: string;
  currencyCode: string;
  salaryId: string;
  companyId: string;
  accountId: string;
  initials: string;
}

/**
 * Delete confirmation data
 */
export interface DeleteConfirmData {
  userId: string;
  name: string;
}
