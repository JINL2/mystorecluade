/**
 * TopProductsPage Types
 */

import type { SalesAnalyticsItem, SalesMetric } from '../../../domain/entities/salesAnalytics';

export interface TopProductsPageProps {
  className?: string;
}

export interface TopProductListItemProps {
  rank: number;
  item: SalesAnalyticsItem;
  maxValue: number;
  metric: SalesMetric;
  currencySymbol: string;
}
