/**
 * CategoryAnalysisPage Types
 */

import type { DrillDownItem, DrillDownLevel } from '../../../domain/entities/drillDownAnalytics';

export interface CategoryAnalysisPageProps {
  className?: string;
}

export interface CategoryListItemProps {
  rank: number;
  item: DrillDownItem;
  maxRevenue: number;
  canDrillDown: boolean;
  currencySymbol: string;
  onItemClick: () => void;
}

export interface BreadcrumbItem {
  level: DrillDownLevel;
  parentId: string | null;
  label: string;
}
