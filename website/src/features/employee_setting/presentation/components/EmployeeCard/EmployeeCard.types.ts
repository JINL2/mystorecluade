/**
 * EmployeeCard Component Types
 */

export interface EmployeeCardProps {
  userId: string;
  fullName: string;
  email: string;
  roleName: string;
  storeName: string;
  formattedSalary: string;
  salaryTypeLabel: string;
  initials: string;
  isActive: boolean;
  onEdit?: (userId: string) => void;
  onDelete?: (userId: string) => void;
}
