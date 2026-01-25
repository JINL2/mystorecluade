/**
 * EditEmployeeModal Types
 */

export interface EditEmployeeModalProps {
  isOpen: boolean;
  onClose: () => void;
  employee: {
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
  } | null;
  onSave: () => void;
}
