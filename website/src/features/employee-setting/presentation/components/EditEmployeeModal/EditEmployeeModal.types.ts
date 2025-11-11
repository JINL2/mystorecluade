/**
 * EditEmployeeModal Types
 */

export interface Currency {
  currency_id: string;
  currency_code: string;
  currency_name: string;
  currency_symbol: string;
}

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
