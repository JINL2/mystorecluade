/**
 * Dashboard Data Entity
 * Domain layer - Business object representing dashboard data
 */

export interface Currency {
  symbol: string;
  currency_code: string;
}

export interface ExpenseBreakdown {
  category: string;
  amount: number;
  percentage: number;
}

export interface RecentTransaction {
  id: string;
  date: string;
  description: string;
  amount: number;
  type: 'income' | 'expense';
  category?: string;
}

export class DashboardData {
  constructor(
    public readonly todayRevenue: number,
    public readonly todayExpense: number,
    public readonly thisMonthRevenue: number,
    public readonly lastMonthRevenue: number,
    public readonly currency: Currency,
    public readonly expenseBreakdown: ExpenseBreakdown[],
    public readonly recentTransactions: RecentTransaction[]
  ) {}

  /**
   * Calculate today's profit
   */
  get todayProfit(): number {
    return this.todayRevenue - this.todayExpense;
  }

  /**
   * Calculate month-over-month growth percentage
   */
  get monthOverMonthGrowth(): number {
    if (this.lastMonthRevenue === 0) return 0;
    return ((this.thisMonthRevenue - this.lastMonthRevenue) / this.lastMonthRevenue) * 100;
  }

  /**
   * Check if this month is performing better than last month
   */
  get isGrowthPositive(): boolean {
    return this.monthOverMonthGrowth > 0;
  }

  /**
   * Format currency with symbol
   */
  formatCurrency(value: number): string {
    return `${this.currency.symbol}${value.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get formatted today revenue
   */
  get formattedTodayRevenue(): string {
    return this.formatCurrency(this.todayRevenue);
  }

  /**
   * Get formatted today expense
   */
  get formattedTodayExpense(): string {
    return this.formatCurrency(this.todayExpense);
  }

  /**
   * Get formatted this month revenue
   */
  get formattedThisMonthRevenue(): string {
    return this.formatCurrency(this.thisMonthRevenue);
  }

  /**
   * Get formatted last month revenue
   */
  get formattedLastMonthRevenue(): string {
    return this.formatCurrency(this.lastMonthRevenue);
  }

  /**
   * Factory method to create DashboardData from raw data
   */
  static create(data: {
    today_revenue: number;
    today_expense: number;
    this_month_revenue: number;
    last_month_revenue: number;
    currency: Currency;
    expense_breakdown: ExpenseBreakdown[];
    recent_transactions: RecentTransaction[];
  }): DashboardData {
    return new DashboardData(
      data.today_revenue || 0,
      data.today_expense || 0,
      data.this_month_revenue || 0,
      data.last_month_revenue || 0,
      data.currency || { symbol: '$', currency_code: 'USD' },
      data.expense_breakdown || [],
      data.recent_transactions || []
    );
  }
}
