/**
 * SalaryRecord Entity
 * Domain layer - Business object representing employee salary record
 */

export class SalaryRecord {
  constructor(
    public readonly userId: string,
    public readonly fullName: string,
    public readonly email: string,
    public readonly roleName: string,
    public readonly storeName: string,
    public readonly baseSalary: number,
    public readonly bonuses: number,
    public readonly deductions: number,
    public readonly totalSalary: number,
    public readonly currencySymbol: string,
    public readonly currencyCode: string,
    public readonly paymentDate: string | null = null,
    public readonly status: 'pending' | 'paid' | 'processing' = 'pending'
  ) {}

  /**
   * Calculate net salary (after deductions)
   */
  get netSalary(): number {
    return this.totalSalary;
  }

  /**
   * Format currency amount
   */
  formatAmount(amount: number): string {
    return `${this.currencySymbol}${amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get formatted base salary
   */
  get formattedBaseSalary(): string {
    return this.formatAmount(this.baseSalary);
  }

  /**
   * Get formatted bonuses
   */
  get formattedBonuses(): string {
    return this.formatAmount(this.bonuses);
  }

  /**
   * Get formatted deductions
   */
  get formattedDeductions(): string {
    return this.formatAmount(this.deductions);
  }

  /**
   * Get formatted total salary
   */
  get formattedTotalSalary(): string {
    return this.formatAmount(this.totalSalary);
  }

  /**
   * Check if payment is overdue
   */
  get isOverdue(): boolean {
    if (!this.paymentDate || this.status === 'paid') return false;
    return new Date(this.paymentDate) < new Date();
  }

  /**
   * Factory method to create SalaryRecord
   */
  static create(data: {
    user_id: string;
    full_name: string;
    email: string;
    role_name: string;
    store_name: string;
    base_salary: number;
    bonuses: number;
    deductions: number;
    total_salary: number;
    currency_symbol: string;
    currency_code: string;
    payment_date?: string | null;
    status?: 'pending' | 'paid' | 'processing';
  }): SalaryRecord {
    return new SalaryRecord(
      data.user_id,
      data.full_name,
      data.email,
      data.role_name,
      data.store_name,
      data.base_salary || 0,
      data.bonuses || 0,
      data.deductions || 0,
      data.total_salary || 0,
      data.currency_symbol,
      data.currency_code,
      data.payment_date || null,
      data.status || 'pending'
    );
  }
}
