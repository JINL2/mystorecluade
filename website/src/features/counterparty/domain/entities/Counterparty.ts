/**
 * Counterparty Entity
 * Represents a counterparty (customer or supplier)
 */

export type CounterpartyType = 'internal' | 'external';

export class Counterparty {
  constructor(
    public readonly counterpartyId: string,
    public readonly companyId: string,
    public readonly name: string,
    public readonly type: CounterpartyType,
    public readonly contact: string | null,
    public readonly email: string | null,
    public readonly phone: string | null,
    public readonly address: string | null,
    public readonly isActive: boolean,
    public readonly createdAt: Date
  ) {}

  /**
   * Get type display name
   */
  get typeDisplay(): string {
    return this.type === 'internal' ? 'Internal' : 'External';
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

  /**
   * Check if counterparty has contact info
   */
  get hasContactInfo(): boolean {
    return !!(this.contact || this.email || this.phone);
  }

  /**
   * Get initials for avatar
   */
  get initials(): string {
    return this.name
      .split(' ')
      .map((word) => word[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  }
}
