/**
 * AccountMapping Entity
 * Represents an account mapping between two companies
 */

export type AccountType =
  | 'payable'
  | 'receivable'
  | 'contra_asset'
  | 'cash'
  | 'general'
  | 'fixed_asset'
  | 'equity';

export type MappingDirection = 'outgoing' | 'incoming' | 'both';

export class AccountMapping {
  constructor(
    public readonly mappingId: string,
    public readonly myCompanyId: string,
    public readonly myAccountName: string,
    public readonly myAccountCode: string | null,
    public readonly myCategoryTag: string,
    public readonly linkedCompanyId: string,
    public readonly linkedCompanyName: string,
    public readonly linkedAccountName: string,
    public readonly linkedAccountCode: string | null,
    public readonly linkedCategoryTag: string,
    public readonly direction: MappingDirection,
    public readonly createdAt: Date,
    public readonly isReadOnly: boolean = false
  ) {}

  /**
   * Get category display name
   */
  getCategoryDisplay(tag: string): string {
    switch (tag) {
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
        return tag;
    }
  }

  /**
   * Get direction display
   */
  get directionDisplay(): string {
    switch (this.direction) {
      case 'outgoing':
        return 'Outgoing';
      case 'incoming':
        return 'Incoming';
      case 'both':
        return 'Both Ways';
      default:
        return this.direction;
    }
  }

  /**
   * Check if mapping can be edited
   */
  get isEditable(): boolean {
    return !this.isReadOnly;
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
