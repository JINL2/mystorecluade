/**
 * BalanceSheetData Entity
 * Represents balance sheet financial data matching backup structure
 */

export interface BalanceSheetAccount {
  accountId: string;
  accountName: string;
  balance: number;
  formattedBalance: string;
}

export interface BalanceSheetSection {
  title: string;
  total: number;
  accounts: BalanceSheetAccount[];
}

export class BalanceSheetData {
  constructor(
    public readonly totalAssets: number,
    public readonly totalLiabilities: number,
    public readonly totalEquity: number,
    public readonly totalLiabilitiesAndEquity: number,
    public readonly totalCurrentAssets: number,
    public readonly totalNonCurrentAssets: number,
    public readonly totalCurrentLiabilities: number,
    public readonly totalNonCurrentLiabilities: number,
    public readonly currentAssets: BalanceSheetSection,
    public readonly nonCurrentAssets: BalanceSheetSection,
    public readonly currentLiabilities: BalanceSheetSection,
    public readonly nonCurrentLiabilities: BalanceSheetSection,
    public readonly equity: BalanceSheetSection,
    public readonly comprehensiveIncome: BalanceSheetSection,
    public readonly currencySymbol: string,
    public readonly asOfDate: string
  ) {}

  /**
   * Check if balance sheet equation is satisfied (Assets = Liabilities + Equity)
   */
  get isBalanced(): boolean {
    const diff = Math.abs(this.totalAssets - this.totalLiabilitiesAndEquity);
    return diff < 0.01;
  }

  /**
   * Calculate difference if not balanced
   */
  get balanceDifference(): number {
    return this.totalAssets - this.totalLiabilitiesAndEquity;
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
   * Calculate percentage of total
   */
  calculatePercentage(amount: number, total: number): number {
    if (total === 0) return 0;
    return (amount / total) * 100;
  }

  /**
   * Get assets percentage of total
   */
  get assetsPercentage(): string {
    return `100% of Total`;
  }

  /**
   * Get current assets percentage of total assets
   */
  get currentAssetsPercentage(): string {
    return `Current: ${this.calculatePercentage(this.totalCurrentAssets, this.totalAssets).toFixed(1)}%`;
  }

  /**
   * Get liabilities percentage of total
   */
  get liabilitiesPercentage(): string {
    const total = this.totalLiabilities + this.totalEquity;
    return `${this.calculatePercentage(this.totalLiabilities, total).toFixed(1)}% of Total`;
  }

  /**
   * Get equity percentage of total
   */
  get equityPercentage(): string {
    const total = this.totalLiabilities + this.totalEquity;
    return `${this.calculatePercentage(this.totalEquity, total).toFixed(1)}% of Total`;
  }

  /**
   * Get formatted date
   */
  get formattedDate(): string {
    return new Date(this.asOfDate).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  }
}
