/**
 * CategoryTrendChart Types
 */

export interface TrendDataPoint {
  date: string;
  value: number;
}

export interface CategoryOption {
  id: string;
  name: string;
}

export interface CategoryTrendChartProps {
  data: TrendDataPoint[];
  categories: CategoryOption[];
  selectedCategoryId: string | null;
  onCategorySelect: (categoryId: string | null) => void;
  loading?: boolean;
  currencySymbol?: string;
  className?: string;
}
