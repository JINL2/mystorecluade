/**
 * Counterparty Entity
 * Represents a counterparty (customer, supplier, internal organization)
 */

export type CounterpartyTypeValue =
  | 'My Company'
  | 'Team Member'
  | 'Suppliers'
  | 'Employees'
  | 'Customers'
  | 'Others';

export class Counterparty {
  constructor(
    public readonly counterpartyId: string,
    public readonly companyId: string,
    public readonly name: string,
    public readonly type: CounterpartyTypeValue,
    public readonly isInternal: boolean,
    public readonly linkedCompanyId: string | null,
    public readonly email: string | null,
    public readonly phone: string | null,
    public readonly notes: string | null,
    public readonly isDeleted: boolean,
    public readonly createdAt: Date
  ) {}

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
