/**
 * AccountMapping Entity
 * Represents an account mapping configuration
 */

export type AccountType =
  | 'payable'
  | 'receivable'
  | 'contra_asset'
  | 'cash'
  | 'general'
  | 'fixed_asset'
  | 'equity';

export class AccountMapping {
  constructor(
    public readonly mappingId: string,
    public readonly companyId: string,
    public readonly accountCode: string,
    public readonly accountName: string,
    public readonly accountType: AccountType,
    public readonly description: string | null,
    public readonly isActive: boolean,
    public readonly createdAt: Date,
    public readonly isReadOnly: boolean = false
  ) {}

  /**
   * Get account type display name
   */
  get accountTypeDisplay(): string {
    switch (this.accountType) {
      case 'payable':
        return 'Payable';
      case 'receivable':
        return 'Receivable';
      case 'contra_asset':
        return 'Contra Asset';
      case 'cash':
        return 'Cash';
      case 'general':
        return 'General';
      case 'fixed_asset':
        return 'Fixed Asset';
      case 'equity':
        return 'Equity';
      default:
        return this.accountType;
    }
  }

  /**
   * Get account type color class
   */
  get accountTypeColor(): string {
    return this.accountType;
  }

  /**
   * Check if mapping can be edited
   */
  get isEditable(): boolean {
    return !this.isReadOnly && this.isActive;
  }

  /**
   * Check if mapping can be deleted
   */
  get isDeletable(): boolean {
    return !this.isReadOnly;
  }

  /**
   * Get formatted created date
   */
  get formattedCreatedDate(): string {
    return this.createdAt.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  }
}
