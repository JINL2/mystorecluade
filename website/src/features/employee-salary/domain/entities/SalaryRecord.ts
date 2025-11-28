/**
 * SalaryRecord Entity
 * Domain layer - Business object representing employee salary record
 */

export interface StorePayment {
  store_id: string;
  store_name: string;
  store_total_payment: number;
  worked_hours?: number;
  base_payment?: number;
  late_deduction?: number;
  bonus_amount?: number;
  overtime_amount?: number;
}

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
    public readonly salaryType: 'monthly' | 'hourly',
    public readonly stores: StorePayment[] = [],
    public readonly paymentDate: Date | null = null,
    public readonly status: 'pending' | 'paid' | 'processing' = 'pending',
    public readonly lateCount: number = 0,
    public readonly lateMinutes: number = 0,
    public readonly overtimeCount: number = 0,
    public readonly overtimeAmount: number = 0
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
   * Get formatted overtime amount
   */
  get formattedOvertimeAmount(): string {
    return this.formatAmount(this.overtimeAmount);
  }

  /**
   * Check if payment is overdue
   */
  get isOverdue(): boolean {
    if (!this.paymentDate || this.status === 'paid') return false;
    return this.paymentDate < new Date();
  }

  /**
   * Check if employee has payment in a specific store
   */
  hasPaymentInStore(storeId: string): boolean {
    const store = this.stores.find(s => s.store_id === storeId);
    return store ? store.store_total_payment > 0 : false;
  }

  /**
   * Get payment amount for a specific store
   */
  getStorePayment(storeId: string): number {
    const store = this.stores.find(s => s.store_id === storeId);
    return store?.store_total_payment || 0;
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
    salary_type: 'monthly' | 'hourly';
    stores?: StorePayment[];
    payment_date?: Date | null;
    status?: 'pending' | 'paid' | 'processing';
    late_count?: number;
    late_minutes?: number;
    overtime_count?: number;
    overtime_amount?: number;
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
      data.salary_type,
      data.stores || [],
      data.payment_date || null,
      data.status || 'pending',
      data.late_count || 0,
      data.late_minutes || 0,
      data.overtime_count || 0,
      data.overtime_amount || 0
    );
  }
}
