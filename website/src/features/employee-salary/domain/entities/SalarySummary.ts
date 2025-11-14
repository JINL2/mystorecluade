/**
 * SalarySummary Entity
 * Domain layer - Summary statistics for salary data
 */

export class SalarySummary {
  constructor(
    public readonly period: string,
    public readonly totalEmployees: number,
    public readonly totalSalary: number,
    public readonly averageSalary: number,
    public readonly totalBonuses: number,
    public readonly totalDeductions: number,
    public readonly currencySymbol: string
  ) {}

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
   * Get formatted total salary
   */
  get formattedTotalSalary(): string {
    return this.formatAmount(this.totalSalary);
  }

  /**
   * Get formatted average salary
   */
  get formattedAverageSalary(): string {
    return this.formatAmount(this.averageSalary);
  }

  /**
   * Get formatted total bonuses
   */
  get formattedTotalBonuses(): string {
    return this.formatAmount(this.totalBonuses);
  }

  /**
   * Get formatted total deductions
   */
  get formattedTotalDeductions(): string {
    return this.formatAmount(this.totalDeductions);
  }

  /**
   * Factory method to create SalarySummary
   */
  static create(data: {
    period: string;
    total_employees: number;
    total_salary: number;
    average_salary: number;
    total_bonuses: number;
    total_deductions: number;
    currency_symbol: string;
  }): SalarySummary {
    return new SalarySummary(
      data.period,
      data.total_employees || 0,
      data.total_salary || 0,
      data.average_salary || 0,
      data.total_bonuses || 0,
      data.total_deductions || 0,
      data.currency_symbol
    );
  }

  /**
   * Create empty summary
   */
  static empty(period: string, currencySymbol: string = '$'): SalarySummary {
    return new SalarySummary(period, 0, 0, 0, 0, 0, currencySymbol);
  }
}
