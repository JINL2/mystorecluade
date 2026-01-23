/**
 * BcgScatterChart Component Types
 */

import type { BcgCategoryItem, BcgMatrixSuccess } from '../../../domain/entities/bcgMatrix';

export type XAxisMetric = 'revenue' | 'quantity';
export type DividerType = 'median' | 'mean';

export interface BcgChartDataPoint {
  id: string;
  name: string;
  x: number;  // Normalized 0-100
  y: number;  // Normalized 0-100
  radius: number;
  quadrant: 'star' | 'cash_cow' | 'problem_child' | 'dog';
  category: BcgCategoryItem;
}

export interface BcgScatterChartProps {
  data: BcgMatrixSuccess;
  loading?: boolean;
  currencySymbol?: string;
  className?: string;
}

export interface BcgToggleButtonProps {
  options: Array<{ value: string; label: string }>;
  selectedValue: string;
  onChange: (value: string) => void;
  className?: string;
}
