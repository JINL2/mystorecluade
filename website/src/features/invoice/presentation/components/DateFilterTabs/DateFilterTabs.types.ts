/**
 * DateFilterTabs Component Types
 */

export type DateFilterType = 'all' | 'today' | 'yesterday' | 'this-week' | 'this-month' | 'last-month' | 'custom';

export interface DateFilterTabsProps {
  activeFilter: DateFilterType;
  onFilterChange: (filter: DateFilterType, startDate: string, endDate: string) => void;
}
