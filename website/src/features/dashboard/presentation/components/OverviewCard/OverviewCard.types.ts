/**
 * OverviewCard Component Types
 */

import { ReactNode } from 'react';

export interface OverviewCardProps {
  title: string;
  value: string;
  icon: ReactNode;
  changePercentage?: number;
  isPositive?: boolean;
  loading?: boolean;
}
