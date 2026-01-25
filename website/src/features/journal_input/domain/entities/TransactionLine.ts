/**
 * TransactionLine Entity
 * Represents a single transaction line (debit or credit) in a journal entry
 */

export class TransactionLine {
  constructor(
    public readonly isDebit: boolean,
    public readonly accountId: string,
    public readonly accountName: string,
    public readonly amount: number,
    public readonly description: string,
    public readonly categoryTag: string | null,
    public readonly cashLocationId: string | null,
    public readonly cashLocationName: string | null,
    public readonly cashLocationType: string | null,
    public readonly counterpartyId: string | null,
    public readonly counterpartyName: string | null,
    public readonly counterpartyStoreId: string | null,
    public readonly counterpartyStoreName: string | null,
    public readonly debtCategory: string | null,
    // Additional debt fields for p_lines alignment
    public readonly interestRate: number | null = null,
    public readonly interestAccountId: string | null = null,
    public readonly interestDueDay: number | null = null,
    public readonly issueDate: string | null = null,
    public readonly dueDate: string | null = null,
    public readonly debtDescription: string | null = null,
    public readonly linkedCompanyId: string | null = null,
    // Counterparty cash location for mirror journal (p_if_cash_location_id)
    public readonly counterpartyCashLocationId: string | null = null
  ) {}

  /**
   * Get transaction type display
   */
  get typeDisplay(): string {
    return this.isDebit ? 'DEBIT' : 'CREDIT';
  }

  /**
   * Check if transaction line is valid
   */
  get isValid(): boolean {
    return !!(this.accountId && this.amount > 0);
  }
}
