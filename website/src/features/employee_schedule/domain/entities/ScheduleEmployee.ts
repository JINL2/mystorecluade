/**
 * ScheduleEmployee Entity
 * Domain layer - Employee information for scheduling
 */

export interface StoreInfo {
  store_id: string;
  store_name: string;
}

export class ScheduleEmployee {
  constructor(
    public readonly userId: string,
    public readonly fullName: string,
    public readonly email: string,
    public readonly roleIds: string[],
    public readonly roleNames: string[],
    public readonly stores: StoreInfo[],
    public readonly companyId: string,
    public readonly companyName: string,
    public readonly salaryId: string | null,
    public readonly salaryAmount: string | null,
    public readonly salaryType: string | null,
    public readonly bonusAmount: string | null,
    public readonly currencyId: string | null,
    public readonly currencyCode: string | null,
    public readonly accountId: string | null
  ) {}

  /**
   * Get employee initials for avatar
   */
  get initials(): string {
    const names = this.fullName.trim().split(' ');
    if (names.length >= 2) {
      return (names[0].charAt(0) + names[names.length - 1].charAt(0)).toUpperCase();
    }
    return this.fullName.charAt(0).toUpperCase();
  }

  /**
   * Get primary role name
   */
  get primaryRole(): string {
    return this.roleNames[0] || 'No Role';
  }

  /**
   * Get display role (primary + count if multiple)
   */
  get displayRole(): string {
    if (this.roleNames.length > 1) {
      return `${this.primaryRole} +${this.roleNames.length - 1}`;
    }
    return this.primaryRole;
  }

  /**
   * Check if employee is assigned to specific store
   */
  isAssignedToStore(storeId: string): boolean {
    return this.stores.some((store) => store.store_id === storeId);
  }

  /**
   * Get store names as comma-separated string
   */
  get storeNamesString(): string {
    return this.stores.map((s) => s.store_name).join(', ');
  }
}
