/**
 * SalesAnalysisPage Types
 */

export interface SalesAnalysisPageProps {
  // Add props as needed
}

export interface MonthlyMetrics {
  revenue: number;
  margin: number;
  marginRate: number;
  quantity: number;
}

export interface GrowthMetrics {
  revenuePct: number;
  marginPct: number;
  quantityPct: number;
}

export interface SalesDashboard {
  thisMonth: MonthlyMetrics;
  lastMonth: MonthlyMetrics;
  growth: GrowthMetrics;
}

export interface BcgCategory {
  categoryId: string;
  categoryName: string;
  totalRevenue: number;
  marginRatePct: number;
  totalQuantity: number;
  revenuePct: number;
  quadrant: 'star' | 'cash_cow' | 'problem_child' | 'dog';
}
