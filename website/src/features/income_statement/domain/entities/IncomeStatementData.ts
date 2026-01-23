/**
 * IncomeStatementData Entity
 * Represents income statement (P&L) financial data
 *
 * Following Clean Architecture and ARCHITECTURE.md:
 * - Class-based Entity with camelCase properties
 * - Business logic and computed properties in Entity
 * - No external dependencies
 */

/**
 * Account in a subcategory
 */
export class IncomeStatementAccount {
  constructor(
    public readonly accountName: string,
    public readonly netAmount: number,
    public readonly monthlyAmounts?: Record<string, number>,
    public readonly total?: number
  ) {}

  /**
   * Get formatted net amount
   */
  get formattedNetAmount(): string {
    return this.netAmount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });
  }

  /**
   * Get amount for a specific month
   */
  getMonthlyAmount(month: string): number {
    return this.monthlyAmounts?.[month] ?? 0;
  }

  /**
   * Get formatted monthly amount
   */
  getFormattedMonthlyAmount(month: string): string {
    return this.getMonthlyAmount(month).toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });
  }
}

/**
 * Subcategory with accounts
 */
export class IncomeStatementSubcategory {
  constructor(
    public readonly subcategoryName: string,
    public readonly subcategoryTotal: number,
    public readonly accounts: IncomeStatementAccount[],
    public readonly subcategoryMonthlyTotals?: Record<string, number>
  ) {}

  /**
   * Get formatted subcategory total
   */
  get formattedSubcategoryTotal(): string {
    return this.subcategoryTotal.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });
  }

  /**
   * Get monthly total for a specific month
   */
  getMonthlyTotal(month: string): number {
    return this.subcategoryMonthlyTotals?.[month] ?? 0;
  }
}

/**
 * Section with subcategories
 */
export class IncomeStatementSection {
  constructor(
    public readonly sectionName: string,
    public readonly sectionTotal: number,
    public readonly subcategories: IncomeStatementSubcategory[],
    public readonly sectionMonthlyTotals?: Record<string, number>
  ) {}

  /**
   * Get formatted section total
   */
  get formattedSectionTotal(): string {
    return this.sectionTotal.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });
  }

  /**
   * Get monthly total for a specific month
   */
  getMonthlyTotal(month: string): number {
    return this.sectionMonthlyTotals?.[month] ?? 0;
  }

  /**
   * Check if this is a margin section (should be hidden in table)
   */
  get isMarginSection(): boolean {
    return this.sectionName.toLowerCase().includes('margin');
  }

  /**
   * Get CSS-friendly section type for styling
   */
  get sectionType(): string {
    return this.sectionName.toLowerCase().replace(/ /g, '-');
  }
}

/**
 * Period info for 12-month view
 */
export interface PeriodInfo {
  startDate: string;
  endDate: string;
  storeScope: 'all_stores' | 'single_store';
  storeName?: string;
  timezone?: string;
}

/**
 * Monthly Income Statement Data
 */
export class MonthlyIncomeStatementData {
  constructor(
    public readonly sections: IncomeStatementSection[],
    public readonly currencySymbol: string = '$'
  ) {}

  /**
   * Get revenue amount
   */
  get revenue(): number {
    const revenueSection = this.sections.find(
      (s) => s.sectionName.toLowerCase() === 'revenue'
    );
    return revenueSection?.sectionTotal ?? 0;
  }

  /**
   * Get gross profit amount
   */
  get grossProfit(): number {
    const section = this.sections.find(
      (s) => s.sectionName.toLowerCase() === 'gross profit'
    );
    return section?.sectionTotal ?? 0;
  }

  /**
   * Get operating income amount
   */
  get operatingIncome(): number {
    const section = this.sections.find(
      (s) => s.sectionName.toLowerCase() === 'operating income'
    );
    return section?.sectionTotal ?? 0;
  }

  /**
   * Get net income amount
   */
  get netIncome(): number {
    const section = this.sections.find(
      (s) => s.sectionName.toLowerCase() === 'net income'
    );
    return section?.sectionTotal ?? 0;
  }

  /**
   * Get EBITDA amount
   */
  get ebitda(): number {
    const section = this.sections.find(
      (s) => s.sectionName.toLowerCase() === 'ebitda'
    );
    return section?.sectionTotal ?? 0;
  }

  /**
   * Get gross margin percentage
   */
  get grossMargin(): number {
    const section = this.sections.find(
      (s) => s.sectionName.toLowerCase() === 'gross margin'
    );
    return typeof section?.sectionTotal === 'number' ? section.sectionTotal : 0;
  }

  /**
   * Get operating margin percentage
   */
  get operatingMargin(): number {
    const section = this.sections.find(
      (s) => s.sectionName.toLowerCase() === 'operating margin'
    );
    return typeof section?.sectionTotal === 'number' ? section.sectionTotal : 0;
  }

  /**
   * Get net margin percentage
   */
  get netMargin(): number {
    const section = this.sections.find(
      (s) => s.sectionName.toLowerCase() === 'net margin'
    );
    return typeof section?.sectionTotal === 'number' ? section.sectionTotal : 0;
  }

  /**
   * Get EBITDA margin percentage
   */
  get ebitdaMargin(): number {
    if (this.revenue === 0) return 0;
    return (this.ebitda / this.revenue) * 100;
  }

  /**
   * Format currency amount
   */
  formatCurrency(amount: number): string {
    return `${this.currencySymbol}${amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get sections to display in table (excludes margin sections)
   */
  get displaySections(): IncomeStatementSection[] {
    return this.sections.filter((s) => !s.isMarginSection);
  }
}

/**
 * 12-Month Income Statement Data
 */
export class TwelveMonthIncomeStatementData {
  constructor(
    public readonly sections: IncomeStatementSection[],
    public readonly months: string[],
    public readonly periodInfo: PeriodInfo,
    public readonly currencySymbol: string = '$'
  ) {}

  /**
   * Format month display (2025-01 -> 2025 JAN)
   */
  formatMonth(monthString: string): string {
    const [year, month] = monthString.split('-');
    const monthNames = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    const monthIndex = parseInt(month, 10) - 1;
    return `${year} ${monthNames[monthIndex]}`;
  }

  /**
   * Format currency amount
   */
  formatCurrency(amount: number): string {
    return `${this.currencySymbol}${amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get period display string
   */
  get periodDisplay(): string {
    return `${this.periodInfo.startDate} to ${this.periodInfo.endDate}`;
  }

  /**
   * Get store display string
   */
  get storeDisplay(): string {
    if (this.periodInfo.storeName) {
      return this.periodInfo.storeName;
    }
    return 'ALL STORES';
  }

  /**
   * Get sections to display in table (excludes margin sections)
   */
  get displaySections(): IncomeStatementSection[] {
    return this.sections.filter((s) => !s.isMarginSection);
  }
}

/**
 * Combined type for both views (for backward compatibility)
 */
export type IncomeStatementData = MonthlyIncomeStatementData | TwelveMonthIncomeStatementData;
