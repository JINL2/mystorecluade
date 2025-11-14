/**
 * Employee Entity
 * Domain layer - Business object representing an employee
 */

export class Employee {
  constructor(
    public readonly userId: string,
    public readonly fullName: string,
    public readonly email: string,
    public readonly roleId: string | null,
    public readonly roleIds: string[],
    public readonly roleName: string,
    public readonly roleNames: string[],
    public readonly storeId: string | null,
    public readonly storeIds: string[],
    public readonly storeName: string,
    public readonly storeNames: string[],
    public readonly salaryAmount: number,
    public readonly salaryType: 'monthly' | 'hourly',
    public readonly currencyId: string,
    public readonly currencyCode: string,
    public readonly currencySymbol: string,
    public readonly salaryId: string,
    public readonly companyId: string,
    public readonly accountId: string,
    public readonly profileImage: string | null = null,
    public readonly userRoleId: string | null = null
  ) {}

  /**
   * Get employee initials for avatar
   */
  get initials(): string {
    return this.fullName.charAt(0).toUpperCase();
  }

  /**
   * Get formatted salary with currency
   */
  get formattedSalary(): string {
    return `${this.currencyCode}${this.salaryAmount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get salary type label (per hour or per month)
   */
  get salaryTypeLabel(): string {
    return this.salaryType === 'hourly' ? 'per hour' : 'per month';
  }

  /**
   * Check if employee is active
   */
  get isActive(): boolean {
    // For now, all employees are considered active
    return true;
  }

  /**
   * Check if employee has multiple roles
   */
  get hasMultipleRoles(): boolean {
    return this.roleIds.length > 1;
  }

  /**
   * Check if employee is assigned to multiple stores
   */
  get hasMultipleStores(): boolean {
    return this.storeIds.length > 1;
  }

  /**
   * Get display role (primary + count if multiple)
   */
  get displayRole(): string {
    if (this.hasMultipleRoles) {
      return `${this.roleName} +${this.roleIds.length - 1}`;
    }
    return this.roleName;
  }

  /**
   * Get display store (primary + count if multiple)
   */
  get displayStore(): string {
    if (this.hasMultipleStores) {
      return `${this.storeName} +${this.storeIds.length - 1}`;
    }
    return this.storeName;
  }

  /**
   * Factory method to create Employee from raw data
   */
  static create(data: {
    user_id: string;
    full_name: string;
    email: string;
    role_id: string | null;
    role_ids: string[];
    role_name: string;
    role_names: string[];
    store_id: string | null;
    store_ids: string[];
    store_name: string;
    store_names: string[];
    salary_amount: number;
    salary_type: 'monthly' | 'hourly';
    currency_id: string;
    currency_code: string;
    currency_symbol: string;
    salary_id: string;
    company_id: string;
    account_id: string;
    profile_image?: string | null;
    user_role_id?: string | null;
  }): Employee {
    return new Employee(
      data.user_id,
      data.full_name,
      data.email,
      data.role_id,
      data.role_ids || [],
      data.role_name || 'No role assigned',
      data.role_names || [],
      data.store_id,
      data.store_ids || [],
      data.store_name || 'No store assigned',
      data.store_names || [],
      data.salary_amount || 0,
      data.salary_type || 'monthly',
      data.currency_id,
      data.currency_code,
      data.currency_symbol,
      data.salary_id,
      data.company_id,
      data.account_id,
      data.profile_image || null,
      data.user_role_id || null
    );
  }
}
